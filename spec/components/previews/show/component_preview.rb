# frozen_string_literal: true

class Show::ComponentPreview < ViewComponent::Preview
  def with_default
    roulette = Roulette.first
    render_with_template(
      template: 'show/preview_template',
      locals: {
        roulette: roulette,
        talk_themes: roulette.talk_themes,
        speakers: roulette.speakers
      }
    )
  end

  def with_roulette_id(roulette_id:)
    roulette = Roulette.find(roulette_id)
    render_with_template(
      template: 'show/preview_template',
      locals: {
        roulette: roulette,
        talk_themes: roulette.talk_themes,
        speakers: roulette.speakers
      }
    )
  end
end
