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

ActiveRecord::Schema[7.0].define(version: 2024_12_01_042551) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "collab_requests", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "reciever_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "playlist_id"
    t.index ["playlist_id"], name: "index_collab_requests_on_playlist_id"
    t.index ["reciever_id"], name: "index_collab_requests_on_reciever_id"
    t.index ["sender_id", "reciever_id"], name: "index_collab_requests_on_sender_id_and_reciever_id", unique: true
    t.index ["sender_id"], name: "index_collab_requests_on_sender_id"
  end

  create_table "editors_playlists", force: :cascade do |t|
    t.integer "playlist_id", null: false
    t.integer "user_id", null: false
    t.index ["playlist_id", "user_id"], name: "index_editors_playlists_on_playlist_id_and_user_id", unique: true
    t.index ["playlist_id"], name: "index_editors_playlists_on_playlist_id"
    t.index ["user_id"], name: "index_editors_playlists_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "playlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_likes_on_playlist_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "message"
    t.integer "recipient_id", null: false
    t.integer "sender_id", null: false
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "editor_id"
    t.index ["editor_id"], name: "index_playlists_on_editor_id"
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "playlist_id"
    t.index ["playlist_id"], name: "index_tags_on_playlist_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "track_id"
    t.string "title"
    t.string "source"
    t.integer "playlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.integer "addedby"
    t.index ["playlist_id"], name: "index_tracks_on_playlist_id"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type '' for column 'avatar'

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collab_requests", "playlists"
  add_foreign_key "editors_playlists", "playlists"
  add_foreign_key "editors_playlists", "users"
  add_foreign_key "likes", "playlists"
  add_foreign_key "likes", "users"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "notifications", "users", column: "sender_id"
  add_foreign_key "playlists", "users"
  add_foreign_key "tags", "playlists"
  add_foreign_key "tracks", "playlists"
end
