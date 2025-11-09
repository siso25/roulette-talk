# frozen_string_literal: true

class Show::ComponentPreview < ViewComponent::Preview
  def with_default
    roulette = Roulette.first
    render_with_template(
      template: 'show/preview_template',
      locals: {
        roulette: roulette,
        talk_themes: roulette.talk_themes,
        speakers: roulette.speakers,
        talk_theme_rotate_time: Roulette::TALK_THEME_ROTATE_TIME,
        speaker_rotate_time: Roulette::SPEAKER_ROTATE_TIME
      }
    )
  end

  def with_roulette_id(roulette_id:, talk_theme_rotate_time: Roulette::TALK_THEME_ROTATE_TIME, speaker_rotate_time: Roulette::SPEAKER_ROTATE_TIME)
    roulette = Roulette.find(roulette_id)
    render_with_template(
      template: 'show/preview_template',
      locals: {
        roulette: roulette,
        talk_themes: roulette.talk_themes,
        speakers: roulette.speakers,
        talk_theme_rotate_time: talk_theme_rotate_time,
        speaker_rotate_time: speaker_rotate_time
      }
    )
  end
end
