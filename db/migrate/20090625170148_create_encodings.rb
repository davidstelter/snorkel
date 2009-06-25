class CreateEncodings < ActiveRecord::Migration
  def self.up
    create_table :encodings do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :encodings
  end
end
