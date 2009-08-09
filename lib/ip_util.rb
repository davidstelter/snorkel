module IpUtil

  # returns the highest IP address in a given network.
  # netaddr and netmask must be integers, netmask is CIDR
  def high_ip(netaddr, netmask)
    netaddr + (2 ** netmask) -1
  end
end
