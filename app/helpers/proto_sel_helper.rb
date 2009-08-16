# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details 
module ProtoSelHelper
  def proto_sel(id, selected = nil)
    selected ||= 'ANY'
    list = { -1 => 'ANY', 6 => 'TCP',  17 => 'UDP', 1 => 'ICMP'}
    sel(id, list, selected)
  end 
end
