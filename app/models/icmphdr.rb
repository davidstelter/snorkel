# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Icmphdr < ActiveRecord::Base
  set_table_name "icmphdr"
  set_primary_keys :cid, :sid
  belongs_to :iphdr,
             :dependent => :destroy,
             :class_name => "Iphdr",
             :foreign_key => [:cid, :sid]

end
