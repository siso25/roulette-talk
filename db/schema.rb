# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_01_27_091718) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "roulettes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "speakers", force: :cascade do |t|
    t.uuid "roulette_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_speakers_on_created_at"
    t.index ["roulette_id"], name: "index_speakers_on_roulette_id"
  end

  create_table "talk_themes", force: :cascade do |t|
    t.uuid "roulette_id"
    t.string "theme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_talk_themes_on_created_at"
    t.index ["roulette_id"], name: "index_talk_themes_on_roulette_id"
  end

  add_foreign_key "speakers", "roulettes"
  add_foreign_key "talk_themes", "roulettes"
end
