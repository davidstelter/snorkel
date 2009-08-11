class AddSigNamAlertFil < ActiveRecord::Migration
  def self.up
    add_column :alert_filters, :sig_name, :string

  end

  def self.down
  end
end
