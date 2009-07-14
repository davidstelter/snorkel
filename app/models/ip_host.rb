# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class IpHost
  attr_reader :alerts_as_src, :alerts_as_dst, :ip_string

  def initialize(ip_str)
    @ip_string = ip_str
    @alerts_as_src = Alert.find_by_src_ip_string(ip_str)
    @alerts_as_dst = Alert.find_by_dst_ip_string(ip_str)
  end

  def hostname
    if @hostname == nil
      @hostname = IpHost.reverse_dns(@ip_string)
    end
    @hostname
  end

  def IpHost.reverse_dns(ip_string)
    s = Socket.getaddrinfo(ip_string, nil)
    s[0][2]
  end
end
