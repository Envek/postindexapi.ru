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

ActiveRecord::Schema.define(version: 20130730032923) do

  create_table "post_indices", id: false, force: true do |t|
    t.string "index",     limit: 6,  null: false
    t.string "ops_name",  limit: 60
    t.string "ops_type",  limit: 50
    t.string "ops_subm",  limit: 6
    t.string "region",    limit: 60
    t.string "autonom",   limit: 60
    t.string "area",      limit: 60
    t.string "city",      limit: 60
    t.string "city_1",    limit: 60
    t.date   "act_date"
    t.string "index_old", limit: 6
  end

  add_index "post_indices", ["index_old"], name: "index_post_indices_on_index_old", using: :btree
  add_index "post_indices", ["region", "area"], name: "index_post_indices_on_region_and_area", using: :btree
  add_index "post_indices", ["region", "autonom", "area", "city"], name: "index_post_indices_on_region_and_autonom_and_area_and_city", using: :btree
  add_index "post_indices", ["region", "autonom", "area"], name: "index_post_indices_on_region_and_autonom_and_area", using: :btree
  add_index "post_indices", ["region", "city"], name: "index_post_indices_on_region_and_city", using: :btree
  add_index "post_indices", ["region"], name: "index_post_indices_on_region", using: :btree

end
