class IpHostView < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE VIEW ip_addrs AS
      ( SELECT DISTINCT iphdr.ip_src AS ip_addr
        FROM iphdr
        ORDER BY iphdr.ip_src)
      UNION 
      ( SELECT DISTINCT iphdr.ip_dst AS ip_addr
        FROM iphdr
        ORDER BY iphdr.ip_dst);

      CREATE VIEW ip_host AS
      SELECT ip_addr, events_as_src_cnt(ip_addr), events_as_dst_cnt(ip_addr), events_tot_cnt(ip_addr),
      sigs_as_src_cnt(ip_addr), sigs_as_dst_cnt(ip_addr), sigs_tot_cnt(ip_addr), activity_idx(ip_addr)
      FROM ip_addrs;
    }

  end

  def self.down
    execute %{
      DROP VIEW ip_host;
      DROP VIEW ip_addrs;
    }
  end
end
