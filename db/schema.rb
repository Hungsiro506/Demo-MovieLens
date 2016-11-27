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

ActiveRecord::Schema.define(version: 20161125044144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.boolean  "like",        default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "movies", force: :cascade do |t|
    t.integer "movielens_id"
    t.string  "title"
    t.text    "genres",                           default: [], array: true
    t.string  "imdb_id"
    t.string  "poster_url"
    t.float   "imdb_rating"
    t.text    "imdb_tagline"
    t.string  "imdb_mpaa_rating"
    t.string  "imdb_url"
    t.integer "imdb_votes"
    t.integer "cached_rating_count"
    t.float   "cached_average_rating"
    t.text    "actors",                            default: [], array: true
    t.string  "movie_type",                  limit: 50
    t.string  "year",                  limit: 50
  end

  create_table "rateds", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "movie_id"
    t.float    "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "movielens_user_id"
    t.integer  "movielens_movie_id"
    t.float    "rating"
    t.datetime "rated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "admin",                  default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
