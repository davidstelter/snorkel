# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class ReferenceSystem < ActiveRecord::Base
  set_table_name "reference_system"
  self.primary_key = "ref_system_id"
  has_many :references,
           :class_name  => "Reference",
           :foreign_key => "ref_system_id"
end
