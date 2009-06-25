class CreateOpts < ActiveRecord::Migration
  def self.up
    create_table :opts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :opts
  end
end
