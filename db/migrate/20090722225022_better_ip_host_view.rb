class BetterIpHostView < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE FUNCTION norz(bigint)
      RETURNS bigint AS $$
        SELECT COALESCE($1, 0)
      $$ LANGUAGE SQL;

      CREATE FUNCTION act_idx(bigint, bigint, bigint, bigint)
      RETURNS bigint AS $$
        SELECT (norz($1) + norz($2)) * (norz($3) + norz($4))
      $$ LANGUAGE SQL;
      
      CREATE VIEW ip_host AS
      SELECT COALESCE(srctab.addr, dsttab.addr) AS ip_addr,
        norz(src_ev_cnt) AS src_ev_cnt, norz(dst_ev_cnt) AS dst_ev_cnt,
        norz(src_sig_cnt) AS src_sig_cnt, norz(dst_sig_cnt) AS dst_sig_cnt,
       act_idx(src_ev_cnt, dst_ev_cnt, src_sig_cnt, dst_sig_cnt) FROM 
        (SELECT sa.addr, count(si.*) AS src_ev_cnt, count(distinct se.signature) AS src_sig_cnt
          FROM
          (SELECT ip_src AS addr FROM iphdr GROUP BY ip_src) sa
          JOIN iphdr si ON si.ip_src = sa.addr JOIN event se ON se.sid=si.sid AND se.cid=si.cid 
          GROUP BY addr) srctab
      FULL OUTER JOIN
        (SELECT da.addr, count(di.*) AS dst_ev_cnt, count(distinct de.signature) AS dst_sig_cnt
          FROM
          (SELECT ip_dst AS addr FROM iphdr GROUP BY ip_dst) da
          JOIN iphdr di ON di.ip_dst = da.addr JOIN event de ON de.sid=di.sid AND de.cid=di.cid 
          GROUP BY addr) dsttab
      ON srctab.addr = dsttab.addr
      ;

    }
  end

  def self.down
    execute %{

      DROP VIEW ip_host;
      DROP FUNCTION act_idx(bigint, bigint, bigint, bigint);
      DROP FUNCTION norz(bigint);
    }
  end
end
