# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Iphdr < ActiveRecord::Base
  include IpUtil

  set_table_name "iphdr"
  set_primary_keys :sid, :cid

# for some reason, belongs_to doesn't work here...
# method event below is a workaround
  belongs_to :event,
             :class_name  => "Event",
             :foreign_key => [:sid, :cid]
  has_one    :data,
             :class_name  => "DataTab",
             :foreign_key => [:sid, :cid]
  has_one    :tcphdr,
             :class_name  => "Tcphdr",
             :foreign_key => [:sid, :cid]
  has_one    :udphdr,
             :class_name  => "Udphdr",
             :foreign_key => [:sid, :cid] 
  has_one    :icmphdr,
             :class_name  => "Icmphdr",
             :foreign_key => [:sid, :cid] 
  has_one    :opt,
             :class_name  => "Opt",
             :foreign_key => [:sid, :cid]
  
  named_scope :with_ip_src, lambda { |ip_str| {:conditions => ["ip_src = ?", Iphdr.ip_string_to_int(ip_str)] } }
  named_scope :with_ip_dst, lambda { |ip_str| {:conditions => ["ip_dst = ?", Iphdr.ip_string_to_int(ip_str)] } }

  def Iphdr.find_by_src_ip_string(ip_string)
    ip_int = ip_string_to_int(ip_string)
    Iphdr.find(:all, :conditions => "ip_src = #{ip_int}")
  end

  def Iphdr.find_by_dst_ip_string(ip_string)
    ip_int = ip_string_to_int(ip_string)
    Iphdr.find(:all, :conditions => "ip_dst = #{ip_int}")
  end 

  def Iphdr.find_by_src_ip_int(ip_int)
    Iphdr.find(:all, :conditions => "ip_src = #{ip_int}")
  end

  def Iphdr.find_by_dst_ip_int(ip_int)
    Iphdr.find(:all, :conditions => "ip_dst = #{ip_int}")
  end 

  def ip_src_string
    Iphdr.ip_int_to_string(self.ip_src)
  end

  def ip_dst_string
    Iphdr.ip_int_to_string(self.ip_dst)
  end

  def ip_src_dns
    reverse_dns(self.ip_src_string)
  end

  def ip_dst_dns
    reverse_dns(self.ip_dst_string)
  end

end
