# frozen_string_literal: true

class Speakers::ComponentPreview < ViewComponent::Preview
  def with_default
    roulette = Roulette.first
    render Speakers::Component.new(speakers: roulette.speakers, roulette: roulette)
  end

  def with_roulette_id(roulette_id:)
    roulette = Roulette.find(roulette_id)
    render Speakers::Component.new(speakers: roulette.speakers, roulette: roulette)
  end
end
