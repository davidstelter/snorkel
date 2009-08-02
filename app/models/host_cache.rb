class HostCache < ActiveRecord::Base
  @@last_updated = nil

  set_table_name "cache_update"
  set_primary_key "last_updated"

  def HostCache.last_updated
    if @@last_updated == nil
      hc = HostCache.find(:first)
      @@last_updated = hc.last_updated
    end
    @@last_updated
  end

  def HostCache.update_cache
    sql = "SELECT refresh_ip_host_cache();"
    ActiveRecord::Base.connection.execute(sql)

    hc = HostCache.find(:first)
    @@last_updated = hc.last_updated
  end
end
