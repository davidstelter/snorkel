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

      @fe_as_src = Event.with_ip_src(@iphost.ip_string).earliest.first
      @le_as_src = Event.with_ip_src(@iphost.ip_string).latest.first
      @fe_as_dst = Event.with_ip_dst(@iphost.ip_string).earliest.first
      @le_as_dst = Event.with_ip_dst(@iphost.ip_string).latest.first

      @fe_as_src_timestamp = @fe_as_src ? @fe_as_src.timestamp : "Never"
      @le_as_src_timestamp = @le_as_src ? @le_as_src.timestamp : "Never"
      @fe_as_dst_timestamp = @fe_as_dst ? @fe_as_dst.timestamp : "Never"
      @le_as_dst_timestamp = @le_as_dst ? @le_as_dst.timestamp : "Never"

    end
  end

end
