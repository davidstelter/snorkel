class DropMispelingView < ActiveRecord::Migration
  def self.up
    execute %{
      DROP VIEW sig_sith_event_count;
    }
  end

  def self.down
  end
end
