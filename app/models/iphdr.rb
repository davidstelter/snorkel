class Iphdr < ActiveRecord::Base
  set_table_name "iphdr"
  set_primary_keys :cid, :sid
  belongs_to :event,
             :class_name  => "Event",
             :foreign_key => [:cid, :sid]

  def ipsrc
    self.ip_src
  end

  def ip_src_string
    ip_int_to_string(self.ip_src)
  end

  def ip_dst_string
    ip_int_to_string(self.ip_dst)
  end

  def ip_int_to_string(ip_int)
    ip_string = ""
    ip_string <<        "#{( ip_int >> 24)}"
    ip_string << "." << "#{((ip_int >> 16) & 0xff)}"
    ip_string << "." << "#{((ip_int >>  8) & 0xff)}"
    ip_string << "." << "#{( ip_int        & 0xff)}"
  end

end
