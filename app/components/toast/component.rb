# frozen_string_literal: true

class Toast::Component < ViewComponent::Base
  def initialize(type:, message:)
    @type = type
    @message = message
  end

  private

  def color_class
    case @type
    when 'notice'
      'alert-success'
    when 'alert'
      'alert-error'
    else
      ''
    end
  end
end
