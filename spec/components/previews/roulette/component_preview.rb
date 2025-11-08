# frozen_string_literal: true

class Roulette::ComponentPreview < ViewComponent::Preview
  def with_default
    roulette = Roulette.first
    render Roulettes::Roulette::Component.new(talk_themes: roulette.talk_themes, speakers: roulette.speakers)
  end

  def with_roulette_id(roulette_id:)
    roulette = Roulette.find(roulette_id)
    render Roulettes::Roulette::Component.new(talk_themes: roulette.talk_themes, speakers: roulette.speakers)
  end
end
