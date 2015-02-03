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

ActiveRecord::Schema.define(version: 20150203211808) do

  create_table "addresses", force: true do |t|
    t.string   "street_line1"
    t.string   "street_line2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street_line3"
  end

  create_table "ads", force: true do |t|
    t.string   "ad"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ads_applicants", id: false, force: true do |t|
    t.integer  "applicant_id"
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ads_applicants", ["ad_id"], name: "index_ads_applicants_on_ad_id", using: :btree
  add_index "ads_applicants", ["applicant_id"], name: "index_ads_applicants_on_applicant_id", using: :btree

  create_table "applicant_password_reset_requests", force: true do |t|
    t.string   "key",          null: false
    t.integer  "applicant_id"
    t.datetime "used_at"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicant_password_reset_requests", ["key"], name: "index_applicant_password_reset_requests_on_key", using: :btree

  create_table "applicants", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "other_name"
    t.string   "resident_state"
    t.string   "email"
    t.string   "citizen"
    t.string   "selective_service"
    t.boolean  "veteran"
    t.string   "birth_city"
    t.string   "birth_state"
    t.string   "birth_country"
    t.date     "birth_date"
    t.boolean  "decline_dob"
    t.string   "gender"
    t.string   "ethnicity"
    t.string   "disability"
    t.string   "crypted_password"
    t.boolean  "same_as_addr_1"
    t.string   "telephone_1"
    t.string   "telephone_2"
    t.string   "telephone_3"
    t.boolean  "privacy"
    t.string   "salt"
    t.boolean  "sharing"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "no_patents"
    t.boolean  "no_leaderships"
    t.boolean  "no_teamworks"
    t.boolean  "no_researches"
    t.boolean  "no_memberships"
    t.boolean  "no_publications"
    t.boolean  "no_awards"
    t.boolean  "no_professionals"
    t.boolean  "no_volunteers"
    t.boolean  "no_gres"
    t.boolean  "no_certifications"
    t.boolean  "no_explanation"
    t.boolean  "no_leadership"
    t.boolean  "no_teamwork"
    t.boolean  "no_research"
    t.boolean  "no_membership"
    t.boolean  "no_volunteer"
    t.integer  "resource_applicant_id"
    t.boolean  "submitted"
    t.datetime "submitted_at"
    t.boolean  "withdrawn"
    t.datetime "withdrawn_at"
    t.integer  "primary_address_id"
    t.integer  "secondary_address_id"
    t.string   "prefix"
    t.string   "high_school_city"
    t.string   "high_school_state"
    t.string   "high_school_country"
    t.datetime "permanent_resident_date"
    t.string   "disability_description"
    t.string   "native_language"
    t.string   "telephone_1_ext"
    t.string   "telephone_2_ext"
    t.string   "fax_1"
    t.string   "fax_2"
    t.string   "email_2"
    t.boolean  "display_honors_list"
    t.boolean  "display_honors_email"
    t.boolean  "late_submission"
    t.boolean  "deleted"
    t.boolean  "unsubmitted"
    t.string   "withdraw_reason"
    t.boolean  "pm_concerns_flag"
    t.string   "veteran_status"
  end

  add_index "applicants", ["created_at"], name: "index_applicants_on_created_at", using: :btree
  add_index "applicants", ["ethnicity"], name: "index_applicants_on_ethnicity", using: :btree
  add_index "applicants", ["gender"], name: "index_applicants_on_gender", using: :btree
  add_index "applicants", ["submitted"], name: "index_applicants_on_submitted", using: :btree
  add_index "applicants", ["updated_at"], name: "index_applicants_on_updated_at", using: :btree
  add_index "applicants", ["withdrawn"], name: "index_applicants_on_withdrawn", using: :btree

  create_table "applicants_eligibility_flags", id: false, force: true do |t|
    t.integer "applicant_id"
    t.integer "flag_id"
  end

  add_index "applicants_eligibility_flags", ["applicant_id"], name: "index_applicants_flags_on_applicant_id", using: :btree
  add_index "applicants_eligibility_flags", ["flag_id"], name: "index_applicants_flags_on_flag_id", using: :btree

  create_table "applicants_fellowships", force: true do |t|
    t.integer "applicant_id"
    t.string  "fellowship_code"
    t.string  "fellowship_other_code"
  end

  create_table "applicants_races", id: false, force: true do |t|
    t.integer  "applicant_id"
    t.integer  "race_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicants_races", ["applicant_id"], name: "applicant_id", using: :btree
  add_index "applicants_races", ["race_id", "applicant_id"], name: "index_applicants_races_on_race_id_and_applicant_id", using: :btree

  create_table "assets", force: true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.string   "title"
    t.integer  "created_by"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["parent_id"], name: "index_assets_on_parent_id", using: :btree
  add_index "assets", ["thumbnail"], name: "index_assets_on_thumbnail", using: :btree
  add_index "assets", ["type"], name: "index_assets_on_type", using: :btree

  create_table "awards", force: true do |t|
    t.integer  "applicant_id"
    t.string   "name"
    t.date     "received_date"
    t.boolean  "federal"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "awards", ["applicant_id"], name: "index_awards_on_app_id", using: :btree

  create_table "bdrb_job_queues", force: true do |t|
    t.binary   "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "certs", force: true do |t|
    t.integer  "applicant_id"
    t.boolean  "unlawful_action"
    t.boolean  "delinquent"
    t.boolean  "debarred"
    t.boolean  "conviction"
    t.boolean  "criminal_charges"
    t.boolean  "public_transaction"
    t.string   "sig_last_name"
    t.string   "sig_first_name"
    t.string   "sig_middle_name"
    t.string   "sig_ip_addr"
    t.datetime "sig_time_stamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "eligibility_criteria"
    t.boolean  "essays"
  end

  add_index "certs", ["applicant_id"], name: "index_certs_on_applicant_id", using: :btree

  create_table "circumstances", force: true do |t|
    t.string "circumstance"
  end

  create_table "circumstances_references", id: false, force: true do |t|
    t.integer  "circumstance_id"
    t.integer  "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurations", force: true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string  "country"
    t.integer "display_order", default: 9999999
  end

  create_table "disabilities", force: true do |t|
    t.integer "applicant_id"
    t.string  "disability"
    t.string  "description"
  end

  add_index "disabilities", ["applicant_id"], name: "index_disabilities_on_applicant_id", using: :btree

  create_table "disciplines", force: true do |t|
    t.string  "discipline"
    t.integer "order_by"
  end

  create_table "eligibility_answers", force: true do |t|
    t.integer  "eligibility_review_id"
    t.integer  "eligibility_question_id"
    t.boolean  "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "eligibility_answers", ["eligibility_review_id", "eligibility_question_id"], name: "idx_e_answers_on_e_review_id_and_e_question_id", using: :btree

  create_table "eligibility_flags", force: true do |t|
    t.string "name"
    t.text   "reviewer_guidance"
  end

  create_table "eligibility_flags_eligibility_questions", id: false, force: true do |t|
    t.integer  "flag_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eligibility_questions", force: true do |t|
    t.string   "question"
    t.boolean  "confirming"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eligibility_reviews", force: true do |t|
    t.integer  "applicant_id"
    t.text     "determination"
    t.integer  "user_id"
    t.text     "justification"
    t.string   "initial"
    t.string   "final"
    t.text     "final_reason"
    t.boolean  "active",                         default: true
    t.boolean  "rejected"
    t.boolean  "other_mitigating"
    t.string   "reject_reason"
    t.integer  "rejected_by"
    t.datetime "rejected_at"
    t.string   "user_name"
    t.string   "standardized_ineligible_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "manually_created"
  end

  add_index "eligibility_reviews", ["applicant_id"], name: "index_eligibility_reviews_on_applicant_id", using: :btree
  add_index "eligibility_reviews", ["user_id"], name: "index_eligibility_reviews_on_user_id", using: :btree

  create_table "email_notification_trackers", force: true do |t|
    t.integer  "user_id"
    t.boolean  "enabled"
    t.integer  "frequency"
    t.datetime "last_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "essays", force: true do |t|
    t.integer  "applicant_id"
    t.string   "type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_name"
    t.integer  "uploaded_pdf_id"
  end

  add_index "essays", ["applicant_id"], name: "index_essays_on_applicant_id", using: :btree
  add_index "essays", ["uploaded_pdf_id"], name: "index_essays_on_uploaded_pdf_id", using: :btree

  create_table "ets_report_gres", force: true do |t|
    t.integer  "ets_report_id"
    t.integer  "applicants_gre_id"
    t.text     "gre_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ets_report_gres", ["applicants_gre_id"], name: "index_ets_report_gres_on_applicants_gre_id", using: :btree
  add_index "ets_report_gres", ["ets_report_id"], name: "index_ets_report_gres_on_ets_report_id", using: :btree

  create_table "ets_reports", force: true do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["ends_at"], name: "index_events_on_ends_at", using: :btree
  add_index "events", ["starts_at", "ends_at"], name: "index_events_on_starts_at_and_ends_at", using: :btree
  add_index "events", ["starts_at"], name: "index_events_on_starts_at", using: :btree

  create_table "extranet_applicant_considerations", force: true do |t|
    t.integer  "applicant_id"
    t.integer  "applicant_list_id"
    t.integer  "updated_by_id"
    t.string   "status",            default: "available"
    t.boolean  "alternate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extranet_applicant_considerations", ["alternate"], name: "consideration_alternate", using: :btree
  add_index "extranet_applicant_considerations", ["applicant_id"], name: "consideration_applicant", using: :btree
  add_index "extranet_applicant_considerations", ["applicant_list_id"], name: "consideration_applicant_list", using: :btree
  add_index "extranet_applicant_considerations", ["status"], name: "consideration_status", using: :btree
  add_index "extranet_applicant_considerations", ["updated_by_id"], name: "consideration_updated_by", using: :btree

  create_table "extranet_applicant_lists", force: true do |t|
    t.integer  "organization_id"
    t.string   "status"
    t.integer  "reviewer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extranet_applicant_lists", ["organization_id"], name: "index_extranet_applicant_lists_on_organization_id", using: :btree
  add_index "extranet_applicant_lists", ["status"], name: "index_extranet_applicant_lists_on_status", using: :btree

  create_table "extranet_applicant_votes", force: true do |t|
    t.integer  "applicant_consideration_id"
    t.integer  "user_id"
    t.string   "vote"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extranet_applicant_votes", ["applicant_consideration_id"], name: "applicant_vote_consideration", using: :btree
  add_index "extranet_applicant_votes", ["created_at"], name: "applicant_vote_created_at", using: :btree
  add_index "extranet_applicant_votes", ["user_id"], name: "applicant_vote_user", using: :btree

  create_table "extranet_applicants", force: true do |t|
    t.integer  "applicant_id"
    t.string   "status"
    t.text     "notes"
    t.float    "cost",         limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extranet_applicants", ["applicant_id"], name: "index_extranet_applicants_on_applicant_id", using: :btree
  add_index "extranet_applicants", ["status"], name: "index_extranet_applicants_on_status", using: :btree

  create_table "extranet_documents", force: true do |t|
    t.string   "filename"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extranet_organizations", force: true do |t|
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "name"
    t.float    "budget",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deactivated"
  end

  add_index "extranet_organizations", ["lft"], name: "index_extranet_organizations_on_lft", using: :btree
  add_index "extranet_organizations", ["parent_id"], name: "index_extranet_organizations_on_parent_id", using: :btree
  add_index "extranet_organizations", ["rgt"], name: "index_extranet_organizations_on_rgt", using: :btree

  create_table "extranet_password_reset_requests", force: true do |t|
    t.string   "key",        null: false
    t.integer  "user_id"
    t.datetime "used_at"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extranet_password_reset_requests", ["key"], name: "index_extranet_password_reset_requests_on_key", using: :btree
  add_index "extranet_password_reset_requests", ["user_id"], name: "index_extranet_password_reset_requests_on_user_id", using: :btree

  create_table "extranet_user_logins", force: true do |t|
    t.string   "login"
    t.boolean  "success"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "ip_address"
    t.datetime "tried_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extranet_users", force: true do |t|
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "crypted_password", limit: 40
    t.string   "salt",             limit: 40
    t.boolean  "deactivated"
    t.boolean  "privileged"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fastlane_files", force: true do |t|
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key_fields"
    t.datetime "filemtime"
  end

  create_table "fastlane_import_jobs", force: true do |t|
    t.datetime "import_started"
    t.datetime "import_finished"
    t.datetime "processing_started"
    t.datetime "processing_finished"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fastlane_import_records", force: true do |t|
    t.integer  "fastlane_import_job_id"
    t.integer  "fastlane_file_id"
    t.string   "data_hash"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_seen_import_job_id"
    t.string   "fastlane_key"
    t.string   "aasm_state"
  end

  add_index "fastlane_import_records", ["fastlane_file_id", "data_hash"], name: "index_fastlane_import_records_on_fastlane_file_id_and_data_hash", using: :btree
  add_index "fastlane_import_records", ["fastlane_file_id", "fastlane_import_job_id"], name: "index_fastlane_import_records_on_file_id_and_import_job_id", using: :btree
  add_index "fastlane_import_records", ["fastlane_file_id", "fastlane_key"], name: "index_fastlane_import_records_on_ff_id_and_fastlane_key", using: :btree
  add_index "fastlane_import_records", ["fastlane_file_id", "last_seen_import_job_id"], name: "index_fastlane_import_records_on_ff_id_and_lsij_id", using: :btree

  create_table "fastlane_panel_choices", force: true do |t|
    t.string   "name"
    t.string   "major_field_code"
    t.datetime "effective_date"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", force: true do |t|
    t.string  "title"
    t.string  "url"
    t.integer "user_id"
  end

  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "fellowships", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", force: true do |t|
    t.string   "full_name"
    t.string   "field_name"
    t.integer  "gross_field_id"
    t.string   "fastlane_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "expired"
  end

  add_index "fields", ["fastlane_code"], name: "index_fields_on_fastlane_code", using: :btree

  create_table "final_panels", force: true do |t|
    t.string   "panel_name"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grad_study_levels", force: true do |t|
    t.text     "nsf_level_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "internal_number"
    t.string   "internal_description"
    t.boolean  "active",               default: true
  end

  create_table "gross_fields", force: true do |t|
    t.string   "name"
    t.string   "fastlane_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gross_fields", ["fastlane_code"], name: "index_gross_fields_on_fastlane_code", using: :btree

  create_table "helpdesk_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.text     "attached_text"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "helpdesk_comments", ["commentable_id"], name: "index_helpdesk_comments_on_commentable_id", using: :btree
  add_index "helpdesk_comments", ["user_id"], name: "index_helpdesk_comments_on_user_id", using: :btree

  create_table "helpdesk_contacts", force: true do |t|
    t.integer  "contact_id"
    t.string   "contact_type"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "helpdesk_contacts", ["contact_id"], name: "index_helpdesk_contacts_on_contact_id", using: :btree

  create_table "helpdesk_people", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helpdesk_tickets", force: true do |t|
    t.string   "subject"
    t.string   "header_id"
    t.text     "to"
    t.string   "from"
    t.text     "body"
    t.text     "html"
    t.integer  "importance"
    t.boolean  "had_attachments"
    t.datetime "received_at"
    t.integer  "helpdesk_contact_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "target_date"
    t.boolean  "resolved"
    t.datetime "resolved_at"
    t.integer  "priority",            default: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "helpdesk_tickets", ["helpdesk_contact_id"], name: "index_helpdesk_tickets_on_helpdesk_contact_id", using: :btree
  add_index "helpdesk_tickets", ["user_id"], name: "index_helpdesk_tickets_on_user_id", using: :btree

  create_table "interactions", force: true do |t|
    t.string   "interaction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interactions_references", id: false, force: true do |t|
    t.integer  "interaction_id"
    t.integer  "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ip_whitelists", force: true do |t|
    t.string "ip"
    t.string "description"
    t.date   "expiration"
  end

  add_index "ip_whitelists", ["ip"], name: "index_ip_whitelists_on_ip", unique: true, using: :btree

  create_table "jobs", force: true do |t|
    t.integer  "applicant_id"
    t.integer  "order"
    t.string   "position"
    t.string   "employer"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jobs", ["applicant_id"], name: "index_jobs_on_applicant_id", using: :btree

  create_table "legacy_applicant_counts", force: true do |t|
    t.string  "application_year"
    t.integer "number_started"
    t.integer "number_submitted"
    t.integer "year"
    t.integer "month"
  end

  create_table "minorities_constraint_default_calculators", force: true do |t|
    t.string   "name"
    t.text     "alternate_description"
    t.float    "min_percent_of_overall_ratio", limit: 24
    t.float    "max_percent_of_overall_ratio", limit: 24
    t.boolean  "average_min"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default"
  end

  create_table "minority_statuses", force: true do |t|
    t.integer  "applicant_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "minority_statuses", ["applicant_id"], name: "index_minority_statuses_on_applicant_id", using: :btree

  create_table "notification_requests", force: true do |t|
    t.string   "email_address", limit: 500
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_redirects", force: true do |t|
    t.string   "url"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_versions", force: true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.string   "title"
    t.string   "url"
    t.text     "body",          limit: 16777215
    t.integer  "parent_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "status_id"
    t.datetime "published_at"
    t.boolean  "published"
    t.date     "starts_at"
    t.date     "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_cache"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.integer  "position"
    t.text     "right_sidebar"
  end

  add_index "page_versions", ["page_id"], name: "index_page_versions_on_page_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "body",          limit: 16777215
    t.integer  "parent_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "status_id"
    t.datetime "published_at"
    t.boolean  "published"
    t.date     "starts_at"
    t.date     "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version"
    t.string   "url_cache"
    t.boolean  "deleted"
    t.datetime "deleted_at"
    t.integer  "position"
    t.text     "right_sidebar"
  end

  add_index "pages", ["created_at"], name: "index_pages_on_created_at", using: :btree
  add_index "pages", ["parent_id"], name: "index_pages_on_parent_id", using: :btree
  add_index "pages", ["status_id"], name: "index_pages_on_status_id", using: :btree
  add_index "pages", ["url"], name: "index_pages_on_url", using: :btree
  add_index "pages", ["url_cache"], name: "index_pages_on_url_cache", using: :btree

  create_table "panel_selection_remaps", force: true do |t|
    t.integer  "applicant_id"
    t.integer  "previous_resource_panel_id"
    t.integer  "new_resource_panel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "panel_selections", force: true do |t|
    t.integer "applicant_id"
    t.integer "panel_code"
    t.string  "panel_name"
    t.integer "resource_panel_id"
    t.date    "panel_start_date"
  end

  add_index "panel_selections", ["applicant_id"], name: "index_panel_selections_on_applicant_id", using: :btree
  add_index "panel_selections", ["panel_start_date"], name: "index_panel_selections_on_panel_start_date", using: :btree

  create_table "patents", force: true do |t|
    t.integer  "applicant_id"
    t.string   "patent_type"
    t.string   "title"
    t.string   "patent_number"
    t.text     "description"
    t.string   "inventors"
    t.date     "submission_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patents", ["applicant_id"], name: "index_patents_on_app_id", using: :btree

  create_table "permissive_permissions", force: true do |t|
    t.integer "permitted_object_id"
    t.string  "permitted_object_type", limit: 32
    t.integer "scoped_object_id"
    t.string  "scoped_object_type",    limit: 32
    t.integer "mask",                             default: 0
    t.integer "grant_mask",                       default: 0
  end

  add_index "permissive_permissions", ["grant_mask"], name: "permissive_grant_masks", using: :btree
  add_index "permissive_permissions", ["mask"], name: "permissive_masks", using: :btree
  add_index "permissive_permissions", ["permitted_object_id", "permitted_object_type"], name: "permissive_permitted", using: :btree
  add_index "permissive_permissions", ["scoped_object_id", "scoped_object_type"], name: "permissive_scoped", using: :btree

  create_table "permissive_templates", force: true do |t|
    t.integer "parent_id"
    t.string  "name"
    t.integer "mask",      default: 0
  end

  add_index "permissive_templates", ["parent_id"], name: "index_permissive_templates_on_parent_id", using: :btree

  create_table "positions", force: true do |t|
    t.string "position"
  end

  create_table "professionals", force: true do |t|
    t.integer  "applicant_id"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "agency"
    t.string   "other_agency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resume"
  end

  add_index "professionals", ["applicant_id"], name: "index_professionals_on_app_id", using: :btree

  create_table "publications", force: true do |t|
    t.integer  "applicant_id"
    t.string   "authors"
    t.string   "title"
    t.string   "present_at"
    t.date     "present_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publications", ["applicant_id"], name: "index_publications_on_app_id", using: :btree

  create_table "races", force: true do |t|
    t.string   "race"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranks", force: true do |t|
    t.string "rank"
  end

  create_table "rating_sheets", force: true do |t|
    t.integer  "applicant_id"
    t.text     "broader_impact_explanation"
    t.integer  "broader_impact_score"
    t.text     "intellectual_merit_explanation"
    t.integer  "intellectual_merit_score"
    t.string   "filename"
    t.integer  "result_id"
    t.string   "panel"
    t.integer  "score"
    t.string   "panelist_first_name"
    t.string   "panelist_last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "z_score",                        precision: 10, scale: 8
    t.text     "summary_statement"
    t.integer  "panelist_id"
  end

  add_index "rating_sheets", ["applicant_id"], name: "index_rating_sheets_on_applicant_id", using: :btree
  add_index "rating_sheets", ["panelist_id"], name: "index_rating_sheets_on_panelist_id", using: :btree
  add_index "rating_sheets", ["result_id"], name: "index_rating_sheets_on_result_id", using: :btree

  create_table "ratingsheet_logins", force: true do |t|
    t.datetime "login_at"
    t.integer  "ratingsheet_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratingsheet_logins", ["ratingsheet_user_id"], name: "index_ratingsheet_logins_on_ratingsheet_user_id", using: :btree

  create_table "ratingsheet_password_reset_requests", force: true do |t|
    t.string   "key",                 null: false
    t.integer  "ratingsheet_user_id"
    t.datetime "used_at"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratingsheet_password_reset_requests", ["key"], name: "index_ratingsheet_password_reset_requests_on_key", using: :btree

  create_table "ratingsheet_users", force: true do |t|
    t.integer  "applicant_id"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratingsheet_users", ["applicant_id"], name: "index_ratingsheet_users_on_applicant_id", using: :btree
  add_index "ratingsheet_users", ["email"], name: "index_ratingsheet_users_on_email", using: :btree

  create_table "references", force: true do |t|
    t.integer  "applicant_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "institution"
    t.string   "department"
    t.string   "email"
    t.boolean  "active"
    t.string   "password"
    t.boolean  "notified"
    t.datetime "submitted_at"
    t.string   "time_known"
    t.boolean  "confidential"
    t.string   "environment_other"
    t.string   "interaction_other"
    t.string   "peer_education"
    t.string   "peer_major"
    t.string   "peer_institution"
    t.integer  "creativity_id"
    t.integer  "scholarly_promise_id"
    t.integer  "research_ability_id"
    t.integer  "initiative_id"
    t.integer  "leadership_potential_id"
    t.integer  "overall_scientific_ability_id"
    t.string   "letter"
    t.boolean  "complete"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uploaded_pdf_id"
    t.integer  "rank"
    t.boolean  "scrubbed"
  end

  add_index "references", ["applicant_id"], name: "index_refs_on_app_id", using: :btree
  add_index "references", ["uploaded_pdf_id"], name: "index_references_on_uploaded_pdf_id", using: :btree

  create_table "reports", force: true do |t|
    t.string   "name"
    t.text     "report_sql"
    t.text     "description"
    t.string   "reportable_class"
    t.integer  "update_interval",  default: 10
    t.datetime "last_updated"
    t.text     "indices"
    t.boolean  "visible",          default: true
    t.string   "url_token"
    t.boolean  "edit_locked"
    t.string   "link_label"
    t.string   "link_string"
    t.integer  "reportable_id"
    t.string   "reportable_type"
  end

  add_index "reports", ["name"], name: "index_reports_on_name", using: :btree
  add_index "reports", ["reportable_class"], name: "index_reports_on_reportable_class", using: :btree
  add_index "reports", ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id", using: :btree
  add_index "reports", ["reportable_type"], name: "index_reports_on_reportable_type", using: :btree

  create_table "results", force: true do |t|
    t.integer  "applicant_id"
    t.string   "final_panel"
    t.integer  "quality_group"
    t.integer  "final_rank"
    t.integer  "quality_group_rank"
    t.boolean  "award"
    t.boolean  "honorable_mention"
    t.boolean  "weng"
    t.boolean  "wics"
    t.string   "year",                   limit: 4
    t.boolean  "retired"
    t.boolean  "ineligible"
    t.string   "discipline_award"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "final_panel_id"
    t.boolean  "withdrawn_after_panels"
    t.boolean  "prev_honorable_mention"
    t.float    "average_score",          limit: 24
    t.string   "source",                            default: "unknown"
    t.boolean  "post_panel"
    t.integer  "qg2_flaggings",                     default: 0
    t.string   "reviewers"
    t.string   "scores"
    t.string   "z_scores"
    t.integer  "original_rank"
  end

  add_index "results", ["applicant_id", "year"], name: "index_results_on_applicant_id_and_year", using: :btree
  add_index "results", ["applicant_id"], name: "index_results_on_applicant_id", using: :btree
  add_index "results", ["final_panel", "year", "quality_group"], name: "index_results_on_final_panel_and_year_and_quality_group", using: :btree
  add_index "results", ["final_panel", "year"], name: "index_results_on_final_panel_and_year", using: :btree

  create_table "se_report_records", force: true do |t|
    t.integer  "applicant_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "panel"
    t.string   "gross_field"
    t.string   "field_of_study"
    t.string   "academic_level"
    t.boolean  "interdisciplinary"
    t.string   "gender"
    t.string   "race"
    t.string   "ethnicity"
    t.string   "disability"
    t.string   "underrepresented_minority"
    t.string   "high_school_state"
    t.string   "baccalaureate_institution"
    t.string   "current_institution"
    t.string   "proposed_institution"
    t.boolean  "eligible"
    t.boolean  "reviewed"
    t.integer  "quality_group"
    t.boolean  "awardee"
    t.boolean  "honorable_mention"
    t.boolean  "non_awardee"
    t.boolean  "wics"
    t.boolean  "weng"
    t.string   "carnegie_for_bacc_institution"
    t.string   "carnegie_for_current_institution"
    t.float    "baccalaureate_gpa",                limit: 24
    t.integer  "gre_v_score"
    t.integer  "gre_v_percent"
    t.integer  "gre_q_score"
    t.integer  "gre_q_percent"
    t.integer  "gre_a_score"
    t.integer  "gre_a_percent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "carnegie_for_proposed_school"
    t.boolean  "bacc_institution_hbcu"
    t.boolean  "bacc_institution_hsi"
    t.boolean  "current_institution_hbcu"
    t.boolean  "current_institution_hsi"
    t.boolean  "proposed_institution_hbcu"
    t.boolean  "proposed_institution_hsi"
    t.string   "initial_panel"
    t.boolean  "manual_selection",                            default: false
    t.boolean  "selected_by_equation",                        default: false
  end

  add_index "se_report_records", ["applicant_id"], name: "index_se_report_records_on_applicant_id", unique: true, using: :btree
  add_index "se_report_records", ["panel"], name: "index_se_report_records_on_panel", using: :btree

  create_table "selection_constraints", force: true do |t|
    t.string   "type"
    t.integer  "target"
    t.string   "cupola",                default: ">=", null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "selection_equation_id"
    t.string   "panel_name"
    t.string   "applicant_id_list"
    t.integer  "level"
  end

  add_index "selection_constraints", ["name"], name: "index_selection_constraints_on_name", using: :btree

  create_table "selection_equation_results", force: true do |t|
    t.integer  "selection_equation_id"
    t.integer  "applicant_id"
    t.string   "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "selection_equation_results", ["applicant_id"], name: "index_selection_equation_results_on_applicant_id", using: :btree
  add_index "selection_equation_results", ["selection_equation_id"], name: "index_selection_equation_results_on_selection_equation_id", using: :btree

  create_table "selection_equations", force: true do |t|
    t.text     "yaml_definition",                             limit: 16777215
    t.float    "objective",                                   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "status"
    t.datetime "last_run_at"
    t.boolean  "use_cutoffs_for_panel_women"
    t.integer  "minorities_constraint_default_calculator_id"
    t.boolean  "current_marked_awardees"
    t.boolean  "needs_solving"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sources", force: true do |t|
    t.integer  "applicant_id"
    t.boolean  "poster"
    t.boolean  "faculty_member"
    t.boolean  "friend_or_student"
    t.boolean  "university_office"
    t.boolean  "website"
    t.boolean  "conference"
    t.string   "conference_name"
    t.boolean  "other"
    t.string   "other_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "social_media"
  end

  add_index "sources", ["applicant_id"], name: "index_sources_on_applicant_id", using: :btree

  create_table "states", force: true do |t|
    t.string "state"
    t.string "full_name"
  end

  create_table "studies", force: true do |t|
    t.integer  "applicant_id"
    t.integer  "discipline_id"
    t.string   "specialization"
    t.boolean  "comp_sci"
    t.string   "proposed_school_name"
    t.string   "proposed_school_city"
    t.string   "proposed_school_state"
    t.string   "proposed_school_country"
    t.string   "academic_status"
    t.string   "academic_advisor"
    t.boolean  "five_year_masters"
    t.boolean  "four_year_masters"
    t.boolean  "undecided"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "proposed_start_date"
    t.date     "proposed_grad_date"
    t.string   "proposed_degree"
    t.boolean  "degree_enrolled"
    t.boolean  "inst_enrolled"
    t.string   "other_discipline"
    t.boolean  "report_gre_general"
    t.boolean  "report_gre_subject"
    t.text     "academic_honors"
    t.string   "proposed_school_dept"
    t.string   "highest_degree"
    t.integer  "field_one_id"
    t.integer  "field_one_percent"
    t.string   "field_one_other_name"
    t.integer  "field_two_id"
    t.integer  "field_two_percent"
    t.integer  "field_three_id"
    t.integer  "field_three_percent"
    t.integer  "field_four_id"
    t.integer  "field_four_percent"
    t.string   "field_detail"
    t.string   "other_degree"
    t.integer  "highest_degree_field_id"
    t.integer  "grad_study_level_id"
    t.boolean  "interdisciplinary"
    t.string   "proposed_research_title"
    t.string   "proposed_research_short_title"
    t.integer  "fastlane_panel_choice_id"
    t.boolean  "proposed_research_international_component"
    t.string   "proposed_research_country_code"
    t.string   "proposed_program"
    t.integer  "university_id"
    t.integer  "proposed_school_university_id"
  end

  add_index "studies", ["applicant_id"], name: "index_studies_on_app_id", using: :btree
  add_index "studies", ["discipline_id"], name: "index_studies_on_discipline_id", using: :btree
  add_index "studies", ["university_id"], name: "index_studies_on_university_id", using: :btree

  create_table "uploaded_pdfs", force: true do |t|
    t.string   "file_name"
    t.datetime "file_modified_at"
    t.integer  "file_size_bytes"
    t.integer  "pdf_pages"
    t.boolean  "corrupt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dir_name"
    t.integer  "wordcount"
  end

  add_index "uploaded_pdfs", ["file_name"], name: "index_uploaded_pdfs_on_file_name", using: :btree

end
