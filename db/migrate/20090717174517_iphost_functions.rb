class IphostFunctions < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE FUNCTION events_as_src_cnt(bigint) 
      RETURNS bigint AS $$
        SELECT count(*) FROM iphdr 
        WHERE ip_src = $1
      $$ LANGUAGE SQL;

      CREATE FUNCTION events_as_dst_cnt(bigint) 
      RETURNS bigint AS $$
        SELECT count(*) FROM iphdr 
        WHERE ip_dst = $1
      $$ LANGUAGE SQL;
      
      CREATE FUNCTION events_tot_cnt(bigint)
      RETURNS bigint AS $$
        SELECT events_as_src($1) + events_as_dst($1)
      $$ LANGUAGE SQL;

      CREATE FUNCTION sigs_as_src_cnt(bigint)
      RETURNS bigint AS $$
        SELECT count(distinct sig_id) 
        FROM alert
        WHERE ip_src = $1
      $$ LANGUAGE SQL;

      CREATE FUNCTION sigs_as_dst_cnt(bigint)
      RETURNS bigint AS $$
        SELECT count(distinct sig_id) 
        FROM alert
        WHERE ip_dst = $1
      $$ LANGUAGE SQL;

      CREATE FUNCTION sigs_tot_cnt(bigint)
      RETURNS bigint AS $$
        SELECT sigs_as_src($1) + sigs_as_dst($1)
      $$ LANGUAGE SQL;

      CREATE FUNCTION activity_idx(bigint)
      RETURNS bigint AS $$
        select sigs_tot($1) * events_tot($1)
      $$ LANGUAGE SQL;

    }

  end

  def self.down
    execute = %{
      DROP FUNCTION events_as_src_cnt(bigint);
      DROP FUNCTION events_as_dst_cnt(bigint);
      DROP FUNCTION events_tot_cnt(bigint);
      DROP FUNCTION sigs_as_src_cnt(bigint);
      DROP FUNCTION sigs_as_dst_cnt(bigint);
      DROP FUNCTION sigs_tot_cnt(bigint);
      DROP FUNCTION activity_idx(bigint);
    }
  end
end
