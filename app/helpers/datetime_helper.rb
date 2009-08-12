#Copyright © 2009 David Stelter
#This software is released under the terms of the Modified BSD License
#Please see the file COPYING in the root source directory for details
#
module DatetimeHelper

  def fmtdate(time)
    time.localtime.strftime("%T %D")
  end
end
    
