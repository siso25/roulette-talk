class CreateSpeakers < ActiveRecord::Migration[7.0]
  def change
    create_table :speakers do |t|
      t.references :roulette, type: :uuid, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
