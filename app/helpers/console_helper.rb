# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

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
