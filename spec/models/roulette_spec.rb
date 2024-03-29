# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Roulette, type: :model do
  describe 'create background color property' do
    before do
      @roulette = Roulette.new
      @color_set = ['#6EB7DB', '#E38692', '#64C99B', '#E5D972', '#C97FB4']
    end

    it 'returns third color' do
      talk_theme = [FactoryBot.build(:talk_theme, roulette: @roulette)]
      css_text = Roulette.generate_background_color_text(talk_theme, @color_set)
      expect(css_text).to eq 'background: conic-gradient(#64C99B 0deg 360deg);'
    end

    it 'returns third and fourth colors' do
      talk_themes = []
      2.times do
        talk_themes << FactoryBot.build(:talk_theme, roulette: @roulette)
      end
      css_text = Roulette.generate_background_color_text(talk_themes, @color_set)
      expect(css_text).to eq 'background: conic-gradient(#64C99B 0deg 180deg,#E5D972 180deg 360deg);'
    end

    it 'returns first through third colors' do
      talk_themes = []
      3.times do
        talk_themes << FactoryBot.build(:talk_theme, roulette: @roulette)
      end
      css_text = Roulette.generate_background_color_text(talk_themes, @color_set)
      expect(css_text).to eq 'background: conic-gradient(#6EB7DB 0deg 120deg,#E38692 120deg 240deg,#64C99B 240deg 360deg);'
    end

    it 'returns first through fourth colors' do
      talk_themes = []
      4.times do
        talk_themes << FactoryBot.build(:talk_theme, roulette: @roulette)
      end
      css_text = Roulette.generate_background_color_text(talk_themes, @color_set)
      expect(css_text).to eq 'background: conic-gradient(#6EB7DB 0deg 90deg,#E38692 90deg 180deg,#64C99B 180deg 270deg,#E5D972 270deg 360deg);'
    end

    it 'returns first through fifth colors' do
      talk_themes = []
      5.times do
        talk_themes << FactoryBot.build(:talk_theme, roulette: @roulette)
      end
      css_text = Roulette.generate_background_color_text(talk_themes, @color_set)
      expect(css_text).to eq 'background: conic-gradient(#6EB7DB 0deg 72deg,#E38692 72deg 144deg,#64C99B 144deg 216deg,#E5D972 216deg 288deg,'\
                             '#C97FB4 288deg 360deg);'
    end

    it 'returns first through fifth colors and third color' do
      talk_themes = []
      6.times do
        talk_themes << FactoryBot.build(:talk_theme, roulette: @roulette)
      end
      css_text = Roulette.generate_background_color_text(talk_themes, @color_set)
      expect(css_text).to eq 'background: conic-gradient(#6EB7DB 0deg 60deg,#E38692 60deg 120deg,#64C99B 120deg 180deg,#E5D972 180deg 240deg,'\
                             '#C97FB4 240deg 300deg,#64C99B 300deg 360deg);'
    end
  end
end
