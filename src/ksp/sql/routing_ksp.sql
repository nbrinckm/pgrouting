-----------------------------------------------------------------------
-- Function for k shortest_path computation
-- See README for description
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION _pgr_ksp(sql text, source_id bigint, target_id bigint, no_paths integer, has_reverse_cost boolean)
    RETURNS SETOF pgr_costResult3Big
    AS '$libdir/librouting_ksp', 'kshortest_path'
    LANGUAGE c IMMUTABLE STRICT;


-- invert the comments when pgRouting decides for bigints 
CREATE OR REPLACE FUNCTION pgr_ksp(sql text, source_id bigint, target_id bigint, k_paths integer, flag boolean default false)
  --RETURNS SETOF pgr_costresult3Big AS
  RETURNS SETOF pgr_costresult3 AS
  $BODY$  
  DECLARE
  has_reverse boolean;
  sqlquery text;
  BEGIN
      PERFORM _pgr_4parameter_check(sql);
      has_reverse = _pgr_reverse_cost_check(sql);
      if (has_reverse) then
          sqlquery = 'select id, source, target, cost, reverse_cost  from ('||sql||') AS a';
      else
          sqlquery = 'select id,source,target,cost  from ('||sql||') AS a';
      end if;
      if pgr_versionless((pgr_version()).version, '3.0') then -- 2.x

             if (has_reverse != flag)  then -- flag represents has_reverse_cost
                 if (has_reverse) then raise EXCEPTION 'has_reverse_cost set to found but reverse_cost column found';
                 else raise EXCEPTION 'has_reverse_cost set to true but reverse_cost not found';
                 end if;
             end if;
             return query SELECT seq,id1,id2::integer, id3::integer,cost::double precision FROM _pgr_ksp(sqlquery, source_id, target_id, k_paths, has_reverse) where id1 < k_paths;

      else  -- 3.x
             if flag = false then
               return query SELECT seq,id1, id2, id3,cost FROM _pgr_ksp(sqlquery, source_id, target_id, k_paths, has_reverse) where id1 < k_paths;
             else
               return query SELECT seq,id1, id2, id3,cost FROM _pgr_ksp(sqlquery, source_id, target_id, k_paths, has_reverse);
             end if;
      end if;
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

/* invert the comments when pgRouting decides for bigints */
CREATE OR REPLACE FUNCTION pgr_dijkstra(sql text, source_id bigint, target_id bigint)
  --RETURNS SETOF pgr_costresult3Big AS
  RETURNS SETOF pgr_costresult AS
  $BODY$  
  BEGIN
         return query SELECT seq, id2 as id1 , id3 as id2 , cost FROM pgr_ksp($1, $2, $3, 1);
         -- return query SELECT * FROM _pgr_ksp($1, $2, $3, $4, $5);
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

       
