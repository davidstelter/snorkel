class Signature < ActiveRecord::Base
  set_table_name "signature"
  self.primary_key = "sig_id"
  belongs_to :sig_class,
             :class_name  => "SigClass",
             :foreign_key => "sig_class_id"
  has_many   :events,
             :class_name  => "Event",
             :foreign_key => "signature"
end
