# frozen_string_literal: true

class TalkTheme::Form::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(roulette:, talk_theme:, button_label:)
    @roulette = roulette
    @talk_theme = talk_theme
    @button_label = button_label
  end
end
