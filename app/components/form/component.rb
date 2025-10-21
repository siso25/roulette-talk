# frozen_string_literal: true

class Form::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(roulette:, model:, column:, placeholder:, button_label:)
    @roulette = roulette
    @model = model
    @column = column
    @placeholder = placeholder
    @button_label = button_label
  end
end
