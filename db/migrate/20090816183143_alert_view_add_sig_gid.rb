class AlertViewAddSigGid < ActiveRecord::Migration
  def self.up
    execute %{
      DROP VIEW IF EXISTS alert;

      CREATE VIEW alert AS
      SELECT e.sid, e.cid, 
             s.sig_id, s.sig_sid, s.sig_gid, s.sig_name, s.sig_class_id, s.sig_priority, 
             e."timestamp", 
             ip.ip_src, ip.ip_dst, ip.ip_proto, ip.ip_flags, 
             tcp.tcp_sport, tcp.tcp_dport, tcp.tcp_flags, 
             udp.udp_sport, udp.udp_dport, 
             icmp.icmp_type, icmp.icmp_code
      FROM signature s, iphdr ip, event e
      LEFT JOIN tcphdr tcp ON e.sid = tcp.sid AND e.cid = tcp.cid
      LEFT JOIN udphdr udp ON e.sid = udp.sid AND e.cid = udp.cid
      LEFT JOIN icmphdr icmp ON e.sid = icmp.sid AND e.cid = icmp.cid
      WHERE s.sig_id = e.signature AND e.cid = ip.cid AND e.sid = ip.sid;
    }
  end

  def self.down
  end
end
