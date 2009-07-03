# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Reference < ActiveRecord::Base
  set_table_name "reference"
  self.primary_key = "ref_id"
  belongs_to :reference_system,
             :class_name  => "ReferenceSystem",
             :foreign_key => "ref_system_id"
  has_many   :sig_references,
             :class_name  => "SigReference",
             :foreign_key => "ref_id"
  has_many   :signatures,
             :through     => :sig_references,
             :source      => :signature 

end
