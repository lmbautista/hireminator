# frozen_string_literal: true

class ChatsController < ApplicationController
  before_action :set_user

  def index
    @use_cases = UseCase.all
    @conversation = Conversation.new
    @messages = []
    @message = Message.new
  end

  def show
    @use_cases = UseCase.all
    @conversation = Conversation.find(params[:id])
    @use_case = @conversation.use_case
    @messages = @conversation&.public_messages&.order(created_at: :asc)
    @message = Message.new

    render :index
  rescue ActiveRecord::RecordNotFound
    redirect_to chats_path, notice: "Conversación no encontrada"
  end

  def upsert
    if upset_params[:use_case_id].blank?
      redirect_to chats_path,
                  notice: "Por favor selecciona un agente/proceso" and return
    end

    @use_case = UseCase.find(upset_params[:use_case_id])

    result = Chat.new(
      user: @user,
      use_case: @use_case,
      message_content: upset_params[:content]
    ).call

    if result.success?
      redirect_to chat_path(result.value.id)
    else
      error_message = [
        "Hubo un error al procesar tu mensaje.",
        result.value
      ]
      redirect_to chats_path, alert: error_message.join("\n")
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to chats_path, notice: "Agente no encontrado"
  end

  private

  def upset_params
    return {} if params[:conversation].blank?

    params.require(:conversation).permit(:use_case_id, :content, :id).to_h
  end

  # This is a placeholder. In a real application, you would retrieve the current user from
  # the session or authentication system.
  def set_user
    @user = User.first # TODO: replace with actual user authentication
  end
end
