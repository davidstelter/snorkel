class IpHost
  attr_reader :as_src, :as_dst, :ip_string

  def initialize(ip_str)
    @ip_string = ip_str
    @as_src = Iphdr.find_by_src_ip_string(ip_str)
    @as_dst = Iphdr.find_by_dst_ip_string(ip_str)
  end

  def hostname
    if @hostname == nil
      s = Socket.getaddrinfo(@ip_string, nil)
      @hostname = s[0][2]
    end
    @hostname
  end
end
