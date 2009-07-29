# this creates an ip_host_cache table, for caching info about hosts.
# it just takes too long to calculate this stuff every time we need it,
# there is an included function to refresh the cache

class SonOfIpHostCacheTable < ActiveRecord::Migration
  def self.up
    execute %{
      DROP TABLE    IF EXISTS ip_host_cache;
      DROP TABLE    IF EXISTS cache_update;
      DROP FUNCTION IF EXISTS refresh_ip_host_cache();

      CREATE TABLE ip_host_cache (
        ip_addr bigint PRIMARY KEY,
        src_ev_cnt  integer NOT NULL DEFAULT 0,
        dst_ev_cnt  integer NOT NULL DEFAULT 0,
        src_sig_cnt integer NOT NULL DEFAULT 0,
        dst_sig_cnt integer NOT NULL DEFAULT 0,
        act_idx     integer NOT NULL DEFAULT 0
      );

      CREATE TABLE cache_update (
        last_updated time with time zone NOT NULL
      );
      
      CREATE FUNCTION refresh_ip_host_cache() 
      RETURNS time with time zone
      AS $$
        DELETE FROM ip_host_cache;
        DELETE FROM cache_update;

        INSERT INTO ip_host_cache (ip_addr, src_ev_cnt, dst_ev_cnt, src_sig_cnt, dst_sig_cnt, act_idx)
        SELECT ip_addr, src_ev_cnt, dst_ev_cnt, src_sig_cnt, dst_sig_cnt, act_idx FROM ip_host;

        INSERT INTO cache_update (SELECT CURRENT_TIME);
        SELECT last_updated from cache_update AS result LIMIT 1;
      $$ LANGUAGE SQL;
    }     
  end

  def self.down
    execute %{
      DROP TABLE    IF EXISTS ip_host_cache;
      DROP TABLE    IF EXISTS cache_update;
      DROP FUNCTION IF EXISTS refresh_ip_host_cache();
    }
  end
end
