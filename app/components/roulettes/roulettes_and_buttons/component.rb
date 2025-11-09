# frozen_string_literal: true

class Roulettes::RoulettesAndButtons::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(talk_themes:, speakers:, talk_theme_rotate_time: Roulette::TALK_THEME_ROTATE_TIME, speaker_rotate_time: Roulette::SPEAKER_ROTATE_TIME)
    @talk_themes = talk_themes
    @speakers = speakers
    @talk_theme_rotate_time = talk_theme_rotate_time
    @speaker_rotate_time = speaker_rotate_time
  end
end
