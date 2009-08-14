class AddSplatToSigView < ActiveRecord::Migration
  def self.up
    execute %{
      DROP VIEW sig_with_event_count;
      CREATE VIEW sig_with_event_count AS
        SELECT s.*, count(1) AS event_count
        FROM signature s
        JOIN event e ON s.sig_id = e.signature
        GROUP BY e.signature, s.sig_id, s.sig_name, s.sig_class_id, s.sig_priority, s.sig_rev, s.sig_sid, s.sig_gid, s.sig_user_pri;
    }

  end

  def self.down
  end
end
