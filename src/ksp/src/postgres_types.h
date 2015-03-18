/*
 * KShortest path algorithm for PostgreSQL
 *
 * Copyright (c) 2012 Dave Potts
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 */
 
#ifndef _POSTGRES_TYPES_H
#define _POSTGRES_TYPES_H

#define TUPLIMIT 1000

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct {
    int64_t id;
    int64_t source;
    int64_t target;
    float8 cost;
    float8 reverse_cost;
} pgr_edge_t;

typedef struct {
    int route_id;
    int64_t vertex_id;
    int64_t edge_id;
    float8 cost;
} pgr_path_element3_t;

typedef struct {
    int64_t vertex_id;
    int64_t edge_id;
    float8 cost;
} pgr_path_element_t;


#ifdef __cplusplus
}
#endif

#endif  // _POSTGRES_TYPES_H
