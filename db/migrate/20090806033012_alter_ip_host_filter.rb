class AlterIpHostFilter < ActiveRecord::Migration
  def self.up
    remove_column :ip_host_filters, :min_sig_cnt
    remove_column :ip_host_filters, :max_sig_cnt
    remove_column :ip_host_filters, :min_alert_cnt
    remove_column :ip_host_filters, :max_alert_cnt

    add_column :ip_host_filters, :min_src_sig,   :integer
    add_column :ip_host_filters, :max_src_sig,   :integer
    add_column :ip_host_filters, :min_dst_sig,   :integer
    add_column :ip_host_filters, :max_dst_sig,   :integer
    add_column :ip_host_filters, :min_src_alert, :integer
    add_column :ip_host_filters, :max_src_alert, :integer
    add_column :ip_host_filters, :min_dst_alert, :integer
    add_column :ip_host_filters, :max_dst_alert, :integer
  end

  def self.down
  end
end
