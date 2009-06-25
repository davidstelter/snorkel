class CreateTcphdrs < ActiveRecord::Migration
  def self.up
    create_table :tcphdrs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :tcphdrs
  end
end
