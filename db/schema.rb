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

ActiveRecord::Schema.define(version: 20161227135756) do

  create_table "answers", force: :cascade do |t|
    t.string   "content"
    t.boolean  "correct"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "status",      default: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "exams", force: :cascade do |t|
    t.string   "title"
    t.integer  "status",     default: 1
    t.integer  "course_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "exams", ["course_id"], name: "index_exams_on_course_id"

  create_table "lessons", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "course_id"
  end

  add_index "lessons", ["course_id"], name: "index_lessons_on_course_id"

  create_table "questions", force: :cascade do |t|
    t.string   "content"
    t.integer  "exam_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "questions", ["exam_id"], name: "index_questions_on_exam_id"

  create_table "user_answers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.boolean  "correct",      default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_exam_id"
  end

  add_index "user_answers", ["answer_id"], name: "index_user_answers_on_answer_id"
  add_index "user_answers", ["question_id"], name: "index_user_answers_on_question_id"
  add_index "user_answers", ["user_id"], name: "index_user_answers_on_user_id"

  create_table "user_exams", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "exam_id"
    t.integer  "score",      default: 0
    t.boolean  "passed",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "user_exams", ["exam_id"], name: "index_user_exams_on_exam_id"
  add_index "user_exams", ["user_id"], name: "index_user_exams_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "first_name",             default: "",         null: false
    t.string   "last_name",              default: "",         null: false
    t.string   "role",                   default: "regullar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
