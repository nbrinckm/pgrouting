-----------------------------------------------------------------------
-- Function for k shortest_path computation
-- See README for description
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION _pgr_kruskal(sql text, source_id bigint, target_id bigint, has_reverse_cost boolean)
    RETURNS SETOF pgr_costResult3Big
    AS '$libdir/librouting_kruskal', 'dijkstra_path'
    LANGUAGE c IMMUTABLE STRICT;


-- invert the comments when pgRouting decides for bigints 
CREATE OR REPLACE FUNCTION pgr_kruskal(sql text, source_id bigint, target_id bigint)
  --RETURNS SETOF pgr_costresult3Big AS
  RETURNS SETOF pgr_costresult3 AS
  $BODY$  
  DECLARE
  has_reverse boolean;
  BEGIN
      has_reverse =_pgr_parameter_check(sql);

      return query SELECT seq,id1, id2::integer, id3::integer,cost FROM _pgr_kruskal($1, $2, $3, has_reverse);
      -- return query SELECT * FROM _pgr_kruskal($1, $2, $3, has_reverse);
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

       
