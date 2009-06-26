class Opt < ActiveRecord::Base
  set_table_name "opt"
  set_primary_keys :cid, :sid, :optid
  belongs_to :iphdr,
             :class_name => "Iphdr",
             :foreign_key => [:cid, :sid]

end
