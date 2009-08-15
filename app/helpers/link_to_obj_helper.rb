module LinkToObjHelper
  def link_to_obj(obj, disp, params={})
    if obj
      if disp == :timestamp
        link_to ((fmtdate obj.send(disp)), {:controller => 'alerts', :action => 'detail', :id =>obj})
      else
        link_to (obj.send(disp), {:controller => 'alerts', :action => 'detail', :id =>obj})
      end
    else
      '-'
    end
  end
end


