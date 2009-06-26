class ReferenceSystem < ActiveRecord::Base
  set_table_name "reference_system"
  self.primary_key = "ref_system_id"
  has_many :references,
           :class_name  => "Reference",
           :foreign_key => "ref_system_id"
end
