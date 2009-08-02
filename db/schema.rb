# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090730054021) do

  create_table "cache_update", :id => false, :force => true do |t|
    t.datetime "last_updated", :null => false
  end

  create_table "data", :id => false, :force => true do |t|
    t.integer "sid",                       :null => false
    t.integer "cid",          :limit => 8, :null => false
    t.text    "data_payload"
  end

  create_table "detail", :id => false, :force => true do |t|
    t.integer "detail_type", :limit => 2, :null => false
    t.text    "detail_text",              :null => false
  end

  create_table "encoding", :id => false, :force => true do |t|
    t.integer "encoding_type", :limit => 2, :null => false
    t.text    "encoding_text",              :null => false
  end

  create_table "event", :id => false, :force => true do |t|
    t.integer  "sid",                    :null => false
    t.integer  "cid",       :limit => 8, :null => false
    t.integer  "signature",              :null => false
    t.datetime "timestamp",              :null => false
  end

  add_index "event", ["signature"], :name => "signature_idx"
  add_index "event", ["timestamp"], :name => "timestamp_idx"

  create_table "icmphdr", :id => false, :force => true do |t|
    t.integer "sid",                    :null => false
    t.integer "cid",       :limit => 8, :null => false
    t.integer "icmp_type", :limit => 2, :null => false
    t.integer "icmp_code", :limit => 2, :null => false
    t.integer "icmp_csum"
    t.integer "icmp_id"
    t.integer "icmp_seq"
  end

  add_index "icmphdr", ["icmp_type"], :name => "icmp_type_idx"

  create_table "ip_host_cache", :id => false, :force => true do |t|
    t.integer "ip_addr",     :limit => 8,                :null => false
    t.integer "src_ev_cnt",               :default => 0, :null => false
    t.integer "dst_ev_cnt",               :default => 0, :null => false
    t.integer "src_sig_cnt",              :default => 0, :null => false
    t.integer "dst_sig_cnt",              :default => 0, :null => false
    t.integer "act_idx",                  :default => 0, :null => false
  end

  create_table "iphdr", :id => false, :force => true do |t|
    t.integer "sid",                   :null => false
    t.integer "cid",      :limit => 8, :null => false
    t.integer "ip_src",   :limit => 8, :null => false
    t.integer "ip_dst",   :limit => 8, :null => false
    t.integer "ip_ver",   :limit => 2
    t.integer "ip_hlen",  :limit => 2
    t.integer "ip_tos",   :limit => 2
    t.integer "ip_len"
    t.integer "ip_id"
    t.integer "ip_flags", :limit => 2
    t.integer "ip_off"
    t.integer "ip_ttl",   :limit => 2
    t.integer "ip_proto", :limit => 2, :null => false
    t.integer "ip_csum"
  end

  add_index "iphdr", ["ip_dst"], :name => "ip_dst_idx"
  add_index "iphdr", ["ip_src"], :name => "ip_src_idx"

  create_table "opt", :id => false, :force => true do |t|
    t.integer "sid",                    :null => false
    t.integer "cid",       :limit => 8, :null => false
    t.integer "optid",     :limit => 2, :null => false
    t.integer "opt_proto", :limit => 2, :null => false
    t.integer "opt_code",  :limit => 2, :null => false
    t.integer "opt_len"
    t.text    "opt_data"
  end

  create_table "reference", :primary_key => "ref_id", :force => true do |t|
    t.integer "ref_system_id", :null => false
    t.text    "ref_tag",       :null => false
  end

  create_table "reference_system", :primary_key => "ref_system_id", :force => true do |t|
    t.text "ref_system_name"
  end

  create_table "schema", :id => false, :force => true do |t|
    t.integer  "vseq",  :null => false
    t.datetime "ctime", :null => false
  end

  create_table "sensor", :primary_key => "sid", :force => true do |t|
    t.text    "hostname"
    t.text    "interface"
    t.text    "filter"
    t.integer "detail",    :limit => 2
    t.integer "encoding",  :limit => 2
    t.integer "last_cid",  :limit => 8, :null => false
  end

  create_table "sig_class", :primary_key => "sig_class_id", :force => true do |t|
    t.text "sig_class_name", :null => false
  end

  add_index "sig_class", ["sig_class_name"], :name => "sig_class_name_idx"

  create_table "sig_reference", :id => false, :force => true do |t|
    t.integer "sig_id",  :null => false
    t.integer "ref_seq", :null => false
    t.integer "ref_id",  :null => false
  end

  create_table "signature", :primary_key => "sig_id", :force => true do |t|
    t.text    "sig_name",                  :null => false
    t.integer "sig_class_id", :limit => 8
    t.integer "sig_priority", :limit => 8
    t.integer "sig_rev",      :limit => 8
    t.integer "sig_sid",      :limit => 8
    t.integer "sig_gid",      :limit => 8
  end

  add_index "signature", ["sig_class_id"], :name => "sig_class_idx"
  add_index "signature", ["sig_name"], :name => "sig_name_idx"

  create_table "tcphdr", :id => false, :force => true do |t|
    t.integer "sid",                    :null => false
    t.integer "cid",       :limit => 8, :null => false
    t.integer "tcp_sport",              :null => false
    t.integer "tcp_dport",              :null => false
    t.integer "tcp_seq",   :limit => 8
    t.integer "tcp_ack",   :limit => 8
    t.integer "tcp_off",   :limit => 2
    t.integer "tcp_res",   :limit => 2
    t.integer "tcp_flags", :limit => 2, :null => false
    t.integer "tcp_win"
    t.integer "tcp_csum"
    t.integer "tcp_urp"
  end

  add_index "tcphdr", ["tcp_dport"], :name => "tcp_dport_idx"
  add_index "tcphdr", ["tcp_flags"], :name => "tcp_flags_idx"
  add_index "tcphdr", ["tcp_sport"], :name => "tcp_sport_idx"

  create_table "udphdr", :id => false, :force => true do |t|
    t.integer "sid",                    :null => false
    t.integer "cid",       :limit => 8, :null => false
    t.integer "udp_sport",              :null => false
    t.integer "udp_dport",              :null => false
    t.integer "udp_len"
    t.integer "udp_csum"
  end

  add_index "udphdr", ["udp_dport"], :name => "udp_dport_idx"
  add_index "udphdr", ["udp_sport"], :name => "udp_sport_idx"

end
