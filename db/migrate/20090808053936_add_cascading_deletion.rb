class AddCascadingDeletion < ActiveRecord::Migration
  def self.up
     # ALTER TABLE iphdr   DROP CONSTRAINT IF EXISTS ref_event;
     # ALTER TABLE event   DROP CONSTRAINT IF EXISTS ref_signature;
     # ALTER TABLE tcphdr  DROP CONSTRAINT IF EXISTS ref_iphdr;
     # ALTER TABLE udphdr  DROP CONSTRAINT IF EXISTS ref_iphdr;
     # ALTER TABLE icmphdr DROP CONSTRAINT IF EXISTS ref_iphdr;
     # ALTER TABLE data    DROP CONSTRAINT IF EXISTS ref_iphdr;
     # ALTER TABLE opt     DROP CONSTRAINT IF EXISTS ref_iphdr;


    execute %{
      ALTER TABLE event   ADD CONSTRAINT ref_signature FOREIGN KEY (signature)  REFERENCES signature (sig_id) ON DELETE CASCADE;
      ALTER TABLE iphdr   ADD CONSTRAINT ref_event     FOREIGN KEY (sid, cid)   REFERENCES event (sid, cid)   ON DELETE CASCADE;
      ALTER TABLE tcphdr  ADD CONSTRAINT ref_iphdr     FOREIGN KEY (sid, cid)   REFERENCES iphdr (sid, cid)   ON DELETE CASCADE;
      ALTER TABLE udphdr  ADD CONSTRAINT ref_iphdr     FOREIGN KEY (sid, cid)   REFERENCES iphdr (sid, cid)   ON DELETE CASCADE;
      ALTER TABLE icmphdr ADD CONSTRAINT ref_iphdr     FOREIGN KEY (sid, cid)   REFERENCES iphdr (sid, cid)   ON DELETE CASCADE;
      ALTER TABLE data    ADD CONSTRAINT ref_iphdr     FOREIGN KEY (sid, cid)   REFERENCES iphdr (sid, cid)   ON DELETE CASCADE;
      ALTER TABLE opt     ADD CONSTRAINT ref_iphdr     FOREIGN KEY (sid, cid)   REFERENCES iphdr (sid, cid)   ON DELETE CASCADE;

    }

  end

  def self.down
  end
end
