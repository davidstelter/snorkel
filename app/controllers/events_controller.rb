class EventsController < ApplicationController
  def summary
    order = 'timestamp'
    #if @summary_pager
    #  @summary_pager.page = params[:page] || '1'
    #else
      @summary_pager  = Pager.new(Event.count, params[:page])
    #end
    @events    = Event.find(:all, 
                            :limit => @summary_pager.per_page, 
                            :offset => @summary_pager.offset, 
                            :order => order)
  end

  def detail
    if params[:id]
      @event = Event.find(params[:id])
    else
      @event = Event.find(:first)
    end

  end

end
