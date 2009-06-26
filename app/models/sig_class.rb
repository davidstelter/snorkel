class SigClass < ActiveRecord::Base
  set_table_name "sig_class"
  self.primary_key = "sig_class_id"
  has_many :signatures,
           :class_name  => "Signature",
           :foreign_key => "sig_class_id"
end
