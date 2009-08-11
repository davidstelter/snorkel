class AlertFilterDateWorkaround < ActiveRecord::Migration
  def self.up
    remove_column :alert_filters, :date
    add_column    :alert_filters, :date, :string
  end

  def self.down
  end
end
