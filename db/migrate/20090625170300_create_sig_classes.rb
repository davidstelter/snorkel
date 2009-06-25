class CreateSigClasses < ActiveRecord::Migration
  def self.up
    create_table :sig_classes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :sig_classes
  end
end
