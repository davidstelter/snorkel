class SignaturesController < ApplicationController
  def summary
    @signatures = Signature.find(:all)
  end

  def detail
    @signature = Signature.find(params[:id])
    @events    = @signature.events
  end

end
