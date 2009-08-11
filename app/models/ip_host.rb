# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class IpHost < ActiveRecord::Base
  include IpUtil

  set_table_name "ip_host_cache"
  set_primary_key :ip_addr

  def IpHost.find_by_ip_string(ip_str)
    IpHost.find( IpUtil.ip_string_to_int(ip_str) )
  end

  def ip_string
    IpUtil.ip_int_to_string(self.ip_addr)
  end

  def hostname
    if @hostname == nil
      @hostname = IpUtil.reverse_dns(self.ip_string)
    end
    @hostname
  end

  def first_seen
    ev = first_event
    time = ev ? ev.timestamp : nil
  end

  def first_event
    first_event = nil
    as_src = self.first_event_as_src
    as_dst = self.first_event_as_dst

    if as_src == nil
      first_event = as_dst
    elsif as_dst == nil
      first_event = as_src
    else
      if as_src.older?(as_dst)
        first_event = as_src
      else
        first_event = as_dst
      end
    end
    first_event
  end

  def last_seen
    ev = last_event
    time = ev ? ev.timestamp : nil
  end

  def last_event
    last_event = nil
    as_src = self.last_event_as_src
    as_dst = self.last_event_as_dst

    if as_src == nil
      last_event = as_dst
    elsif as_dst == nil
      last_event = as_src
    else
      if as_src.older?(as_dst)
        last_event = as_dst
      else
        last_event = as_dst
      end
    end
    last_event
  end


  def first_event_as_src
    Event.with_ip_src(self.ip_string).earliest.first
  end 

  def last_event_as_src
    Event.with_ip_src(self.ip_string).latest.first
  end

  def first_event_as_dst
    Event.with_ip_dst(self.ip_string).earliest.first
  end

  def last_event_as_dst
    Event.with_ip_dst(self.ip_string).latest.first
  end

  def first_seen_as_src
    ev = self.first_event_as_src
    time = nil
    time = ev.timestamp if ev
    time
  end

  def last_seen_as_src
    ev = self.last_event_as_src
    time = nil
    time = ev.timestamp if ev
    time
  end

  def first_seen_as_dst
    ev = self.first_event_as_dst
    time = nil
    time = ev.timestamp if ev
    time
  end

  def last_seen_as_dst
    ev = self.last_event_as_dst
    time = nil
    time = ev.timestamp if ev
    time
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

end
