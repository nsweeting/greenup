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

ActiveRecord::Schema.define(version: 20170430210552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "owner_email"
    t.string   "owner_name"
    t.string   "website"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_accounts_on_name", unique: true, using: :btree
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "company"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "postal_code"
    t.integer  "category",         default: 0, null: false
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.integer  "province_id",                  null: false
    t.integer  "country_id",                   null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree
    t.index ["country_id"], name: "index_addresses_on_country_id", using: :btree
    t.index ["province_id"], name: "index_addresses_on_province_id", using: :btree
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbr", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.integer  "orders_count",         default: 0,     null: false
    t.integer  "total_spent_cents",    default: 0,     null: false
    t.string   "total_spent_currency", default: "CAD", null: false
    t.integer  "last_order_id"
    t.string   "phone"
    t.boolean  "tax_exempt",           default: false, null: false
    t.integer  "account_id",                           null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["account_id", "email"], name: "index_customers_on_account_id_and_email", unique: true, using: :btree
    t.index ["account_id"], name: "index_customers_on_account_id", using: :btree
    t.index ["email"], name: "index_customers_on_email", using: :btree
  end

  create_table "line_items", force: :cascade do |t|
    t.string   "title"
    t.string   "variant_title"
    t.string   "vendor"
    t.integer  "total_grams",          default: 0,     null: false
    t.integer  "grams",                default: 0,     null: false
    t.integer  "quantity",             default: 1,     null: false
    t.integer  "total_price_cents",    default: 0,     null: false
    t.integer  "price_cents",          default: 0,     null: false
    t.integer  "total_discount_cents", default: 0,     null: false
    t.string   "currency",             default: "CAD", null: false
    t.boolean  "taxable",                              null: false
    t.boolean  "requires_shipping",                    null: false
    t.integer  "order_id"
    t.integer  "variant_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["order_id"], name: "index_line_items_on_order_id", using: :btree
    t.index ["variant_id"], name: "index_line_items_on_variant_id", using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.boolean  "confirmed",          default: false
    t.string   "confirmation_email"
    t.integer  "role",               default: 0,     null: false
    t.text     "scopes",             default: [],                 array: true
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["account_id"], name: "index_members_on_account_id", using: :btree
    t.index ["user_id", "account_id"], name: "index_members_on_user_id_and_account_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "email"
    t.datetime "closed_at"
    t.integer  "number"
    t.text     "note"
    t.integer  "gateway",                      default: 0,     null: false
    t.boolean  "test",                         default: false, null: false
    t.integer  "total_price_cents",            default: 0,     null: false
    t.integer  "subtotal_price_cents",         default: 0,     null: false
    t.integer  "total_tax_cents",              default: 0,     null: false
    t.integer  "total_discounts_cents",        default: 0,     null: false
    t.integer  "total_line_items_price_cents", default: 0,     null: false
    t.boolean  "taxes_included",               default: false, null: false
    t.integer  "financial_status",             default: 0,     null: false
    t.string   "currency",                     default: "CAD", null: false
    t.string   "name",                                         null: false
    t.datetime "cancelled_at"
    t.datetime "processed_at"
    t.text     "cancel_reason"
    t.integer  "account_id",                                   null: false
    t.integer  "customer_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["account_id", "number"], name: "index_orders_on_account_id_and_number", unique: true, using: :btree
    t.index ["account_id"], name: "index_orders_on_account_id", using: :btree
    t.index ["customer_id"], name: "index_orders_on_customer_id", using: :btree
    t.index ["number"], name: "index_orders_on_number", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.text     "body_html"
    t.string   "product_type"
    t.string   "slug"
    t.string   "vendor"
    t.boolean  "published",       default: false, null: false
    t.integer  "published_scope", default: 0,     null: false
    t.datetime "published_at"
    t.integer  "account_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["account_id"], name: "index_products_on_account_id", using: :btree
  end

  create_table "provinces", force: :cascade do |t|
    t.string  "name",       null: false
    t.string  "abbr",       null: false
    t.integer "country_id"
    t.index ["country_id"], name: "index_provinces_on_country_id", using: :btree
  end

  create_table "shipping_accounts", force: :cascade do |t|
    t.json     "credentials"
    t.integer  "shipping_carrier_id", null: false
    t.integer  "account_id",          null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["account_id"], name: "index_shipping_accounts_on_account_id", using: :btree
    t.index ["shipping_carrier_id"], name: "index_shipping_accounts_on_shipping_carrier_id", using: :btree
  end

  create_table "shipping_carriers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_methods", force: :cascade do |t|
    t.string   "name"
    t.integer  "shipping_service_id", null: false
    t.integer  "zone_id",             null: false
    t.integer  "account_id",          null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["account_id"], name: "index_shipping_methods_on_account_id", using: :btree
    t.index ["shipping_service_id"], name: "index_shipping_methods_on_shipping_service_id", using: :btree
    t.index ["zone_id"], name: "index_shipping_methods_on_zone_id", using: :btree
  end

  create_table "shipping_services", force: :cascade do |t|
    t.string   "name"
    t.string   "company"
    t.string   "description"
    t.integer  "shipping_carrier_id", null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["shipping_carrier_id"], name: "index_shipping_services_on_shipping_carrier_id", using: :btree
  end

  create_table "tax_lines", force: :cascade do |t|
    t.string   "name"
    t.integer  "price_cents",                          default: 0,     null: false
    t.decimal  "amount",       precision: 8, scale: 5, default: "0.0"
    t.string   "currency",                             default: "CAD", null: false
    t.string   "taxable_type"
    t.integer  "taxable_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.index ["taxable_type", "taxable_id"], name: "index_tax_lines_on_taxable_type_and_taxable_id", using: :btree
  end

  create_table "tax_rates", force: :cascade do |t|
    t.string   "name"
    t.decimal  "amount",     precision: 8, scale: 5, default: "0.0"
    t.integer  "zone_id",                                            null: false
    t.integer  "account_id",                                         null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.index ["account_id"], name: "index_tax_rates_on_account_id", using: :btree
    t.index ["zone_id"], name: "index_tax_rates_on_zone_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  create_table "variants", force: :cascade do |t|
    t.string   "title"
    t.integer  "price_cents",       default: 0,     null: false
    t.string   "currency",          default: "CAD", null: false
    t.string   "sku"
    t.integer  "position"
    t.integer  "grams"
    t.string   "option1"
    t.string   "option2"
    t.string   "option3"
    t.boolean  "taxable",           default: true,  null: false
    t.boolean  "requires_shipping", default: true,  null: false
    t.integer  "inventory"
    t.integer  "old_inventory"
    t.decimal  "weight"
    t.string   "weight_unit"
    t.integer  "product_id",                        null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["product_id"], name: "index_variants_on_product_id", using: :btree
  end

  create_table "zone_members", force: :cascade do |t|
    t.string   "zoneable_type"
    t.integer  "zoneable_id"
    t.integer  "zone_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["zone_id"], name: "index_zone_members_on_zone_id", using: :btree
    t.index ["zoneable_type", "zoneable_id"], name: "index_zone_members_on_zoneable_type_and_zoneable_id", using: :btree
  end

  create_table "zones", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.integer  "account_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["account_id"], name: "index_zones_on_account_id", using: :btree
  end

end
