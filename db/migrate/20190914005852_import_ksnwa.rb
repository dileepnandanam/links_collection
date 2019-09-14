class ImportKsnwa < ActiveRecord::Migration[5.2]
  def change
    create_table "answers", force: :cascade do |t|
      t.integer "response_id"
      t.integer "question_id"
      t.text "text"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "chats", force: :cascade do |t|
      t.integer "sender_id"
      t.integer "reciver_id"
      t.text "text"
      t.boolean "seen", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "comments", force: :cascade do |t|
      t.text "text"
      t.integer "user_id"
      t.integer "post_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "parent_id"
    end

    create_table "connections", force: :cascade do |t|
      t.integer "user_id"
      t.integer "to_user_id"
      t.integer "last_seen_post_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "groups", force: :cascade do |t|
      t.integer "user_id"
      t.string "name"
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "notifications", force: :cascade do |t|
      t.integer "user_id"
      t.integer "post_id"
      t.integer "comment_id"
      t.text "message"
      t.boolean "seen", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "action"
      t.string "target_type"
      t.integer "target_id"
    end

    create_table "posts", force: :cascade do |t|
      t.text "text"
      t.integer "user_id"
      t.integer "post_user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "group_id"
      t.string "image_file_name"
      t.string "image_content_type"
      t.bigint "image_file_size"
      t.datetime "image_updated_at"
      t.string "title"
    end

    create_table "questions", force: :cascade do |t|
      t.integer "user_id"
      t.text "text"
      t.integer "sequence", default: 0
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "group_id"
    end

    create_table "responses", force: :cascade do |t|
      t.integer "user_id"
      t.integer "responce_user_id"
      t.boolean "accepted", default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "group_id"
    end

    add_column :users, :name, :string
    add_column :users, :image_file_name, :string
    add_column :users, :image_content_type, :string
    add_column :users, :image_file_size, :bigint
    add_column :users, :image_updated_at, :datetime
    add_column :users, :badwords, :text
    add_column :users, :pin, :string

    add_column :users, :gender, :string

    create_table "votes", force: :cascade do |t|
      t.integer "user_id"
      t.integer "post_id"
      t.integer "weight"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "comment_id"
    end
  end
end
