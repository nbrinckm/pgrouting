#include <string>
extern "C" {
#include "./../../ksp/src/postgres_types.h"
}
#include "./kruskalGraph.h"

KruskalGraph::KruskalGraph(void) {}
KruskalGraph::~KruskalGraph(void) {}
KruskalGraph::KruskalGraph(const Graph& g):Graph(g) {}
KruskalGraph::KruskalGraph(const std::string & f):Graph(f) {}
void KruskalGraph::StartLoad() { clear();}
void KruskalGraph::EndLoad(void) {}
void KruskalGraph::clear(void) { Graph::clear();}

void KruskalGraph::AddData(pgr_edge_t  *edges,  UINT total_tuples, bool has_reverse_cost) {
       for (UINT i = 0; i < total_tuples; i++) {
            insertTuple(edges[i].id, edges[i].source, edges[i].target,
            edges[i].cost, edges[i].reverse_cost, has_reverse_cost);
       }
}

void KruskalGraph::insertTuple(long id, long source, long target,
                float cost, float reverse_cost, bool has_reverse_cost) {
    if (cost >= 0 || (reverse_cost>= 0 && has_reverse_cost)) {
       BaseVertex* sourcePos = getNewVertex(source);
       BaseVertex* targetPos = getNewVertex(target);
       if (cost >= 0) {
           insertNewEdge(id, sourcePos->ID(), targetPos->ID(), cost);
       }
       if (reverse_cost>= 0 && has_reverse_cost) {
           insertNewEdge(id, targetPos->ID(), sourcePos->ID(), reverse_cost);
       }
    }
}



