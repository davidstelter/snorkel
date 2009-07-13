# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class AlertsController < ApplicationController
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

    if params[:sig_name] && params[:sig_name].length > 0
      cond_string << "sig_name ~ :sig_name"
      cond_hash[:sig_name] = "#{params[:sig_name]}"
    end

    if params[:sensor] && params[:sensor].length > 0
      cond_string << "sid = :sensor"
      cond_hash[:sensor] = "#{params[:sensor]}"
    end

     if params[:on] && params[:on].length > 0
      cond_string << "timestamp ~ :time"
      cond_hash[:time] = "#{params[:on]}"
    end

    if params[:after] && params[:after].length > 0
      cond_string << "timestamp > :time"
      cond_hash[:time] = "#{params[:after]}"
    end

    if params[:before] && params[:before].length > 0
      cond_string << "timestamp < :time"
      cond_hash[:time] = "#{params[:before]}"
    end

    if params[:ip_src] && params[:ip_src].length > 0
      cond_string << "ip_src = :ip_src"
      cond_hash[:ip_src] = "#{Iphdr.ip_string_to_int(params[:ip_src])}"
    end

    if params[:ip_dst] && params[:ip_dst].length > 0
      cond_string << "ip_dst = :ip_dst"
      cond_hash[:ip_dst] = "#{Iphdr.ip_string_to_int(params[:ip_dst])}"
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


    @filter_count = Alert.find(:all, :conditions => [ conditions, cond_hash ]).count
    @summary_pager  = Pager.new(@filter_count, params[:page])
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
