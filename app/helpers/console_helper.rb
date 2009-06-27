module ConsoleHelper

  def event_count
    Event.count
  end

  def sig_count
    Signature.count
  end

  def src_ip_count
    Iphdr.count(:ip_src, :distinct => :true)
  end

  def dst_ip_count
    Iphdr.count(:ip_dst, :distinct => :true)
  end


end
