# frozen_string_literal: true

class Toast::Component < ViewComponent::Base
  def initialize(flash:)
    @flash = flash
  end
end
