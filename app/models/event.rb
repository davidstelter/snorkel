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
  has_one    :iphdr, 
             :class_name  => "Iphdr", 
             :foreign_key => [:sid, :cid]

  named_scope :min_count_by_sig, lambda { |cnt| {:select => 'signature', :group => 'signature', :having => ["count(*) >= ?", cnt] } }
  named_scope :max_count_by_sig, lambda { |cnt| {:select => 'signature', :group => 'signature', :having => ["count(*) <= ?", cnt] } }
  named_scope :with_ip_src, lambda { |ip_str| {:joins => :iphdr, :conditions => ["iphdr.ip_src = ?", IpUtil.ip_string_to_int(ip_str)] } }
  named_scope :with_ip_dst, lambda { |ip_str| {:joins => :iphdr, :conditions => ["iphdr.ip_dst = ?", IpUtil.ip_string_to_int(ip_str)] } }
  named_scope :earliest, :limit => 1, :order => 'timestamp'
  named_scope :latest, :limit => 1, :order => 'timestamp DESC'

# tell whether self is older than other, reckoned by their timestamps
  def older?(other)
    self.timestamp < other.timestamp
  end

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
