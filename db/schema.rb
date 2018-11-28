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

ActiveRecord::Schema.define(version: 2018_11_28_054622) do

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.integer "flag"
    t.integer "company_type_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_type_id"], name: "index_companies_on_company_type_id"
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "company_types", force: :cascade do |t|
    t.string "name"
    t.boolean "client"
    t.integer "flag"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_company_types_on_user_id"
  end

  create_table "file_managers", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_file_managers_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_file_managers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "yokyu_children", force: :cascade do |t|
    t.string "name"
    t.string "default_col"
    t.integer "flag"
    t.integer "custom"
    t.integer "user_id"
    t.integer "yokyu_parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flag", "user_id", "yokyu_parent_id"], name: "index_yokyu_children_on_flag_and_user_id_and_yokyu_parent_id"
    t.index ["user_id"], name: "index_yokyu_children_on_user_id"
    t.index ["yokyu_parent_id"], name: "index_yokyu_children_on_yokyu_parent_id"
  end

  create_table "yokyu_denpyos", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "yokyu_parent_id"
    t.integer "hospital"
    t.integer "vendor"
    t.integer "child"
    t.integer "parent"
    t.integer "file_manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_manager_id"], name: "index_yokyu_denpyos_on_file_manager_id"
    t.index ["user_id", "created_at"], name: "index_yokyu_denpyos_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_yokyu_denpyos_on_user_id"
    t.index ["yokyu_parent_id"], name: "index_yokyu_denpyos_on_yokyu_parent_id"
  end

  create_table "yokyu_parents", force: :cascade do |t|
    t.string "name"
    t.string "default_col"
    t.integer "flag"
    t.integer "default_set"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flag", "user_id", "name"], name: "index_yokyu_parents_on_flag_and_user_id_and_name"
    t.index ["user_id"], name: "index_yokyu_parents_on_user_id"
  end

end
