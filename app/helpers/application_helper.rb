# frozen_string_literal: true

module ApplicationHelper
  def flash_class_for(type)
    case type.to_sym
    when :notice
      "bg-green-100 text-green-800 border border-green-300"
    when :alert
      "bg-red-100 text-red-800 border border-red-300"
    else
      "bg-gray-100 text-gray-800 border border-gray-300"
    end
  end
end
