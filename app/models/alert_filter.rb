class AlertFilter < ActiveRecord::Base
  include RecordFilter
  include IpUtil

  attr_accessor :order, :limit, :offset
  validates_numericality_of :sig_sid

  def read_params(params = {})
    if params[:order]
      order = params[:order]
    elsif params[:order_desc]
      order = params[:order_desc]
      order += ' DESC'
    else
      params[:order_desc] = 'timestamp'
      order = 'timestamp DESC'
    end
    self.order = order


    self.name = params[:filter_name]

    self.ip_src    = IpUtil.ip_string_to_int(params[:ip_src])
    self.src_mask  = params[:src_mask]
    self.ip_dst    = IpUtil.ip_string_to_int(params[:ip_dst])
    self.dst_mask  = params[:dst_mask]

    self.sig_sid   = params[:sig_sid]
    self.date      = params[:date]
    self.after     = params[:after]
    self.before    = params[:before]

    self.l4_proto  = case
                     when "#{params[:l4_proto]}" == "ANY" : -1
                     when "#{params[:l4_proto]}" == "TCP" :  6
                     when "#{params[:l4_proto]}" == "UDP" : 17
                     when "#{params[:l4_proto]}" == "ICMP":  1
                     else                                   -2
                     end

    self.l4_src_lo = params[:l4_src_lo]
    self.l4_src_hi = params[:l4_src_hi]
    self.l4_dst_lo = params[:l4_dst_lo]
    self.l4_dst_hi = params[:l4_dst_hi]
  
    self.build_conditions
  end

  def build_conditions
    @filter_for = Alert
    @cond_arry  = []
    @cond_hash  = {} 

    self.cond_eq(:sig_sid, :sig_sid)

    self.cond_ip_and_mask(:ip_src, self.ip_src, self.src_mask)
    self.cond_ip_and_mask(:ip_dst, self.ip_dst, self.dst_mask)

  #L4
    self.cond_eq(:ip_proto, :l4_proto) unless self.l4_proto < 0

    if self.l4_proto == 6 #TCP
      self.cond_le(:tcp_sport, :l4_src_hi)
      self.cond_ge(:tcp_sport, :l4_src_lo)
      self.cond_le(:tcp_dport, :l4_dst_hi)
      self.cond_ge(:tcp_dport, :l4_dst_lo)
    end

    if self.l4_proto == 17 #UDP
      self.cond_le(:udp_sport, :l4_src_hi)
      self.cond_ge(:udp_sport, :l4_src_lo)
      self.cond_le(:udp_dport, :l4_dst_hi)
      self.cond_ge(:udp_dport, :l4_dst_lo)
    end

  #date
    self.cond_like(:timestamp, :date)
    self.cond_lt(:timestamp, :before)
    self.cond_gt(:timestamp, :after)

  
    self._gen_sql
  end
  

    
end
