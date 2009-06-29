class SignaturesController < ApplicationController
  def summary
    @signatures = Signature.paginate :page => params[:page], :order => 'sig_id'
  end

  def detail
    @signature = Signature.find(params[:id])
    @events    = @signature.events.paginate :page => params[:page], :order => 'timestamp'
  end

end
