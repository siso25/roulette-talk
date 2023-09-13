class CreateRoulettes < ActiveRecord::Migration[7.0]
  def change
    create_table :roulettes, id: :uuid do |t|
      t.timestamps
    end
  end
end
