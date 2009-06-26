class Encoding < ActiveRecord::Base
  set_table_name "encoding"
  self.primary_key = "encoding_type"
  has_many :sensors,
           :class_name  => "Sensor",
           :foreign_key => "encoding"
end
