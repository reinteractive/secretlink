# encoding: UTF-8
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

ActiveRecord::Schema[6.1].define(version: 20170408130142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_tokens", force: :cascade do |t|
    t.string   "email"
    t.string   "hashed_token"
    t.datetime "expire_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "secrets", force: :cascade do |t|
    t.string   "title"
    t.string   "from_email"
    t.string   "to_email"
    t.text     "encrypted_secret"
    t.string   "encrypted_secret_salt"
    t.string   "encrypted_secret_iv"
    t.string   "uuid"
    t.text     "comments"
    t.datetime "expire_at"
    t.datetime "consumed_at"
    t.string   "secret_file"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "access_key"
  end

end
