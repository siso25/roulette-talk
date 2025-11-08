# frozen_string_literal: true

require 'rails_helper'

# Showはコンポーネントではないが、システムテストでルーレットの時間をコントロールしづらいため、ViewComponentのプレビュー機能を使ってテストする
RSpec.describe 'Show', type: :system do
  let!(:roulette) { create(:roulette) }
  let!(:speakers) { create_list(:speaker, 4, roulette: roulette) }
  let!(:talk_themes) { create_list(:talk_theme, 4, roulette: roulette) }

  scenario 'Session storageに保存された結果を表示する', js: true do
    visit "/rails/view_components/show/component/with_roulette_id?roulette_id=#{roulette.id}"
    click_button 'スタート'
    result_text = find "[data-rotate-target='resultText']", wait: 10
    session_storage_items = JSON.parse(evaluate_script("sessionStorage.getItem('view_components')"))
    expect(result_text).to have_content(session_storage_items['talkResult'])
    expect(result_text).to have_content(session_storage_items['speakerResult'])
    expect(find('#talk_themes_list').find('.line-through')).to have_content session_storage_items['talkResult']
    expect(find('#speakers_list').find('.line-through')).to have_content session_storage_items['speakerResult']

    # トークテーマルーレットが正しい位置で止まっているか検証
    talk_transform = find('.roulette__theme').style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    # 点の位置から角度を算出する
    talk_rotate_angle = (Math.atan2(talk_transform[1], talk_transform[0]) * 180 / Math::PI).round
    talk_lottery_result = [0, 1, 2, 3].difference(session_storage_items['talk'])
    talk_deg = (45 - 90 * talk_lottery_result[0]).to_f.round
    # 初期状態で4番目の要素は上側にあるので、4番目の要素が選ばれた時だけ一周分足す
    talk_deg_processed = talk_deg < -180 ? talk_deg + 360 : talk_deg
    # 真ん中で止まった位置を0としてプラスマイナス44の範囲に収まっているか検証
    expect(talk_rotate_angle).to be >= talk_deg_processed - 44
    expect(talk_rotate_angle).to be <= talk_deg_processed + 44

    # 話す人ルーレットが正しい位置で止まっているか検証
    speaker_transform = find('.roulette__speaker').style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    speaker_rotate_angle = (Math.atan2(speaker_transform[1], speaker_transform[0]) * 180 / Math::PI).round
    speaker_lottery_result = [0, 1, 2, 3].difference(session_storage_items['speaker'])
    speaker_deg = (45 - 90 * speaker_lottery_result[0]).to_f.round
    speaker_deg_processed = speaker_deg < -180 ? speaker_deg + 360 : speaker_deg
    expect(speaker_rotate_angle).to be >= speaker_deg_processed - 44
    expect(speaker_rotate_angle).to be <= speaker_deg_processed + 44
  end

  scenario '登録されたトークテーマと話す人の件数を超えた回数ルーレットを回した場合は選択状態をリセットする', js: true do
    roulette2 = Roulette.create
    create_list(:talk_theme, 2, roulette: roulette2)
    create_list(:speaker, 2, roulette: roulette2)
    visit "/rails/view_components/show/component/with_roulette_id?roulette_id=#{roulette2.id}"
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    expect(find('#talk_themes_list')).to have_selector '.line-through'
    expect(find('#speakers_list')).to have_selector '.line-through'
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    session_storage_items1 = JSON.parse(evaluate_script("sessionStorage.getItem('view_components')"))
    expect(session_storage_items1['talk'].size).to eq 0
    expect(session_storage_items1['speaker'].size).to eq 0
    expect(find('#talk_themes_list')).not_to have_selector '.line-through'
    expect(find('#speakers_list')).not_to have_selector '.line-through'
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    # session storageがリセットされた上で一回ルーレットが実行されるのでsizeは1になる
    session_storage_items2 = JSON.parse(evaluate_script("sessionStorage.getItem('view_components')"))
    expect(session_storage_items2['talk'].size).to eq 1
    expect(session_storage_items2['speaker'].size).to eq 1
  end

  scenario 'リセットボタンを押すと選択状態がリセットされる', js: true do
    visit "/rails/view_components/show/component/with_roulette_id?roulette_id=#{roulette.id}"
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    session_storage_items1 = JSON.parse(evaluate_script("sessionStorage.getItem('view_components')"))
    expect(session_storage_items1['talk'].size).to eq 3
    expect(session_storage_items1['speaker'].size).to eq 3
    expect(find('#talk_themes_list')).to have_selector '.line-through'
    expect(find('#speakers_list')).to have_selector '.line-through'
    click_button 'リセット'
    session_storage_items2 = JSON.parse(evaluate_script("sessionStorage.getItem('view_components')"))
    expect(session_storage_items2['talk'].size).to eq 4
    expect(session_storage_items2['speaker'].size).to eq 4
    expect(find('#talk_themes_list')).not_to have_selector '.line-through'
    expect(find('#speakers_list')).not_to have_selector '.line-through'
  end
end
