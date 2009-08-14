module ProtoSelHelper
  def proto_sel(id, selected = nil)
    selected ||= 'ANY'
    list = { -1 => 'ANY', 6 => 'TCP',  17 => 'UDP', 1 => 'ICMP'}
    sel(id, list, selected)
  end 
end
