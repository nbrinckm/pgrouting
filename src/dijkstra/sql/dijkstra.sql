--
-- Copyright (c) 2005 Sylvain Pasche,
--               2006-2007 Anton A. Patrushev, Orkney, Inc.
--               2015 Celia Virginia Vergara Castillo.
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
--


-----------------------------------------------------------------------
-- Core function for Dijkstra shortest_path computation
-----------------------------------------------------------------------
--  the original function is not ready for 3.X
CREATE OR REPLACE FUNCTION _pgr_dijkstra(sql text, source_id integer, 
        target_id integer, directed boolean, has_reverse_cost boolean)
        RETURNS SETOF pgr_costResult
        AS '$libdir/librouting', 'shortest_path'
        LANGUAGE c IMMUTABLE STRICT;



CREATE OR REPLACE FUNCTION pgr_dijkstra(sql text, source_id integer, 
        target_id integer, directed boolean, flag boolean)
-- CREATE OR REPLACE FUNCTION pgr_dijkstra(sql text, source_id bigint, target_id bigint, flag boolean default false)
  --RETURNS SETOF pgr_costresultBig AS
  RETURNS SETOF pgr_costresult AS
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
          sqlquery = 'select id, source ,target, cost  from ('||sql||') AS a';
      end if;
      if pgr_versionless((pgr_version()).version, '3.0') then -- 2.x

             if (has_reverse != flag)  then -- flag represents has_reverse_cost
                 if (has_reverse) then raise EXCEPTION 'has_reverse_cost set to false but reverse_cost column found';
                 else raise EXCEPTION 'has_reverse_cost set to true but reverse_cost not found';
                 end if;
             end if;
             return query SELECT seq, id1::integer, id2::integer, cost::double precision FROM _pgr_dijkstra(sqlquery, source_id, target_id, directed, has_reverse);

      else  -- 3.x
               return query SELECT seq,id1, id2, cost FROM _pgr_dijkstra(sqlquery, source_id, target_id, directed, has_reverse);
      end if;
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

--  equivalent dijkstra to ksp
CREATE OR REPLACE FUNCTION pgr_dijkstra(sql text, source_id bigint, target_id bigint)
  --RETURNS SETOF pgr_costresultBig AS
  RETURNS SETOF pgr_costresult AS
  $BODY$
  BEGIN
      if pgr_versionless((pgr_version()).version, '3.0') then -- 2.x
        return query SELECT seq, id2 as id1 , id3 as id2 , cost FROM pgr_ksp(sql, source_id::integer, target_id::integer, 1);
      else
        return query SELECT seq, id2 as id1 , id3 as id2 , cost FROM pgr_ksp(sql, source_id, target_id, 1);
      end if;
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
