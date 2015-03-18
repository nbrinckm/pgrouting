#ifndef SRC_KRUSKAL_SRC_KRUSKALGRAPH_H_
#define SRC_KRUSKAL_SRC_KRUSKALGRAPH_H_

#include <string>


extern "C" {
#include "./../../ksp/src/postgres_types.h"
}

#include "Graph.h"

class KruskalGraph : public Graph {
 public:
    ~KruskalGraph();
    explicit KruskalGraph(const Graph&);
    KruskalGraph();
    explicit KruskalGraph(const std::string &);
    void AddData(pgr_edge_t *edges,  UINT total_tuples, bool has_reverse_cost);
    void insertTuple(long edgeId, long source, long target,
                     float cost, float reverse_cost, bool has_reverse_cost);

    void StartLoad();
    void EndLoad();
    void clear();
};
#endif  // SRC_KRUSKA_SRC_KRUSKALGRAPH_H_
