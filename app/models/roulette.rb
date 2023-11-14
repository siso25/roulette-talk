class Roulette < ApplicationRecord
  has_many :talk_themes, dependent: :destroy

  class << self
    def conic_gradient_text(targets)
      targets_count = targets.count
      angle = 360 / targets_count
      colors = create_color_array(targets_count)

      background_texts = []
      targets.each_with_index do |_target, idx|
        background_texts << "#{colors[idx]} #{angle * idx}deg #{angle * (idx + 1)}deg"
      end

      "background: conic-gradient(#{background_texts.join(',')});"
    end

    def create_color_array(num)
      color_array = ['#EC9376']
      colors = ['#90CDFB', '#ECBE75', '#E3E986', '#A9F0D1']

      (1..num - 1).each do |idx|
        color_array[idx] = colors[idx % 4]
      end

      color_array
    end
  end
end
