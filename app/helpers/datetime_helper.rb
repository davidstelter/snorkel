#Copyright © 2009 David Stelter
#This software is released under the terms of the Modified BSD License
#Please see the file COPYING in the root source directory for details
#
module DatetimeHelper

  def fmtdate(time)
    if time
      time.localtime.strftime("%T.#{time.usec.to_s.slice(0,2)} %D")
    else
      'never'
    end
  end
end
    
