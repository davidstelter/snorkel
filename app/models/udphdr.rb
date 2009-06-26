class Udphdr < ActiveRecord::Base
  set_table_name "udphdr"
  set_primary_keys :cid, :sid
  belongs_to :iphdr,
             :class_name => "Iphdr",
             :foreign_key => [:cid, :sid]

end
