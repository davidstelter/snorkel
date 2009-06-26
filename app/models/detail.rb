class Detail < ActiveRecord::Base
  set_table_name "detail"
  self.primary_key = "detail_type"
  has_many :sensors,
           :class_name  => "Sensor",
           :foreign_key => "detail"
end
