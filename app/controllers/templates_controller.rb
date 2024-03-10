# frozen_string_literal: true

class TemplatesController < ApplicationController
  def create
    roulette = Roulette.find_by(id: params[:roulette_id])

    # if roulette && roulette.talk_themes.count.positive?
    # new_roulette = Roulette.create
    # Template.create_talk_themes(new_roulette, roulette.talk_themes)
    # Speaker.create_initial_records(new_roulette)
    # redirect_to roulette_path(new_roulette)
    @roulette = roulette
    @talk_themes = roulette.talk_themes.order(:created_at)
    @speakers = roulette.speakers.order(:created_at)
    flash.now[:notice] = '新規ルーレットを作成しました！'
    render template: 'roulettes/show'
    # else
    #   flash[:notice] = '新規ルーレットを作成しました！'
    #   render roulette_path(roulette)
    #   render 'roulettes/show'
    # end
  end
end
