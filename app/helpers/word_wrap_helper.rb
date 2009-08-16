# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details
module WordWrapHelper
  def ww(str, col = 40)
    br = "<br>"
    sp = "-"
#bound_thresh controls how many chars back to look for a word boundary before splitting a word
    bound_thresh = 4
    if str.length <= col
      return str
    end
    out = ""
    lines = []
    line = ""
    words = str.split(/\s/)
    words.each { |w| 
      if line.length + w.length + 1 > col
        split = col - (line.length )
        if split > bound_thresh
          split -= 1
          line += "#{w.slice(0, split)}#{sp}"
          lines << line
          line = "#{w.slice(split, w.length)} "
        else
          lines << line
          line = "#{w} "
        end
      else
        line += "#{w} "
      end
    }
    lines << line

    out = lines.join(br)
  end

end


