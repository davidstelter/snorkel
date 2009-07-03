# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details 

class Detail < ActiveRecord::Base
  set_table_name "detail"
  self.primary_key = "detail_type"
  has_many :sensors,
           :class_name  => "Sensor",
           :foreign_key => "detail"
end
