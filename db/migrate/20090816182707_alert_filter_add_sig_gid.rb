class AlertFilterAddSigGid < ActiveRecord::Migration
  def self.up
    add_column :alert_filters, :sig_gid, :integer
  end

  def self.down
  end
end
