# frozen_string_literal: true

class TalkThemes::TalkTheme::Component < ViewComponent::Base
  with_collection_parameter :talk_theme
  include Turbo::FramesHelper

  def initialize(talk_theme:, roulette:)
    @talk_theme = talk_theme
    @roulette = roulette
  end
end
