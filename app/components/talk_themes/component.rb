# frozen_string_literal: true

class TalkThemes::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(roulette:, talk_themes:)
    @roulette = roulette
    @talk_themes = talk_themes
  end
end
