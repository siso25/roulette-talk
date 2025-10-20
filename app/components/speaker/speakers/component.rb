# frozen_string_literal: true

class Speaker::Speakers::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(roulette:, speakers:)
    @roulette = roulette
    @speakers = speakers
  end
end
