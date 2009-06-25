class CreateIcmphdrs < ActiveRecord::Migration
  def self.up
    create_table :icmphdrs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :icmphdrs
  end
end
