# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def initialize(flash:)
    @flash = flash
  end

  def render?
    !current_page?(root_path)
  end
end
