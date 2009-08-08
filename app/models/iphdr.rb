# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Iphdr < ActiveRecord::Base
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

#workaround method for broken belongs_to
  #def event 
  #  @event = Event.find(:first, :conditions => "sid = #{sid} and cid = #{cid}") unless @event
  #  @event
  #end

  def Iphdr.find_by_src_ip_string(ip_string)
    ip_int = Iphdr.ip_string_to_int(ip_string)
    Iphdr.find(:all, :conditions => "ip_src = #{ip_int}")
  end

  def Iphdr.find_by_dst_ip_string(ip_string)
    ip_int = Iphdr.ip_string_to_int(ip_string)
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
    IpHost.reverse_dns(self.ip_src_string)
  end

  def ip_dst_dns
    IpHost.reverse_dns(self.ip_dst_string)
  end


#returns numeric IP address given a dotted-octet IP string
  def Iphdr.ip_string_to_int(ip_string)
    ip_int = 0
    ip_string =~ /(\d+)\.(\d+)\.(\d+)\.(\d+)/
    ip_int += $4.to_i
    ip_int += $3.to_i <<  8
    ip_int += $2.to_i << 16
    ip_int += $1.to_i << 24
  end


#returns a human-readable IP address in dotted-octet notation
  def Iphdr.ip_int_to_string(ip_int)
    ip_string = ""
    ip_string <<        "#{( ip_int >> 24)}"
    ip_string << "." << "#{((ip_int >> 16) & 0xff)}"
    ip_string << "." << "#{((ip_int >>  8) & 0xff)}"
    ip_string << "." << "#{( ip_int        & 0xff)}"
  end

end
