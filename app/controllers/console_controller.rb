class ConsoleController < ApplicationController

  def signatures
    @signatures = Signature.find(:all)
    respond_to do |format|
      format.js
    end
  end

  def alerts
    @events = Event.find(:all, :limit => 20)
    respond_to do |format|
      format.js
    end
  end

  def index
  end

  def signature
    @sig = Signature.find(params[:id])
    @events = @sig.events
    respond_to do |format|
      format.js
    end
  end

protected
  

end
