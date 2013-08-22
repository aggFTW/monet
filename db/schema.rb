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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130821235559) do

  create_table "addresses", :force => true do |t|
    t.string   "number"
    t.string   "street"
    t.string   "neighborhood"
    t.string   "zip"
    t.string   "interior"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "charges", :force => true do |t|
    t.string   "name"
    t.date     "datedue"
    t.float    "amount"
    t.string   "ctype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "charges_students", :force => true do |t|
    t.integer "student_id"
    t.integer "charge_id"
  end

  create_table "classis", :force => true do |t|
    t.date     "dateof"
    t.time     "timeof"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "classis_students", :force => true do |t|
    t.integer "student_id"
    t.integer "classi_id"
  end

  create_table "discharges", :force => true do |t|
    t.date     "dateof"
    t.string   "reason"
    t.integer  "student_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "eassistance", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "classi_id"
    t.date     "payed"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "employees", :force => true do |t|
    t.string   "role"
    t.float    "salary"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "employees_groups", :force => true do |t|
    t.integer "employee_id"
    t.integer "group_id"
  end

  create_table "expenses", :force => true do |t|
    t.text     "description"
    t.date     "dateof"
    t.float    "amount"
    t.string   "etype"
    t.integer  "employee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.time     "schedule"
    t.string   "days"
    t.integer  "schoolyear_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "groups_students", :force => true do |t|
    t.integer "student_id"
    t.integer "group_id"
  end

  create_table "payments", :force => true do |t|
    t.date     "dateof"
    t.float    "amount"
    t.text     "comment"
    t.integer  "student_id"
    t.integer  "charge_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ptype"
  end

  create_table "people", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.date     "dob"
    t.string   "sex"
    t.string   "cellr"
    t.string   "email"
    t.integer  "dad_id"
    t.integer  "mom_id"
    t.integer  "address_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schoolyears", :force => true do |t|
    t.string   "name"
    t.date     "beginning"
    t.date     "end"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.float    "stdTuition"
    t.float    "stdTuitionSiblings"
    t.string   "state"
    t.float    "stdInscription"
    t.float    "stdMaterial"
    t.float    "stdExposition"
  end

  create_table "siblingrelations", :force => true do |t|
    t.integer "person_id"
    t.integer "sibling_id"
  end

  create_table "students", :force => true do |t|
    t.string   "school"
    t.float    "sInscription"
    t.float    "sMaterial"
    t.float    "sExposition"
    t.float    "sTuition"
    t.string   "sType"
    t.integer  "person_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.integer  "utype"
    t.string   "password"
    t.string   "password_digest"
    t.integer  "person_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "works", :force => true do |t|
    t.string   "title"
    t.string   "technique"
    t.integer  "student_id"
    t.integer  "schoolyear_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
