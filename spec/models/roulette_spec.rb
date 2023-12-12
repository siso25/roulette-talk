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
end
