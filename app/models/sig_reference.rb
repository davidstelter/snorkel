# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class SigReference < ActiveRecord::Base
  set_table_name "sig_reference"
  set_primary_keys :ref_id, :sig_id
  belongs_to :reference,
             :class_name  => "Reference",
             :foreign_key => "ref_id"
  belongs_to :signature,
             :class_name  => "Signature",
             :foreign_key => "sig_id"

end
