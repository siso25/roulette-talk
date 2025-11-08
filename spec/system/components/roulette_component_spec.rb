# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RoulettesAndButtons', type: :system do
  let!(:roulette) { create(:roulette) }
  let!(:speakers) { create_list(:speaker, 4, roulette: roulette) }
  let!(:talk_themes) { create_list(:talk_theme, 4, roulette: roulette) }

  scenario '1行のトークテーマの表示', js: true do
    talk_themes.first.update(theme: '1行')

    visit "/rails/view_components/roulette/component/with_roulette_id?roulette_id=#{roulette.id}"

    # 表示行数の確認
    element = find('.theme__label', match: :first)
    line_count = element['clientHeight'].to_i / element.style('line-height')['line-height'][/[0-9.-]+/].to_i
    expect(line_count).to eq 1

    # 表示位置と表示角度の確認
    left = element.style('left')['left'][/[0-9.-]+/].to_f
    top = element.style('top')['top'][/[0-9.-]+/].to_f
    transform = element.style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    rotate_angle = (Math.atan2(transform[1], transform[0]) * 180 / Math::PI).round
    expect(left).to eq 20.2082
    expect(top).to eq(-130.208)
    expect(rotate_angle).to eq(-45)
  end

  scenario '2行のトークテーマの表示', js: true do
    talk_themes.first.update(theme: 'とても長いトークテーマのタイトルです。改行されることを確認します。')

    visit "/rails/view_components/roulette/component/with_roulette_id?roulette_id=#{roulette.id}"

    # 表示行数の確認
    element = find('.theme__label', match: :first)
    line_count = element['clientHeight'].to_i / element.style('line-height')['line-height'][/[0-9.-]+/].to_i
    expect(line_count).to eq 2

    # 表示位置と表示角度の確認
    left = element.style('left')['left'][/[0-9.-]+/].to_f
    top = element.style('top')['top'][/[0-9.-]+/].to_f
    transform = element.style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    rotate_angle = (Math.atan2(transform[1], transform[0]) * 180 / Math::PI).round
    expect(left).to eq 20.2082
    expect(top).to eq(-140.208)
    expect(rotate_angle).to eq(-45)
  end
end
