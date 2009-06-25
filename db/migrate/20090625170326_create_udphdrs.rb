class CreateUdphdrs < ActiveRecord::Migration
  def self.up
    create_table :udphdrs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :udphdrs
  end
end
