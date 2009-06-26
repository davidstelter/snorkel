class SigReference < ActiveRecord::Base
  set_table_name "sig_reference"
  set_primary_keys :ref_id, :sig_id
  belongs_to :reference
  belongs_to :signature

end
