drop table if exists dij_cost_reverse_t_t;
drop table if exists dij_cost_reverse_t_f;
drop table if exists dij_cost_reverse_f_t;
drop table if exists dij_cost_reverse_f_f;


drop table if exists dij_cost_cost_t_t;
drop table if exists dij_cost_cost_t_f;
drop table if exists dij_cost_cost_f_t;
drop table if exists dij_cost_cost_f_f;

-- drop table if exists dij_cost_t_t;
drop table if exists dij_cost_t_f;
-- drop table if exists dij_cost_f_t;
drop table if exists dij_cost_f_f;

drop table if exists dij_undirected_t_t;
drop table if exists dij_undirected_t_f;
drop table if exists dij_v2_undirected_t_f;
drop table if exists dij_undirected_f_t;
drop table if exists dij_undirected_f_f;
drop table if exists dij_v2_undirected_f_f;


---  
create table dij_cost_reverse_t_t as 
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, true, true) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_cost_reverse_t_f as 
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, true, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_cost_reverse_f_t as 
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, false, true) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_cost_reverse_f_f as 
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, false, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);


---  
create table dij_cost_cost_t_t as 
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, true, true) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_cost_cost_t_f as 
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, true, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_cost_cost_f_t as 
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, false, true) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_cost_cost_f_f as 
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, false, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);


--- 
create table dij_cost_t_t as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost from edge_table',
                       1, 6, true, true) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_cost_t_f as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost from edge_table',
                       1, 6, true, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_cost_f_t as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost from edge_table',
                       1, 6, false, true) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_cost_f_f as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, cost from edge_table',
                       1, 6, false, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);
----

--- I want undirected graph, 
create table dij_undirected_t_t as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost,
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as reverse_cost 
                      from edge_table',
                       1, 6,  true, true) a LEFT JOIN edge_table b ON (a.id2 = b.id);


---
create table dij_undirected_t_f as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost
                      from edge_table',
                       1, 6,  true, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_v2_undirected_t_f as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost
                      from edge_table',
                       1, 6,  true, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);
---
create table dij_undirected_f_t as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost,
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as reverse_cost 
                      from edge_table',
                       1, 6,  false, true) a LEFT JOIN edge_table b ON (a.id2 = b.id);

---
create table dij_undirected_f_f as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost,
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as reverse_cost 
                      from edge_table',
                       1, 6,  false, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_v2_undirected_f_f as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost
                      from edge_table',
                       1, 6,  false, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);
--- Lets see if these work:
create table dij_32_undirected_f_f as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost
                      from edge_table',
                      2,3,  false, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_32_cost_f_f as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, 
                      cost
                      from edge_table',
                      2,3,  false, false) a LEFT JOIN edge_table b ON (a.id2 = b.id);

create table dij_32_cost_f_t as
    select seq, id1 as node, id2 as edge, a.cost, the_geom
       from pgr_dijkstra( 'select id, source, target, 
                      cost,
                      reverse_cost
                      from edge_table',
                      2,3,  false, true) a LEFT JOIN edge_table b ON (a.id2 = b.id);






