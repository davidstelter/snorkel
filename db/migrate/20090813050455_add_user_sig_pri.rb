class AddUserSigPri < ActiveRecord::Migration
  def self.up
    add_column :signature, :sig_user_pri, :int
  end

  def self.down
  end
end
