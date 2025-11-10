# frozen_string_literal: true

class Speakers::Speaker::Component < ViewComponent::Base
  with_collection_parameter :speaker
  include Turbo::FramesHelper

  def initialize(speaker:, roulette:)
    @speaker = speaker
    @roulette = roulette
  end
end
