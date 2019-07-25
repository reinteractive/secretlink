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

ActiveRecord::Schema.define(version: 20190725064036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_logs", force: :cascade do |t|
    t.string   "key"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "activity_logs", ["owner_type", "owner_id"], name: "index_activity_logs_on_owner_type_and_owner_id", using: :btree
  add_index "activity_logs", ["recipient_type", "recipient_id"], name: "index_activity_logs_on_recipient_type_and_recipient_id", using: :btree
  add_index "activity_logs", ["trackable_type", "trackable_id"], name: "index_activity_logs_on_trackable_type_and_trackable_id", using: :btree

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
    t.datetime "extended_at"
    t.boolean  "no_email"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "code"
    t.integer  "status"
    t.json     "cached_metadata"
    t.json     "cached_transaction_details"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "user_settings", force: :cascade do |t|
    t.text    "send_secret_email_template"
    t.integer "user_id"
  end

  add_index "user_settings", ["user_id"], name: "index_user_settings_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                     default: "", null: false
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_otp_secret"
    t.string   "encrypted_otp_secret_iv"
    t.string   "encrypted_otp_secret_salt"
    t.integer  "consumed_timestep"
    t.boolean  "otp_required_for_login"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "user_settings", "users"
end
