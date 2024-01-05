# frozen_string_literal: true

class Roulette < ApplicationRecord
  has_many :talk_themes, dependent: :destroy
  has_many :speakers, dependent: :destroy

  class << self
    def conic_gradient_text(targets, color_set)
      targets_count = targets.count
      angle = 360 / targets_count
      colors = create_color_array(targets_count, color_set)

      background_texts = []
      targets.each_with_index do |_target, idx|
        background_texts << "#{colors[idx]} #{angle * idx}deg #{angle * (idx + 1)}deg"
      end

      "background: conic-gradient(#{background_texts.join(',')});"
    end

    def label_position_and_angle(text, radius, count, index, left_plus)
      angle = 360 / count
      item_position_angle = angle / 2 + angle * index
      top_plus = 10 # topの調整用
      position = calc_top_and_left_postion(text, item_position_angle, radius, left_plus, top_plus)
      rotate_angle = calc_rotate_angle(item_position_angle)
      "left: #{position[0]}px; top: #{position[1]}px; transform: rotate(#{rotate_angle}deg);"
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

    def calc_top_and_left_postion(text, angle, radius, left_plus, top_plus)
      radian = calc_radian(angle) * Math::PI / 180
      left_postion = Math.cos(radian) * radius
      top_position = Math.sin(radian) * radius

      if angle >= 270
        left_postion *= -1
        top_position *= -1
      elsif angle >= 180
        left_postion *= -1
      elsif angle < 90
        top_position *= -1
      end

      top_position -= if text.size > 8
                        top_plus * 2
                      else
                        top_plus
                      end
      left_postion -= left_plus

      [left_postion, top_position]
    end
  end
end
