# frozen_string_literal: true

class Roulettes::Roulette::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(talk_themes:, speakers:)
    @talk_themes = talk_themes
    @speakers = speakers
  end
end
