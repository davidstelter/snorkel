module IpUtil

  # returns the highest IP address in a given network.
  # netaddr and netmask must be integers, netmask is CIDR
  def IpUtil.high_ip(netaddr, netmask)
    netmask = netmask.to_i
    netaddr + (2 ** netmask) -1
  end

  #returns numeric IP address given a dotted-octet IP string
  def IpUtil.ip_string_to_int(ip_string)
    ip_int = 0
    ip_string =~ /(\d+)\.(\d+)\.(\d+)\.(\d+)/
    ip_int += $4.to_i
    ip_int += $3.to_i <<  8
    ip_int += $2.to_i << 16
    ip_int += $1.to_i << 24
  end

  #returns a human-readable IP address in dotted-octet notation
  def IpUtil.ip_int_to_string(ip_int)
    ip_string = ""
    ip_string <<        "#{( ip_int >> 24)}"
    ip_string << "." << "#{((ip_int >> 16) & 0xff)}"
    ip_string << "." << "#{((ip_int >>  8) & 0xff)}"
    ip_string << "." << "#{( ip_int        & 0xff)}"
  end
  
  #performs a reverse DNS lookup on specified IP
  def IpUtil.reverse_dns(ip_string)
    s = Socket.getaddrinfo(ip_string, nil)
    s[0][2]
  end

end
