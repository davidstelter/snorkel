# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Encoding < ActiveRecord::Base
  set_table_name "encoding"
  self.primary_key = "encoding_type"
  has_many :sensors,
           :class_name  => "Sensor",
           :foreign_key => "encoding"
end
