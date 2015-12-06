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

ActiveRecord::Schema.define(version: 20151206220733) do

  create_table "creneaus", force: :cascade do |t|
    t.integer  "Nombre_de_Participants_Necessaires"
    t.integer  "event_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "date_debut"
    t.datetime "date_fin"
  end

  add_index "creneaus", ["event_id"], name: "index_creneaus_on_event_id"

  create_table "disponibilites", force: :cascade do |t|
    t.integer  "creneau_id"
    t.integer  "participant_id"
    t.integer  "active"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "disponibilites", ["creneau_id"], name: "index_disponibilites_on_creneau_id"
  add_index "disponibilites", ["participant_id"], name: "index_disponibilites_on_participant_id"

  create_table "events", force: :cascade do |t|
    t.string   "Nom"
    t.integer  "Nombre_de_Creneaux"
    t.integer  "Nombre_de_Participants"
    t.integer  "Nombre_de_Creneaux_par_Participant"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "participants", force: :cascade do |t|
    t.string   "nom"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "participants", ["event_id"], name: "index_participants_on_event_id"

end
