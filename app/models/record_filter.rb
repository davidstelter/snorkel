#Copyright © 2009 David Stelter
#This software is released under the terms of the Modified BSD License
#Please see the file COPYING in the root source directory for details
module RecordFilter 
  include IpUtil

  def cond_ge(col, val)
    if self.send(val)
      @cond_arry << "#{col.to_s} >= :#{val}"
      @cond_hash[val] = self.send(val)
    end
  end

  def cond_gt(col, val)
    if self.send(val)
      @cond_arry << "#{col.to_s} > :#{val}"
      @cond_hash[val] = self.send(val)
    end
  end
  
  def cond_le(col, val)
    if self.send(val)
      @cond_arry << "#{col.to_s} <= :#{val}"
      @cond_hash[val] = self.send(val)
    end
  end

  def cond_lt(col, val)
    if self.send(val)
      @cond_arry << "#{col.to_s} < :#{val}"
      @cond_hash[val] = self.send(val)
    end
  end

  def cond_eq(col, val = nil)
    val ||= col
    if self.send(val)
      @cond_arry << "#{col.to_s} = :#{val}"
      @cond_hash[val] = self.send(val)
    end
  end

  def cond_like(col, val)
    if self.send(val)
      @cond_arry << "#{col.to_s} ~ :#{val}"
      @cond_hash[val] = self.send(val)
    end
  end

  def cond_ip_and_mask(col, ip, mask)
    if ip 
      lo_ip = ip
      if mask
        hi_ip = IpUtil.high_ip(ip, mask)
      else
        hi_ip = lo_ip
      end

      colstr = col.to_s
      unless lo_ip == 0 and hi_ip == 0
        @cond_arry << "#{colstr} BETWEEN :#{colstr}_min_ip AND :#{colstr}_max_ip"
        @cond_hash["#{colstr}_min_ip".intern] = lo_ip 
        @cond_hash["#{colstr}_max_ip".intern] = hi_ip
      end
    end
  end

#join everything together into a query string
  def _gen_sql
    cond_str = @cond_arry.join(" AND ")
    @conditions = [ cond_str, @cond_hash ]
  end

  
# returns the list of rows which match the filter conditions
  def filtered_list
    @iphosts = @filter_for.find(:all,
                           :limit      => self.limit,
                           :offset     => self.offset, 
                           :order      => self.order,
                           :conditions => @conditions)
  end

#returns the number of filtered model which match the filter conditions
  def filtered_count
    @filter_for.count(:conditions => @conditions)
  end

end
