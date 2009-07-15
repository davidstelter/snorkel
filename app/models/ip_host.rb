# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class IpHost
  attr_reader :ip_string

  def initialize(ip_str)
    @ip_string = ip_str
   # @alerts_as_src_count = Alert.with_ip_src(ip_str).count
   # @alerts_as_dst_count = Alert.with_ip_dst(ip_str).count
  end

  def hostname
    if @hostname == nil
      @hostname = IpHost.reverse_dns(@ip_string)
    end
    @hostname
  end

  def alerts_as_src
    unless @alerts_as_src
      @alerts_as_src = Alert.with_ip_src(@ip_string)
    end
    @alerts_as_src
  end

  def alerts_as_dst
    unless @alerts_as_dst
      @alerts_as_dst = Alert.with_ip_dst(@ip_string)
    end
    @alerts_as_dst
  end

  def signatures_as_src
    unless @signatures_as_src
      @signatures_as_src = Signature.with_ip_src(@ip_string)
    end
    @signatures_as_src
  end
  
  def signatures_as_dst
    unless @signatures_as_dst
      @signatures_as_dst = Signature.with_ip_dst(@ip_string)
    end
    @signatures_as_dst
  end

  def IpHost.reverse_dns(ip_string)
    s = Socket.getaddrinfo(ip_string, nil)
    s[0][2]
  end
end
