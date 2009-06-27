class ConsoleController < ApplicationController

  def index
    @signatures = Signature.find(:all)
  end

protected
  
  

end
