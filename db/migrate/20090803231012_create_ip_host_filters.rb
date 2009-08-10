class CreateIpHostFilters < ActiveRecord::Migration
  def self.up
    create_table :ip_host_filters do |t|
      t.column :name,          :string
      t.column :network,       :bigint 
      t.column :netmask,       :integer
      t.column :min_sig_pri,   :integer
      t.column :active_since,  'timestamp with time zone'
      t.column :active_before, 'timestamp with time zone' 
      t.column :min_act_idx,   :integer
      t.column :max_act_idx,   :integer
      t.column :min_sig_cnt,   :integer
      t.column :max_sig_cnt,   :integer
      t.column :min_alert_cnt, :integer
      t.column :max_alert_cnt, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :ip_host_filters
  end
end
