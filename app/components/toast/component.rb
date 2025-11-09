# frozen_string_literal: true

class Toast::Component < ViewComponent::Base
  def initialize(type:, message:)
    @type = type
    @message = message
  end
end
