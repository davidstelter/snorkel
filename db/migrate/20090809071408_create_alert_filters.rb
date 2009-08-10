class CreateAlertFilters < ActiveRecord::Migration
  def self.up
    create_table :alert_filters do |t|
      t.column :name,      :string
      t.column :sig_sid,   :integer
      t.column :date,      'timestamp with time zone'
      t.column :before,    'timestamp with time zone'
      t.column :after,     'timestamp with time zone'
      t.column :src_ip,    :bigint
      t.column :src_mask,  :integer
      t.column :dst_ip,    :bigint
      t.column :dst_mask,  :integer
      t.column :l4_proto,  :integer
      t.column :l4_src_lo, :integer
      t.column :l4_src_hi, :integer
      t.column :l4_dst_lo, :integer
      t.column :l4_dst_hi, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :alert_filters
  end
end
