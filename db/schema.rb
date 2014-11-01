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

ActiveRecord::Schema.define(version: 20141101113318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_categories", force: true do |t|
    t.string "name", null: false
  end

  add_index "course_categories", ["name"], name: "index_course_categories_on_name", unique: true, using: :btree

  create_table "courses", force: true do |t|
    t.string  "name",        null: false
    t.text    "description", null: false
    t.string  "location",    null: false
    t.integer "seats",       null: false
    t.integer "category_id", null: false
  end

  add_index "courses", ["name"], name: "index_courses_on_name", unique: true, using: :btree

  create_table "courses_organizers", id: false, force: true do |t|
    t.integer "course_id",    null: false
    t.integer "organizer_id", null: false
  end

  add_index "courses_organizers", ["course_id", "organizer_id"], name: "index_courses_organizers_on_course_id_and_organizer_id", using: :btree

  create_table "groups", force: true do |t|
    t.string "name", null: false
  end

  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree

  create_table "lessons", force: true do |t|
    t.integer  "course_id", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at",   null: false
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "lesson_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "group_id",                            null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
