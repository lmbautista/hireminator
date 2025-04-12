# frozen_string_literal: true

# TODO: Improve trazability of errors for each step: we won't know what resource fail and why
# We should add a wrapper at Application::Record level to format the errors as a Response.failure
# Also, we should track the step when the process fails
#
class Chat
  def initialize(use_case:, user:, message_content:)
    @use_case = use_case
    @user = user
    @message_content = message_content
    @messages = []
  end

  def call
    with_audit do
      try_resume_conversation
        .and_then { try_start_conversation }
        .and_then { send_user_message }
        .and_then { try_finish_conversation }
        .and_then { try_archive_conversation }
        .and_then { response_success }
    end
  end

  private

  attr_reader :use_case, :user, :conversation, :message_content, :messages

  def with_audit(&)
    audit_params = {
      event: conversation.next_conversation_step,
      initiator_data: user.to_initiator_data,
      params: { use_case_id: use_case.id, conversation_id: conversation.id, user_id: user.id }
    }

    Auditing.new(**audit_params).call(&)
  end

  def conversation
    return @conversation if defined?(@conversation)

    @conversation = Conversation.in_progress.find_by(user:, use_case:)
    @conversation ||= Conversation.create!(user:, use_case:, status: Conversation::STATUS_OPENED)
  end

  def try_resume_conversation
    return response_success unless conversation.can_be_resumed?

    messages = create_system_generated_messages(conversation.use_case.resume_prompt)
    communicate_with_client(messages)
  rescue StandardError => e
    Response.failure("Error during #try_resume_conversation: #{e.message}")
  end

  def try_start_conversation
    return response_success unless conversation.can_be_started?

    messages = create_system_generated_messages(conversation.use_case.initial_prompt)
    communicate_with_client(messages)
  rescue StandardError => e
    Response.failure("Error during #try_start_conversation: #{e.message}")
  end

  def try_finish_conversation
    return response_success unless conversation.can_be_finished?
    return response_success if conversation.use_case.final_prompt.blank?

    messages = create_system_generated_messages(conversation.use_case.final_prompt)
    communicate_with_client(messages)
      .and_then do
      full_transcription = Digest::MD5.hexdigest(all_messages.map(&:values).map do
        _1.join(" - ")
      end.join("\n "))
      conversation.update!(status: Conversation::STATUS_COMPLETED,
                           ended_at: Time.zone.now,
                           full_transcript: full_transcription)
      response_success
    end
  rescue StandardError => e
    Response.failure("Error during #try_finish_conversation: #{e.message}")
  end

  def try_archive_conversation
    return response_success unless conversation.can_be_archived?
    return response_success if conversation.use_case.extraction_prompt.blank?

    messages = create_system_generated_messages(conversation.use_case.extraction_prompt)
    communicate_with_client(messages, true).and_then do
      output = conversation.messages.order(created_at: :desc).find_by(role: Message::ROLE_ASSISTANT).content
      response = JsonExtractor.call(output)
      raise response.value unless response.success?

      conversation.update!(status: Conversation::STATUS_ARCHIVED, archived_at: Time.zone.now,
                           output: response.value)
      response_success
    end
  rescue StandardError => e
    Response.failure("Error during #try_archive_conversation: #{e.message}")
  end

  def create_system_generated_messages(propmt_payload)
    messages = []
    messages << Message.create!(role: Message::ROLE_SYSTEM,
                                content: propmt_payload["system"],
                                sender: conversation.user,
                                conversation:,
                                system_generated: true)
    messages << Message.create!(role: Message::ROLE_USER,
                                content: propmt_payload["user"],
                                sender: conversation.user,
                                conversation:,
                                system_generated: true)
    messages
  end

  def send_user_message
    return response_success if message_content.blank?

    messages = [Message.create!(
      conversation:,
      sender: user,
      role: Message::ROLE_USER,
      content: message_content.to_json
    )]

    communicate_with_client(messages)
  end

  def communicate_with_client(messages, system_generated = false)
    client.call(all_messages)
      .and_then { |response_message| create_response_message(response_message, system_generated) }
      .and_then { handle_client_success(messages) }
      .on_failure { return handle_client_error(messages, _1) }
  end

  def all_messages
    conversation.messages.order(:created_at).map do |message|
      { role: message.role, content: message.content }
    end
  end

  def client
    @client ||= ProviderManager.new(conversation:)
  end

  def handle_client_error(messages, error)
    messages.map { _1.update!(status: Message::STATUS_FAILED) }
    Response.failure(error)
  end

  def handle_client_success(messages)
    messages.map { _1.update!(status: Message::STATUS_SENT) }
    response_success
  end

  def create_response_message(response_message, system_generated)
    ai_agent_attrs = response_message.symbolize_keys.slice(:role, :content)
    attrs = {
      role: ai_agent_attrs.fetch(:role),
      content: ai_agent_attrs.fetch(:content),
      sender: conversation.user,
      conversation:,
      system_generated:,
      status: Message::STATUS_SENT
    }

    Message.create!(**attrs)
    response_success
  end

  def response_success
    Response.success(conversation)
  end
end
