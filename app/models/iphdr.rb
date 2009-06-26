class Iphdr < ActiveRecord::Base
  set_table_name "iphdr"
  set_primary_keys :cid, :sid
  belongs_to :event,
             :class_name  => "Event",
             :foreign_key => [:cid, :sid]
end
