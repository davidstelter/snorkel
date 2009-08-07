class IpHostFilter < ActiveRecord::Base
  attr_accessor :order, :limit, :offset
  validates_numericality_of :network, :netmask, :min_sig_pri, 
                            :min_act_idx,   :max_act_idx, 
                            :min_sig_cnt,   :max_sig_cnt,
                            :min_alert_cnt, :max_alert_cnt

# reads the params hash into instance variables
  def read_params(params = {})
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

    self.network = Iphdr.ip_string_to_int(params[:network])
    self.netmask = params[:netmask]
    self.min_sig_pri = params[:min_sig_pri]
    self.min_act_idx = params[:min_act_idx]
    self.max_act_idx = params[:max_act_idx]

    self.min_src_sig = params[:min_src_sig]
    self.max_src_sig = params[:max_src_sig]
    self.min_dst_sig = params[:min_dst_sig]
    self.max_dst_sig = params[:max_dst_sig]

    self.min_src_alert = params[:min_src_alert]
    self.min_src_alert = params[:min_src_alert]
    self.max_dst_alert = params[:max_dst_alert]
    self.max_dst_alert = params[:max_dst_alert]
    
    self.build_conditions
  end

# builds a condition string and hash from instance variables
  def build_conditions
    cond_arry  = []
    cond_hash    = {}

    if self.network && self.netmask
      lo_ip = self.network 
      hi_ip = lo_ip + (2 ** (32 - self.netmask.to_i)) - 1
      unless lo_ip == 0 and hi_ip == 0
        cond_arry << "ip_addr BETWEEN :min_ip AND :max_ip"
        cond_hash[:min_ip] = lo_ip 
        cond_hash[:max_ip] = hi_ip
      end
    end
    #act_idx
    if self.min_act_idx
      cond_arry << "act_idx >= :min_act_idx"
      cond_hash[:min_act_idx] = self.min_act_idx
    end
      
    if self.max_act_idx
      cond_arry << "act_idx <= :max_act_idx"
      cond_hash[:max_act_idx] = self.max_act_idx
    end
    #sig 
    if self.min_src_sig
      cond_arry << "src_sig_cnt >= :min_src_sig"
      cond_hash[:min_src_sig] = self.min_src_sig
    end
      
    if self.max_src_sig
      cond_arry << "src_sig_cnt <= :max_src_sig"
      cond_hash[:max_src_sig] = self.max_src_sig
    end

    if self.min_dst_sig
      cond_arry << "dst_sig_cnt >= :min_dst_sig"
      cond_hash[:min_dst_sig] = self.min_dst_sig
    end
      
    if self.max_dst_sig
      cond_arry << "dst_sig_cnt <= :max_dst_sig"
      cond_hash[:max_dst_sig] = self.max_dst_sig
    end
    #alert
    if self.min_src_alert
      cond_arry << "src_ev_cnt >= :min_src_alert"
      cond_hash[:min_src_alert] = self.min_src_alert
    end
      
    if self.max_src_alert
      cond_arry << "src_ev_cnt <= :max_src_alert"
      cond_hash[:max_src_alert] = self.max_src_alert
    end

    if self.min_dst_alert
      cond_arry << "dst_ev_cnt >= :min_dst_alert"
      cond_hash[:min_dst_alert] = self.min_dst_alert
    end
      
    if self.max_dst_alert
      cond_arry << "dst_ev_cnt <= :max_dst_alert"
      cond_hash[:max_dst_alert] = self.max_dst_alert
    end

    
    cond_str = cond_arry.join(" AND ")

    @conditions = [ cond_str, cond_hash ]
  end

# returns the list of IpHosts which match the filter conditions
  def filtered_list(params = {})
    @iphosts = IpHost.find(:all,
                           :limit      => self.limit,
                           :offset     => self.offset, 
                           :order      => self.order,
                           :conditions => @conditions)
  end

#returns the number of IpHosts which match the filter conditions
  def filtered_count(params = {})
    IpHost.count(:conditions => @conditions)
  end
end
