class IphostsController < ApplicationController
  def summary
  end

  def detail
    if params[:id]
      @iphost = IpHost.new(params[:id])

      @fe_as_src = Event.with_ip_src(@iphost.ip_string).earliest.first
      @le_as_src = Event.with_ip_src(@iphost.ip_string).latest.first
      @fe_as_dst = Event.with_ip_dst(@iphost.ip_string).earliest.first
      @le_as_dst = Event.with_ip_dst(@iphost.ip_string).latest.first

    end
  end

end
