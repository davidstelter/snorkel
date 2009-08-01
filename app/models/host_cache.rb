class HostCache < ActiveRecord::Base
  set_table_name "cache_update"
  set_primary_key "last_updated"

  def update_cache
    sql = "SELECT refresh_ip_host_cache();"
    ActiveRecord::Base.connection.execute(sql)
  end
end
