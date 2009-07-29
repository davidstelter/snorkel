class IpHostCacheTable < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE TABLE ip_host_cache ( 
      ip_host_cache_id bigint PRIMARY KEY,
      events_as_src bigint NOT NULL DEFAULT 0,
      events_as_dst bigint NOT NULL DEFAULT 0,
      sigs_as_src bigint NOT NULL DEFAULT 0,
      sigs_as_dst bigint NOT NULL DEFAULT 0,
      updated timestamp NOT NULL DEFAULT '1970-01-01 00:00:00 UTC'
      );
    }
  end

  def self.down
    execute %{
      DROP TABLE ip_host_cache;
    }
  end
end
