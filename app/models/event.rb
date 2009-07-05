# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Event < ActiveRecord::Base
  set_table_name "event"
  set_primary_keys :sid, :cid

  belongs_to :signature,
             :class_name  => "Signature",
             :foreign_key => "signature"
  belongs_to :sensor,
             :class_name  => "Sensor",
             :foreign_key => "sid"
#TODO: make sure this is really has_one!
  has_one    :iphdr, 
             :class_name  => "Iphdr", 
             :foreign_key => [:sid, :cid]

  def sig_id
    self.signature.sig_id
  end

  def sig_name
    self.signature.sig_name
  end

  def ip_src_dns
    self.iphdr.ip_src_string
  end

  def ip_dst_dns
    self.iphdr.ip_dst_string
  end
  
  def ip_src_string
    self.iphdr.ip_src_string
  end

  def ip_dst_string
    self.iphdr.ip_dst_string
  end
end
