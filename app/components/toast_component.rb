# frozen_string_literal: true

class ToastComponent < ViewComponent::Base
  def initialize(flash:)
    @flash = flash
  end
end
