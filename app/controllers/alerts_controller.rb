# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class AlertsController < ApplicationController
  include ControllerCommon

  def summary

    filter = AlertFilter.new
    filter.read_params(params)
    count = filter.filtered_count

    @summary_pager = Pager.new(count, params[:page])
    filter.limit   = @summary_pager.per_page
    filter.offset  = @summary_pager.offset

    @alerts = filter.filtered_list
  end


  def detail
    if params[:id]
      @alert = Alert.find(params[:id])
    else
      @alert = Alert.find(:first)
    end
  end

end
