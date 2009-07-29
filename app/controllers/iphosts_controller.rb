class IphostsController < ApplicationController
  def summary

    if params[:order]
      order = params[:order]
    elsif params[:order_desc]
      order = params[:order_desc]
      order += ' DESC'
    else
      params[:order_desc] = 'act_idx'
      order = 'act_idx DESC'
    end

    @summary_pager = Pager.new(IpHost.count, params[:page])

    cond_string  = []
    cond_hash    = {}
    

    conditions = cond_string.join(" AND ")

    @iphosts = IpHost.find(:all,
                           :limit      => @summary_pager.per_page,
                           :offset     => @summary_pager.offset, 
                           :order      => order,
                           :conditions => [ conditions, cond_hash])

  end

  def detail
    if params[:id]
      @iphost = IpHost.find_by_ip_string(params[:id])

      @fe_as_src = @iphost.first_event_as_src
      @le_as_src = @iphost.last_event_as_src 
      @fe_as_dst = @iphost.first_event_as_dst
      @le_as_dst = @iphost.last_event_as_dst 

      @fe_as_src_timestamp = @iphost.first_seen_as_src ? @iphost.first_seen_as_src : "Never"
      @le_as_src_timestamp = @iphost.last_seen_as_src  ? @iphost.last_seen_as_src  : "Never"
      @fe_as_dst_timestamp = @iphost.first_seen_as_dst ? @iphost.first_seen_as_dst : "Never"
      @le_as_dst_timestamp = @iphost.last_seen_as_dst  ? @iphost.last_seen_as_dst  : "Never"

    end
  end

end
