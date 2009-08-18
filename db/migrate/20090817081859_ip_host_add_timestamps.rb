class IpHostAddTimestamps < ActiveRecord::Migration
  def self.up
    add_column :ip_host_cache, :first_as_dst, 'timestamp with time zone'
    add_column :ip_host_cache, :last_as_dst,  'timestamp with time zone'
    add_column :ip_host_cache, :first_as_src, 'timestamp with time zone'
    add_column :ip_host_cache, :last_as_src,  'timestamp with time zone'

    execute %{
      DROP VIEW IF EXISTS ip_host;

      CREATE VIEW ip_host AS
        SELECT COALESCE(srctab.addr, dsttab.addr) AS ip_addr, 
          COALESCE(srctab.src_ev_cnt,  0::bigint) AS src_ev_cnt, 
          COALESCE(dsttab.dst_ev_cnt,  0::bigint) AS dst_ev_cnt,
          COALESCE(srctab.src_sig_cnt, 0::bigint) AS src_sig_cnt,
          COALESCE(dsttab.dst_sig_cnt, 0::bigint) AS dst_sig_cnt,
          act_idx(srctab.src_ev_cnt, dsttab.dst_ev_cnt, srctab.src_sig_cnt, dsttab.dst_sig_cnt) AS act_idx,
          first_as_dst, last_as_dst, first_as_src, last_as_src
        FROM ( 
     		  SELECT si.ip_src AS addr, 
     		         count(1) AS src_ev_cnt, 
     		         count(DISTINCT se.signature) AS src_sig_cnt,
     		         min(se.timestamp) as first_as_src,
     		         max(se.timestamp) as last_as_src
     		  FROM iphdr si
     		  JOIN event se ON se.sid = si.sid AND se.cid = si.cid
     		  GROUP BY si.ip_src
     		  ) srctab
        FULL JOIN (
     		  SELECT di.ip_dst AS addr, count(1) AS dst_ev_cnt,
     		         count(DISTINCT de.signature) AS dst_sig_cnt,
     		         min(de.timestamp) as first_as_dst,
     		         max(de.timestamp) as last_as_dst
     		  FROM iphdr di
     		  JOIN event de ON de.sid = di.sid AND de.cid = di.cid
     		  GROUP BY di.ip_dst
     		) dsttab 
     	ON srctab.addr = dsttab.addr
      ; 

      CREATE OR REPLACE FUNCTION refresh_ip_host_cache()
        RETURNS timestamp with time zone AS
      $$
              DELETE FROM ip_host_cache;
              DELETE FROM cache_update;
      
              INSERT INTO ip_host_cache (ip_addr, src_ev_cnt, dst_ev_cnt, src_sig_cnt, dst_sig_cnt, act_idx,
                first_as_dst, last_as_dst, first_as_src, last_as_src)
              SELECT ip_addr, src_ev_cnt, dst_ev_cnt, src_sig_cnt, dst_sig_cnt, act_idx,
                first_as_dst, last_as_dst, first_as_src, last_as_src FROM ip_host;
      
              INSERT INTO cache_update (SELECT CURRENT_TIMESTAMP);
              SELECT last_updated from cache_update AS result LIMIT 1;
            $$
        LANGUAGE 'sql' VOLATILE;
      }
  end

  def self.down
  end
end
