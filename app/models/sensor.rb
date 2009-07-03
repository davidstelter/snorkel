# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

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
