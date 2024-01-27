class AddIndexToTalkThemesAndSpeakers < ActiveRecord::Migration[7.0]
  def change
    add_index :talk_themes, :created_at
    add_index :speakers, :created_at
  end
end
