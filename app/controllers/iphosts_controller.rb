class IphostsController < ApplicationController
  include ControllerCommon

  def summary

    filter = IpHostFilter.new
    filter.read_params(params)
    count = filter.filtered_count

    @summary_pager = Pager.new(count, params[:page])
    filter.limit  = @summary_pager.per_page
    filter.offset = @summary_pager.offset
    @iphosts = filter.filtered_list

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
