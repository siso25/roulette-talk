class CreateTalkThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :talk_themes do |t|
      t.references :roulette, type: :uuid, foreign_key: true
      t.string :theme

      t.timestamps
    end
  end
end
