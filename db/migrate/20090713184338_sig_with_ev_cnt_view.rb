class SigWithEvCntView < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE VIEW sig_with_event_count AS
      SELECT s.*,  count(e.*) AS event_count 
      FROM signature s JOIN event e 
      ON s.sig_id = e.signature 
      GROUP BY e.signature, s.sig_id, s.sig_name, s.sig_class_id, s.sig_priority, s.sig_rev, s.sig_sid, s.sig_gid;
    }
  end

  def self.down
    execute %{DROP VIEW sig_with_event_count;}
  end
end
