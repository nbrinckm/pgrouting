#ifndef SRC_insertion_SRC_insertionGRAPH_H_
#define SRC_insertion_SRC_insertionGRAPH_H_

#include <string>

extern "C" {
#include "./../../common/src/postgres_types.h"
}

#include "./../../common/src/GraphElements.h"
#include "./../../common/src/Graph.h"


class insertionGraph : public Graph {
 public:
    ~insertionGraph();
    explicit insertionGraph(const Graph&);
    insertionGraph();
    explicit insertionGraph(const std::string &);
    void AddData(pgr_edge_t *edges,  UINT total_tuples, bool has_reverse_cost);
    void insertTuple(long edgeId, long source, long target,
                     float cost, float reverse_cost, bool has_reverse_cost);

    void StartLoad();
    void EndLoad();
    void clear();
};
#endif  // SRC_insertion_SRC_insertionGRAPH_H_
