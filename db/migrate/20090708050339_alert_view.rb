class AlertView < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE VIEW alert AS 
      SELECT e.sid, e.cid, sig_id, sig_name, sig_class_id, sig_priority,
        timestamp, ip_src, ip_dst, ip_proto, ip_flags, tcp.tcp_sport, 
        tcp.tcp_dport, tcp.tcp_flags, udp.udp_sport, udp.udp_dport, 
        icmp.icmp_type, icmp.icmp_code
      FROM signature s, iphdr ip, event e 
      LEFT OUTER JOIN tcphdr tcp   ON e.sid = tcp.sid  AND e.cid = tcp.cid
      LEFT OUTER JOIN udphdr udp   ON e.sid = udp.sid  AND e.cid = udp.cid
      LEFT OUTER JOIN icmphdr icmp ON e.sid = icmp.sid AND e.cid = icmp.cid
      WHERE s.sig_id = e.signature AND e.cid = ip.cid AND e.sid = ip.sid;
    }
  end

  def self.down
    execute %{DROP VIEW alert;}
  end
end
