require 'rails_helper'

RSpec.describe Roulette, type: :model do
  it 'returns a string of conic grandient property' do
    roulette = Roulette.new
    talk_theme1 = roulette.talk_themes.build(theme: 'theme1')
    talk_theme2 = roulette.talk_themes.build(theme: 'theme2')
    talk_theme3 = roulette.talk_themes.build(theme: 'theme3')
    talk_theme4 = roulette.talk_themes.build(theme: 'theme4')
    talk_theme5 = roulette.talk_themes.build(theme: 'theme5')
    color_set = ['#E38692', '#6EB7DB', '#C97FB4', '#E5D972', '#64C99B']
    talk_themes = [talk_theme1, talk_theme2, talk_theme3, talk_theme4, talk_theme5]
    css_text = Roulette.conic_gradient_text(talk_themes, color_set)
    expect(css_text).to eq 'background: conic-gradient(#E38692 0deg 72deg,#6EB7DB 72deg 144deg,#C97FB4 144deg 216deg,#E5D972 216deg 288deg,#64C99B 288deg 360deg);'
  end

  it 'returns a string of label position' do
    text = 'あいうえおかきく'
    radius = 170
    count = 5
    index = 0
    left_plus = 100
    top_plus = 10
    label_position = Roulette.label_position_and_angle(text, radius, count, index, left_plus, top_plus)
    expect(label_position).to eq 'left: -0.07650711027956447px; top: -147.53288904374108px; transform: rotate(-54deg);'
  end

  it 'add twice top_plus when text longer than 8 characters' do
    text = 'あいうえおかきくけ'
    radius = 170
    count = 5
    index = 0
    left_plus = 100
    top_plus = 10
    label_position = Roulette.label_position_and_angle(text, radius, count, index, left_plus, top_plus)
    expect(label_position).to eq 'left: -0.07650711027956447px; top: -157.53288904374108px; transform: rotate(-54deg);'
  end
end
