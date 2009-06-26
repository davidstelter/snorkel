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
