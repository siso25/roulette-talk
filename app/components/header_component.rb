# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def render?
    !current_page?(root_path)
  end
end
