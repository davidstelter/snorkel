class SignaturesController < ApplicationController
  def summary

    @signatures = Signature.paginate :page => params[:page], :order => 'sig_id'
  end

  def detail 
    @order     = params[:order] || 'timestamp'
    @signature = Signature.find(params[:id])
    @pager     = Pager.new(@signature.events.count, params[:page])
    @events    = @signature.events.find(:all, :limit => @pager.per_page, :offset => @pager.offset, :order => @order)
  end

end
