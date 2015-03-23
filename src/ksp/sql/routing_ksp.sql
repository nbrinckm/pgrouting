--
-- Copyright (c) 2015 Celia Virginia Vergara Castillo
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

CREATE OR REPLACE FUNCTION _pgr_ksp(sql text, source_id bigint, target_id bigint, no_paths integer, has_reverse_cost boolean)
    RETURNS SETOF pgr_costResult3Big
    AS '$libdir/librouting_ksp', 'kshortest_path'
    LANGUAGE c IMMUTABLE STRICT;


-- invert the comments when pgRouting decides for bigints 
CREATE OR REPLACE FUNCTION pgr_ksp(sql text, source_id bigint, target_id bigint, k_paths integer, has_rcost boolean, heap_paths boolean default false)
  --RETURNS SETOF pgr_costresult3Big AS
  RETURNS SETOF pgr_costresult3 AS
  $BODY$  
  DECLARE
  has_reverse boolean;
  sqlquery text;
  v3heap_paths boolean;
  BEGIN
      has_reverse = _pgr_parameter_check(sql,'ksp');
      if (has_reverse) then
          sqlquery = 'select id, source, target, cost, reverse_cost  from ('||sql||') AS a';
      else
          sqlquery = 'select id,source,target,cost  from ('||sql||') AS a';
      end if;
      if pgr_versionless((pgr_version()).version, '3.0') then -- 2.x
             if (has_reverse != has_rcost)  then 
                 if (has_reverse) then raise EXCEPTION 'has_reverse_cost set to false but reverse_cost column found';
                 else raise EXCEPTION 'has_reverse_cost set to true but reverse_cost not found';
                 end if;
             end if;

             if heap_paths = false then
               return query SELECT seq,id1,id2::integer, id3::integer,cost::double precision FROM _pgr_ksp(sqlquery, source_id, target_id, k_paths, has_reverse) where id1 < k_paths;
             else
               return query SELECT seq,id1,id2::integer, id3::integer,cost::double precision FROM _pgr_ksp(sqlquery, source_id, target_id, k_paths, has_reverse);
             end if;

      else  -- 3.x
             v3heap_paths = has_rcost; 
             if v3heap_paths = false then
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

CREATE OR REPLACE FUNCTION pgr_ksp(sql text, source_id bigint, target_id bigint, k_paths integer)
  --RETURNS SETOF pgr_costresult3Big AS
  RETURNS SETOF pgr_costresult3 AS
  $BODY$
  DECLARE
  has_reverse boolean;
  BEGIN
      has_reverse = _pgr_reverse_cost_check(sql);
      return query SELECT seq,id1, id2, id3,cost FROM pgr_ksp(sql, source_id, target_id, k_paths, has_reverse);
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
