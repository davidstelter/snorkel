class CreateSigReferences < ActiveRecord::Migration
  def self.up
    create_table :sig_references do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :sig_references
  end
end
