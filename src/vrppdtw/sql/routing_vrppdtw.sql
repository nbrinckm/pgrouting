-----------------------------------------------------------------------
-- Core function for vrp with sigle depot computation
-- See README for description
-----------------------------------------------------------------------
--
--
create or replace function pgr_gsoc_vrppdtw(
                sql text,
                vehicle_num integer,
                capacity integer,
                OUT seq integer,
                OUT rid integer,
                OUT nid integer,
                OUT cost integer
                )
returns setof record as
'$libdir/librouting-2.1', 'vrppdtw'
LANGUAGE c VOLATILE STRICT;


