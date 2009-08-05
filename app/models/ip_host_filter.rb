class IpHostFilter < ActiveRecord::Base
  attr_accessor :order, :limit, :offset
  validates_numericality_of :network, :netmask, :min_sig_pri, 
                            :min_act_idx,   :max_act_idx, 
                            :min_sig_cnt,   :max_sig_cnt,
                            :min_alert_cnt, :max_alert_cnt

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

    self.build_conditions
  end

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

    cond_str = cond_arry.join(" AND ")

    @conditions = [ cond_str, cond_hash ]
  end


  def filtered_list(params = {})
    @iphosts = IpHost.find(:all,
                           :limit      => self.limit,
                           :offset     => self.offset, 
                           :order      => self.order,
                           :conditions => @conditions)
  end

  def filtered_count(params = {})
    IpHost.count(:conditions => @conditions)
  end


end
