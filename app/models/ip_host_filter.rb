class IpHostFilter < ActiveRecord::Base
  require 'record_filter'
  include RecordFilter
  include IpUtil

  attr_accessor :order, :limit, :offset
  validates_numericality_of :network, :netmask, :min_sig_pri, 
                            :min_act_idx,   :max_act_idx, 
                            :min_sig_cnt,   :max_sig_cnt,
                            :min_alert_cnt, :max_alert_cnt

# reads the params hash into instance variables
  def read_params(params = {})
#TODO: move ordering code to RecordFilter
    if params[:order]
      order = params[:order]
    elsif params[:order_desc]
      order = params[:order_desc]
      order += ' DESC'
    else
      params[:order_desc] = 'act_idx'
      order = 'act_idx DESC'
    end
    self.order = order

    self.network = IpUtil.ip_string_to_int(params[:network])
    self.netmask = params[:netmask].to_i
    
    self.min_sig_pri   = params[:min_sig_pri]
    self.min_act_idx   = params[:min_act_idx]
    self.max_act_idx   = params[:max_act_idx]

    self.min_src_sig   = params[:min_src_sig]
    self.max_src_sig   = params[:max_src_sig]
    self.min_dst_sig   = params[:min_dst_sig]
    self.max_dst_sig   = params[:max_dst_sig]

    self.min_src_alert = params[:min_src_alert]
    self.max_src_alert = params[:max_src_alert]
    self.min_dst_alert = params[:min_dst_alert]
    self.max_dst_alert = params[:max_dst_alert]
    
    self.build_conditions
  end

# builds a condition string and hash from instance variables
  def build_conditions
    @filter_for = IpHost #TODO: make this smarter!
    @cond_arry  = []
    @cond_hash  = {}

    self.cond_ip_and_mask(:ip_addr, self.network, self.netmask)
    
    #act_idx
    self.cond_ge(:act_idx, :min_act_idx)
    self.cond_le(:act_idx, :max_act_idx)

    #sig 
    self.cond_ge(:src_sig_cnt, :min_src_sig)
    self.cond_le(:src_sig_cnt, :max_src_sig) 
    self.cond_ge(:dst_sig_cnt, :min_dst_sig)
    self.cond_le(:dst_sig_cnt, :max_dst_sig)  

    #alert
    self.cond_ge(:src_ev_cnt, :min_src_alert)
    self.cond_le(:src_ev_cnt, :max_src_alert)
    self.cond_ge(:dst_ev_cnt, :min_dst_alert)
    self.cond_le(:dst_ev_cnt, :max_dst_alert)
       
    self._gen_sql
  end

end
