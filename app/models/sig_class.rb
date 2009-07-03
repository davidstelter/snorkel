# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class SigClass < ActiveRecord::Base
  set_table_name "sig_class"
  self.primary_key = "sig_class_id"
  has_many :signatures,
           :class_name  => "Signature",
           :foreign_key => "sig_class_id"
end
