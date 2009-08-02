class ReallyFixCacheTimestamp < ActiveRecord::Migration
  def self.up
    execute %{
      DROP FUNCTION IF EXISTS refresh_ip_host_cache();

      CREATE FUNCTION refresh_ip_host_cache() 
      RETURNS timestamp with time zone
      AS $$
        DELETE FROM ip_host_cache;
        DELETE FROM cache_update;

        INSERT INTO ip_host_cache (ip_addr, src_ev_cnt, dst_ev_cnt, src_sig_cnt, dst_sig_cnt, act_idx)
        SELECT ip_addr, src_ev_cnt, dst_ev_cnt, src_sig_cnt, dst_sig_cnt, act_idx FROM ip_host;

        INSERT INTO cache_update (SELECT CURRENT_TIMESTAMP);
        SELECT last_updated from cache_update AS result LIMIT 1;
      $$ LANGUAGE SQL;
    }

  end

  def self.down
  end
end
