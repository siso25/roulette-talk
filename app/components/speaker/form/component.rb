# frozen_string_literal: true

class Speaker::Form::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(roulette:, speaker:, button_label:)
    @roulette = roulette
    @speaker = speaker
    @button_label = button_label
  end
end
