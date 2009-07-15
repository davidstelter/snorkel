# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Signature < ActiveRecord::Base
  set_table_name "sig_with_event_count"
  self.primary_key = "sig_id"
  belongs_to :sig_class,
             :class_name  => "SigClass",
             :foreign_key => "sig_class_id"
  has_many   :alerts,
             :class_name  => "Alert",
             :foreign_key => "sig_id"
  has_many   :events,
             :class_name  => "Event",
             :foreign_key => "signature"
  has_many   :sig_references,
             :class_name  => "SigReference",
             :foreign_key => "sig_id"
  has_many   :references,
             :through     => :sig_references,
             :source      => :reference

#  named_scope :with_ip_src, lambda { |ip_str| { 

  def class_name
    if self.sig_class
      self.sig_class.sig_class_name
    else
      'unclassified'
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

  def Signature.with_min_alerts(count)
    Signature.find_by_sql([%{
      SELECT * FROM signature 
      WHERE sig_id IN 
        (SELECT signature FROM event 
         GROUP BY event.signature 
         HAVING count(*) >= ?)
    }, count])
  end

  def Signature.with_ip_src(ip_str)
    Signature.find_by_sql(%{
      SELECT DISTINCT s.* 
      FROM signature s JOIN event e ON s.sig_id = e.signature 
      JOIN iphdr ip ON e.sid = ip.sid AND e.cid = ip.cid 
      WHERE ip.ip_src = #{Iphdr.ip_string_to_int(ip_str)}
    })
  end

  def Signature.with_ip_dst(ip_str)
    Signature.find_by_sql(%{
      SELECT DISTINCT s.* 
      FROM signature s JOIN event e ON s.sig_id = e.signature 
      JOIN iphdr ip ON e.sid = ip.sid AND e.cid = ip.cid 
      WHERE ip.ip_dst = #{Iphdr.ip_string_to_int(ip_str)}
    })
  end

end
