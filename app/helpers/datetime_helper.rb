module DatetimeHelper

  def fmtdate(time)
    time.localtime.strftime("%T %D")
  end
end
    
