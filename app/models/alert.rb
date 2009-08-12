# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details 

class Alert < ActiveRecord::Base
  include IpUtil

  set_table_name "alert"
  set_primary_keys :sid, :cid

  belongs_to :signature,
             :class_name  => "Signature",
             :foreign_key => "sig_id"
  belongs_to :sensor,
             :class_name  => "Sensor",
             :foreign_key => "sid"
  has_one    :event,
             :class_name  => "Event",
             :foreign_key => [:sid, :cid]
  has_one    :iphdr,
             :class_name  => "Iphdr",
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
  has_one    :data,
             :class_name  => "DataTab",
             :foreign_key => [:sid, :cid]
  has_many   :opt,
             :class_name  => "Opt",
             :foreign_key => [:sid, :cid]

  named_scope :with_ip_src,  lambda { |ip_string| { :conditions => ["ip_src = ?", IpUtil.ip_string_to_int(ip_string) ] } } 
  named_scope :with_ip_dst,  lambda { |ip_string| { :conditions => ["ip_dst = ?", IpUtil.ip_string_to_int(ip_string) ] } } 

  def l4src
    sport   = tcp_sport
    sport ||= udp_sport
  end

  def l4dst
    dport   = tcp_dport
    dport ||= udp_dport
  end

  def Alert.find_by_src_ip_string(ip_string)
    ip_int = IpUtil.ip_string_to_int(ip_string)
    Alert.find(:all, :conditions => "ip_src = #{ip_int}")
  end

  def Alert.find_by_dst_ip_string(ip_string)
    ip_int = IpUtil.ip_string_to_int(ip_string)
    Alert.find(:all, :conditions => "ip_dst = #{ip_int}")
  end 

  def ip_src_dns
    IpUtil.reverse_dns(self.ip_src_string)
  end

  def ip_dst_dns
    IpUtil.reverse_dns(self.ip_dst_string)
  end

  def ip_src_string
    IpUtil.ip_int_to_string(self.ip_src)
  end

  def ip_dst_string
    IpUtil.ip_int_to_string(self.ip_dst)
  end
end
