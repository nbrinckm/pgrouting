-----------------------------------------------------------------------
-- Function _pgr_4parameter_check

-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION _pgr_4parameter_check(sql text)
  RETURNS boolean AS
  $BODY$

  DECLARE
  rec record;
  rec1 record;

  BEGIN
    -- checking query is executable
    BEGIN
      execute 'select * from ('||sql||' limit 1) AS a ';
      EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Could not excecute query please verify sintax of: '
              USING HINT = sql;
    END;

    -- checking the fixed columns and data types of the integers
    BEGIN
      execute 'select id,source,target,cost  from ('||sql||' limit 1) AS a ' into rec;
      EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'An expected column was not found in the query'
              USING HINT = 'Please veryfy the column names: id, source, target, cost';
    END;

    BEGIN
    execute 'select pg_typeof(id)::text as id_type, '
            ||' pg_typeof(source)::text as source_type, '
            || 'pg_typeof(target)::text as target_type, '
            || 'pg_typeof(cost)::text as cost_type'
            || ' from ('||sql||' limit 1) AS a ' into rec;

    if (pgr_versionless((pgr_version()).version, '3.0')) then -- for 2.x
      --  only integer can be accepted for edgeId, source, traget columns
      if not (rec.id_type in ('integer'::text)) then
        RAISE EXCEPTION 'Support for id only of type: integer';
      end if;
      if not (rec.source_type in ('integer'::text)) then
        RAISE EXCEPTION 'Support for source only of type: integer';
      end if;
      if not (rec.target_type in ('integer'::text)) then
        RAISE EXCEPTION 'Support for target only of type: integer';
      end if;
      -- only  double precision is accepted by cost
      if not (rec.cost_type in ('double precision'::text)) then
        RAISE EXCEPTION 'Support for Cost: double precision';
      end if;

    else -- for 3.x and tests
        -- big, integer and small int can be accepted for edgeId, source, traget columns
        if not (rec.id_type in ('bigint'::text, 'integer'::text, 'smallint'::text)) then
          RAISE EXCEPTION 'Support for id only of integer types';
        end if;
        if not (rec.source_type in ('bigint'::text, 'integer'::text, 'smallint'::text)) then
          RAISE EXCEPTION 'Support for source only of integer types';
        end if;
        if not (rec.target_type in ('bigint'::text, 'integer'::text, 'smallint'::text)) then
          RAISE EXCEPTION 'Support for target only of integer types';
        end if;
        -- cost besides the integer types can accept real and double precision
        if not (rec.cost_type in ('double precision'::text, 'real'::text, 'numeric'::text,
                                  'bigint'::text, 'integer'::text, 'smallint'::text)) then
          RAISE EXCEPTION 'Support for Cost: real, double precision and integer types';
        end if;
    end if;
    END;
    return true;
  END
  $BODY$
  LANGUAGE plpgsql STABLE
  COST 1;


-- if the query can not be executed returns false
CREATE OR REPLACE FUNCTION _pgr_reverse_cost_check(sql text)
  RETURNS bool AS
  $BODY$

  DECLARE
  rec record;
  rec1 record;
  has_reverse boolean;

  BEGIN 
    -- checking the data types of the optional reverse_cost
    has_reverse = false;
    BEGIN
      execute 'select reverse_cost from ('||sql||' limit 1) AS a ' into rec1;
      has_reverse := true;
      EXCEPTION
         WHEN OTHERS THEN
            has_reverse = false;
      END;
      if (has_reverse) then
        execute 'select pg_typeof(reverse_cost)::text as reverse_type from ('||sql||' limit 1) AS a ' into rec1;
        if (pgr_versionless((pgr_version()).version, '3.0')) then -- for 2.x
          if (rec1.reverse_type != 'double precision') then
            raise EXCEPTION 'Reverse_cost is not double precision';
          end if;
        else
          if not (rec1.reverse_type in ('double precision'::text, 'real'::text, 'numeric'::text,
                                'bigint'::text, 'integer'::text, 'smallint'::text)) then
            RAISE EXCEPTION 'Support for reverse_cost: double precision';
          end if;
        end if;
      end if;

    return has_reverse;
  END
  $BODY$
  LANGUAGE plpgsql STABLE
  COST 1;
