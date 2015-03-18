drop table if exists test1_cost_reverse_t;
drop table if exists test2_cost_reverse_t;
drop table if exists test3_cost_reverse_t;
drop table if exists test10_cost_reverse_t;
drop table if exists test1_cost_reverse_f;
drop table if exists test2_cost_reverse_f;
drop table if exists test3_cost_reverse_f;
drop table if exists test10_cost_reverse_f;
drop table if exists test1_cost_cost_t;
drop table if exists test2_cost_cost_t;
drop table if exists test3_cost_cost_t;
drop table if exists test10_cost_cost_t;
drop table if exists test1_cost_cost_f;
drop table if exists test2_cost_cost_f;
drop table if exists test3_cost_cost_f;
drop table if exists test10_cost_cost_f;
drop table if exists test1_cost_f;
drop table if exists test2_cost_f;
drop table if exists test3_cost_f;
drop table if exists test10_cost_f;
drop table if exists test1_undirected;
drop table if exists test2_undirected;
drop table if exists test3_undirected;
drop table if exists test10_undirected;



---  
create table test1_cost_reverse_t as 
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, 1, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test2_cost_reverse_t as 
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, 2, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test3_cost_reverse_t as 
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, 3, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test10_cost_reverse_t as 
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, 10, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

---  
create table test1_cost_reverse_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, 1, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test2_cost_reverse_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, 2, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test3_cost_reverse_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, 3, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test10_cost_reverse_f as  
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, reverse_cost from edge_table',
                       1, 6, 10, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

---  
create table test1_cost_cost_t as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, 1, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test2_cost_cost_t as 
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, 2, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test3_cost_cost_t as 
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, 3, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test10_cost_cost_t as 
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, 10, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

---  
create table test1_cost_cost_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, 1, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test2_cost_cost_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, 2, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test3_cost_cost_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, 3, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test10_cost_cost_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost, cost as reverse_cost from edge_table',
                       1, 6, 10, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

---
create table test1_cost_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost from edge_table',
                       1, 6, 1, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test2_cost_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost from edge_table',
                       1, 6, 2, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test3_cost_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost from edge_table',
                       1, 6, 3, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test10_cost_f as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, cost from edge_table',
                       1, 6, 10, false) a LEFT JOIN edge_table b ON (a.id3 = b.id);

--- I want undirected graph, 
create table test1_undirected as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost,
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as reverse_cost 
                      from edge_table',
                       1, 6, 1, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);
create table test2_undirected as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost,
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as reverse_cost 
                      from edge_table',
                       1, 6, 2, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test3_undirected as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost,
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as reverse_cost 
                      from edge_table',
                       1, 6, 3, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

create table test10_undirected as
    select seq, id1 as route, id2 as node, id3 as edge, a.cost, the_geom
       from pgr_ksp( 'select id, source, target, 
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as cost,
                      CASE WHEN cost < 0 THEN reverse_cost ELSE cost END as reverse_cost 
                      from edge_table',
                       1, 6, 10, true) a LEFT JOIN edge_table b ON (a.id3 = b.id);

