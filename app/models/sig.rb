# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

#this simple little class is for doing deletions, as the more complex Signature class
#is actually getting its data from a view and can't easily delete its DB row
class Sig < ActiveRecord::Base
  set_table_name "signature"
  self.primary_key = "sig_id"
  belongs_to :sig_class,
             :class_name  => "SigClass",
             :foreign_key => "sig_class_id"
  has_many   :events,
             :class_name  => "Event",
             :foreign_key => "signature"
  has_many   :sig_references,
             :class_name  => "SigReference",
             :foreign_key => "sig_id"
  has_many   :references,
             :through     => :sig_references,
             :source      => :reference

 end
