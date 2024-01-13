# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      site: 'RouletteTalk',
      title: 'トークテーマルーレット作成ツール',
      reverse: true,
      charset: 'utf-8',
      description: 'トークテーマと話す人を設定したルーレットを作成・保存できます。オンライン飲み会やイベント等でお使いください。',
      viewport: 'width=device-width,initial-scale=1',
      icon: { href: image_url('favicon.ico') },
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png')
      },
      twitter: {
        card: 'summary_large_image'
      }
    }
  end
end
