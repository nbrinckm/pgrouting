-- No Problem
select * from  pgr_ksp( 'select id, source , target,   
                      cost,
                      reverse_cost
                      from edge_table',
                      2, 3 , 1, true);
