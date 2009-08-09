# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class AlertsController < ApplicationController
  include ControllerCommon

  def summary
    if params[:order]
      order = params[:order]
    elsif params[:order_desc]
      order = params[:order_desc]
      order += ' DESC'
    else
      order = 'timestamp'
    end

    cond_string = []
    cond_hash   = {}

    params[:ip_src_mask] = 0 unless pset params[:ip_src_mask]
    params[:ip_dst_mask] = 0 unless pset params[:ip_dst_mask]

    if pset params[:sig_name]
      cond_string << "sig_name ~ :sig_name"
      cond_hash[:sig_name] = "#{params[:sig_name]}"
    end

    if pset params[:sig_sid]
      cond_string << "sig_sid = :sig_sid"
      cond_hash[:sig_sid] = "#{params[:sig_sid]}"
    end

    if pset params[:sensor]
      cond_string << "sid = :sensor"
      cond_hash[:sensor] = "#{params[:sensor]}"
    end

     if pset params[:on]
      cond_string << "timestamp ~ :time"
      cond_hash[:time] = "#{params[:on]}"
    end

    if pset params[:after]
      cond_string << "timestamp > :time"
      cond_hash[:time] = "#{params[:after]}"
    end

    if pset params[:before]
      cond_string << "timestamp < :time"
      cond_hash[:time] = "#{params[:before]}"
    end

    if pset params[:ip_src]
      ip = Iphdr.ip_string_to_int(params[:ip_src])

      if params[:ip_src_mask].to_i > 0
        ip_lo = ip
        ip_hi = ip_lo + 2 ** params[:ip_src_mask].to_i - 1
        cond_string << "ip_src >= :ip_src_lo AND ip_src <= :ip_src_hi"
        cond_hash[:ip_src_lo] = ip_lo
        cond_hash[:ip_src_hi] = ip_hi
      else
        cond_string << "ip_src = :ip_src"
        cond_hash[:ip_src] = ip
      end
    end

    if pset params[:ip_dst]
      ip = Iphdr.ip_string_to_int(params[:ip_dst]) 
      if params[:ip_dst_mask].to_i > 0
        ip_lo = ip 
        ip_hi = ip_lo + 2 ** params[:ip_dst_mask].to_i - 1
        cond_string << "ip_dst >= :ip_dst_lo AND ip_dst <= :ip_dst_hi"
        cond_hash[:ip_dst_lo] = ip_lo
        cond_hash[:ip_dst_hi] = ip_hi
      else
        cond_string << "ip_dst = :ip_dst"
        cond_hash[:ip_dst] = ip 
      end
    end

    if params[:proto] 
      proto = case
              when "#{params[:proto]}" == "ANY" : -1
              when "#{params[:proto]}" == "TCP" :  6
              when "#{params[:proto]}" == "UDP" : 17
              when "#{params[:proto]}" == "ICMP":  1
              else                                -2
              end
      if proto >= 0
        cond_string << "ip_proto = :proto"
        cond_hash[:proto] = proto
      end
    end

    conditions = cond_string.join(" AND ")


    count = Alert.count(:conditions => [ conditions, cond_hash ])
    @summary_pager  = Pager.new(count, params[:page])
   # page_offset = 0
   # if pset params[:page]
   #   page_offset = (params[:page].to_i - 1) * Pager.per_page
   # end

    @alerts    = Alert.find(:all, 
                            :limit      => @summary_pager.per_page, 
                            :offset     => @summary_pager.offset, 
                            :order      => order,
                            :conditions => [ conditions, cond_hash ])

    
  end

  def detail
    if params[:id]
      @alert = Alert.find(params[:id])
    else
      @alert = Alert.find(:first)
    end
  end

end
