# frozen_string_literal: true

class TemplatesController < ApplicationController
  def create
    roulette = Roulette.find_by(id: params[:roulette_id])

    if roulette && roulette.talk_themes.count.positive?
      new_roulette = Roulette.create
      Template.create_talk_themes(new_roulette, roulette.talk_themes)
      flash.notice = '新規ルーレットを作成しました。話す人を登録して使い始めましょう！'
      redirect_to roulette_path(new_roulette)
    else
      flash.alert = 'ルーレットの作成に失敗しました。トークテーマは一件以上登録してください。'
      redirect_to roulette_path(roulette)
    end
  end
end
