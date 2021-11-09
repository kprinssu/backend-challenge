# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20211109231913) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "member_friendships", force: :cascade do |t|
    t.bigint "friend1_id"
    t.bigint "friend2_id"
    t.index ["friend1_id", "friend2_id"], name: "uniq_friendships", unique: true
    t.index ["friend1_id"], name: "index_member_friendships_on_friend1_id"
    t.index ["friend2_id"], name: "index_member_friendships_on_friend2_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", null: false
    t.string "personal_website", null: false
    t.string "shortened_url"
    t.json "h1"
    t.json "h2"
    t.json "h3"
  end

  add_foreign_key "member_friendships", "members", column: "friend1_id"
  add_foreign_key "member_friendships", "members", column: "friend2_id"
end
