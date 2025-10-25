# frozen_string_literal: true

class Roulettes::RoulettesAndButtons::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(talk_themes:, speakers:)
    @talk_themes = talk_themes
    @speakers = speakers
  end
end
