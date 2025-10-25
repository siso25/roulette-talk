# frozen_string_literal: true

class TalkThemes::ComponentPreview < ViewComponent::Preview
  def with_default
    roulette = Roulette.first
    render TalkThemes::Component.new(talk_themes: roulette.talk_themes, roulette: roulette)
  end

  def with_roulette_id(roulette_id:)
    roulette = Roulette.find(roulette_id)
    render TalkThemes::Component.new(talk_themes: roulette.talk_themes, roulette: roulette)
  end
end
