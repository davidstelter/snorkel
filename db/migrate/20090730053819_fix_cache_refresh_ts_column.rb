class FixCacheRefreshTsColumn < ActiveRecord::Migration
  def self.up
    execute %{
      DROP TABLE IF EXISTS cache_update;

      CREATE TABLE cache_update (
        last_updated timestamp with time zone NOT NULL
      );
    }
  end

  def self.down
  end
end
