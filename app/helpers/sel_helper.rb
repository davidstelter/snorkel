# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details
module SelHelper
#makes a simple HTML selection list
  #id is used for id and name
  #list is a hash of option => text
  #selected can use either option or text
  def sel(id, list, selected)
    sel = ""
    sel += %{<select id=#{id} name=#{id}>}
    list.each { |k, v|
      if selected && (selected.to_s == k.to_s || selected == v)
        sel += %{<option value="#{k}" selected="selected">#{v}</option>}
      else
        sel += %{<option value="#{k}">#{v}</option>}
      end
    }
    sel += %{</select>}
  end
end
