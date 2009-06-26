class Sensor < ActiveRecord::Base
  set_table_name "sensor"
  self.primary_key = "sid"
  belongs_to :detail,
             :class_name  => "Detail",
             :foreign_key => "detail"
  belongs_to :encoding,
             :class_name  => "Encoding",
             :foreign_key => "encoding"
end
