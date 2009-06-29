class ConsoleController < ApplicationController

  def signatures
    if params[:sigs]
      @signatures = Signature.find(params[:sigs])
    else
      @signatures = Signature.find(:all)
    end
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

  def iphost
    @iphost = IpHost.new(params[:ip_addr])
    respond_to do |format|
      format.js
    end
  end


protected
  

end
