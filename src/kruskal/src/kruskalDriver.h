#ifndef SRC_KSP_SRC_KSPDRIVER_H_
#define SRC_KSP_SRC_KSPDRIVER_H_

#include <stdarg.h>
#include <stdio.h>
#include "postgres.h"

#include "./../../common/src/postgres_types.h"

#ifdef __cplusplus
extern "C" {
#endif

int  doDijkstra(pgr_edge_t  * edges, long total_tuples,
                      long  start_vertex, long end_vertex,
                      bool has_reverse_cost,
                      pgr_path_element3_t **ksp_path, int *path_count,
                      char ** err_msg);

#ifdef __cplusplus
}
#endif

#endif  // SRC_KSP_SRC_KSPDRIVER_H_
