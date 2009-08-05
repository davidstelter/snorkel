class FasterIpHosts < ActiveRecord::Migration
  def self.up
    execute %{
        DROP VIEW IF EXISTS ip_host;

        CREATE VIEW ip_host AS
        SELECT COALESCE(srctab.addr, dsttab.addr) AS ip_addr,
                coalesce(src_ev_cnt,0)  AS src_ev_cnt, 
                coalesce(dst_ev_cnt,0)  AS dst_ev_cnt,
                coalesce(src_sig_cnt,0) AS src_sig_cnt,
                coalesce(dst_sig_cnt,0) AS dst_sig_cnt,
                act_idx(src_ev_cnt, dst_ev_cnt, src_sig_cnt, dst_sig_cnt)
        FROM (
            SELECT si.ip_src as addr, 
                   count(1) AS src_ev_cnt,
                   count(distinct se.signature) AS src_sig_cnt
            FROM  iphdr si
            JOIN event se 
            ON se.sid=si.sid AND se.cid=si.cid 
            GROUP BY si.ip_src) srctab
        FULL OUTER JOIN (
            SELECT di.ip_dst as addr,
                   count(1) AS dst_ev_cnt,
                   count(distinct de.signature) AS dst_sig_cnt
            FROM iphdr di
            JOIN event de 
            ON de.sid=di.sid AND de.cid=di.cid 
            GROUP BY di.ip_dst) dsttab
        ON srctab.addr = dsttab.addr
        ;
    }

  end

  def self.down
  end
end
