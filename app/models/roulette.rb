class Roulette < ApplicationRecord
  has_many :talk_themes, dependent: :destroy
  has_many :speakers, dependent: :destroy

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

    def label_position_and_angle(radius, count, index, left_plus, top_plus)
      angle = 360 / count
      item_position_angle = angle / 2 + angle * index
      radian = calc_radian(item_position_angle) * Math::PI / 180
      x = Math.cos(radian) * radius
      y = Math.sin(radian) * radius

      if item_position_angle >= 270
        x *= -1
        y *= -1
      elsif item_position_angle >= 180
        x *= -1
      elsif item_position_angle < 90
        y *= -1
      end

      rotate_angle = calc_rotate_angle(item_position_angle)
      "left: #{x - left_plus}px; top: #{y - top_plus}px; transform: rotate(#{rotate_angle}deg);"
    end

    def calc_radian(angle)
      return 90 - angle if angle < 90
      return angle - 90 if angle < 180
      return 270 - angle if angle < 270

      angle - 270
    end

    def calc_rotate_angle(angle)
      return angle - 540 if (angle - 90) > 270

      angle - 90
    end
  end
end
