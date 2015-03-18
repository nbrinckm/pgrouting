-----------------------------------------------------------------------
-- Function for k shortest_path computation
-- See README for description
-----------------------------------------------------------------------
/* original query   (also Yen*.cpp has to be modified)
CREATE OR REPLACE FUNCTION pgr_ksp(sql text, source_id integer, target_id integer, no_paths integer, has_reverse_cost boolean)
    RETURNS SETOF pgr_costResult3
    AS '$libdir/librouting_ksp', 'kshortest_path'
    LANGUAGE c IMMUTABLE STRICT;
*/

CREATE OR REPLACE FUNCTION _pgr_kruskal(sql text, source_id bigint, target_id bigint, no_paths integer, has_reverse_cost boolean)
    RETURNS SETOF pgr_costResult3Big
    AS '$libdir/librouting_kruskal', 'kshortest_path'
    LANGUAGE c IMMUTABLE STRICT;


-- invert the comments when pgRouting decides for bigints 
CREATE OR REPLACE FUNCTION pgr_kruskal(sql text, source_id bigint, target_id bigint, no_paths integer, heap_paths boolean default false)
  --RETURNS SETOF pgr_costresult3Big AS
  RETURNS SETOF pgr_costresult3 AS
  $BODY$  
  DECLARE
  has_reverse boolean;
  BEGIN
      has_reverse =_pgr_parameter_check(sql);
      -- for backwards comptability uncomment latter if keeping the flag:
      /*
      if (has_reverse != has_reverse_cost) 
         if (has_reverse) raise EXCEPTION 'has_reverse_cost set to found but reverse_cost column found';
         else raise EXCEPTION 'has_reverse_cost set to true but reverse_cost not found';
         end if;
      end if;
      */

      if $5 = false then
         return query SELECT seq,id1,id2::integer, id3::integer,cost FROM _pgr_kruskal($1, $2, $3, $4, has_reverse) where id1 < $4;
         -- return query SELECT * FROM _pgr_ksp($1, $2, $3, $4, $5) where id1 < $4;
      else
         return query SELECT seq,id1,id2::integer, id3::integer,cost FROM _pgr_kruskal($1, $2, $3, $4, has_reverse);
         -- return query SELECT * FROM _pgr_ksp($1, $2, $3, $4, $5);
      end if;
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

       
