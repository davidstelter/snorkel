# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details
module LinkToObjHelper
  def link_to_obj(obj, disp, params={})
    if obj
      link_text = '-'
      if disp == :timestamp
        link_text = fmtdate(obj.send(disp))
      else
        link_text = obj.send(disp)
      end
        link_to (link_text, {:controller => 'alerts', :action => 'detail', :id =>obj})
    else
      '-'
    end
  end
end


