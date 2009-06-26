class Event < ActiveRecord::Base
  set_table_name "event"
  set_primary_keys :sid, :cid

  belongs_to :signature,
             :class_name  => "Signature",
             :foreign_key => "signature"
  belongs_to :sensor,
             :class_name  => "Sensor",
             :foreign_key => "sid"
  has_many   :iphdrs, 
             :class_name  => "Iphdr", 
             :foreign_key => [:sid, :cid]
end
