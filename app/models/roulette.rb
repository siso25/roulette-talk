# frozen_string_literal: true

class Roulette < ApplicationRecord
  has_many :talk_themes, dependent: :destroy
  has_many :speakers, dependent: :destroy

  class << self
    def generate_background_color_text(targets, color_set)
      targets_count = targets.count
      angle = 360 / targets_count
      colors = create_color_array(targets_count, color_set)

      background_texts = []
      targets.each_with_index do |_target, idx|
        background_texts << "#{colors[idx]} #{angle * idx}deg #{angle * (idx + 1)}deg"
      end

      "background: conic-gradient(#{background_texts.join(',')});"
    end

    private

    def create_color_array(num, colors)
      color_array = colors * (num / colors.size)
      color_array << case num % colors.size
                     when 1
                       colors[2]
                     when 2
                       colors[2..3]
                     when 3
                       colors[0..2]
                     when 4
                       colors[0..3]
                     else
                       []
                     end

      color_array.flatten
    end
  end
end
