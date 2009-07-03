# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Signature < ActiveRecord::Base
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

  def class_name
    if self.sig_class
      self.sig_class.sig_class_name
    else
      'Unclassified'
    end
  end

  def first_seen
    first_event = Event.find(:first, 
                      :conditions => "signature = #{self.sig_id}",
                      :order => "timestamp")
    first_event.timestamp
  end

  def last_seen
    last_event = Event.find(:first, 
                      :conditions => "signature = #{self.sig_id}",
                      :order => "timestamp DESC")
    last_event.timestamp
  end
end
