# frozen_string_literal: true

class Header::Component < ViewComponent::Base
  def initialize(flash:)
    @flash = flash
  end

  def render?
    !current_page?(root_path)
  end
end
