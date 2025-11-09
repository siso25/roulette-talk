# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ToastHelper, type: :helper do
  context 'flash_class' do
    it 'typeがnoticeなら処理成功表示用のクラスを返す' do
      expect(helper.flash_class('notice')).to eq('absolute top-4 right-2 w-72 shadow-xl alert z-10 opacity-90 pointer-events-none alert-success')
    end

    it 'typeがalertならエラー用のクラスを返す' do
      expect(helper.flash_class('alert')).to eq('absolute top-4 right-2 w-72 shadow-xl alert z-10 opacity-90 pointer-events-none alert-error')
    end
  end
end
