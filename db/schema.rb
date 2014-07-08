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

ActiveRecord::Schema.define(version: 20140708022149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: true do |t|
    t.string   "title",                        null: false
    t.string   "quality",                      null: false
    t.string   "course_title",                 null: false
    t.integer  "price"
    t.string   "isbn"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sold",         default: false
    t.string   "isbn13"
    t.string   "author"
    t.integer  "buyer_id"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id",    null: false
    t.text     "body",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_forms", force: true do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.string   "subject"
    t.text     "message",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "needs", force: true do |t|
    t.string   "title",      null: false
    t.string   "author",     null: false
    t.string   "isbn"
    t.string   "isbn13"
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", force: true do |t|
    t.integer  "user_id",                    null: false
    t.integer  "book_id",                    null: false
    t.integer  "amount",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted",   default: false
  end

  add_index "offers", ["user_id", "book_id"], name: "index_offers_on_user_id_and_book_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "year"
    t.string   "phone"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
