class AlterAlertFilters < ActiveRecord::Migration
  def self.up
    rename_column :alert_filters, :dst_ip, :ip_dst
    rename_column :alert_filters, :src_ip, :ip_src
  end

  def self.down
  end
end
