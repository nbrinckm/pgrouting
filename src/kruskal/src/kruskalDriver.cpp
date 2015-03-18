#include <deque>
#include <sstream>

extern "C" {
#include "./../../ksp/src/postgres_types.h"
#include "./kruskal.h"
}

#include "./../../ksp/src/postgres_connection.h"
#include "./../../ksp/src/signalhandler.h"
#include "./kruskalGraph.h"
#include "./kruskalDriver.h"
#include "./kruskalMinSpanningTree.h"

static  void dpPrint(const KruskalGraph &theGraph,
                     const BasePath &thePath,
                     pgr_path_element3_t *path,
                     int &sequence, int route_id);
static  pgr_path_element3_t * noPathFound(long start_id);

int  doKpaths(pgr_edge_t  * edges, long total_tuples,
                       long  start_vertex, long  end_vertex,
                       int no_paths, bool has_reverse_cost,
                       pgr_path_element3_t **path, int *path_count,
                       char ** err_msg) {
   try {
        REG_SIGINT
        KruskalGraph theGraph = KruskalGraph();
        std::ostringstream log;

        log << "NOTICE: Step 0: Loading the graph\n";
        theGraph.StartLoad();
        theGraph.AddData(edges, total_tuples, has_reverse_cost);
        theGraph.EndLoad();
        (*path_count) = 0;
	THROW_ON_SIGINT

        log << "NOTICE: Step 1: checking Sarting and Ending Vertex\n";
        BaseVertex* startPt = theGraph.find_vertex(start_vertex);
        BaseVertex* sinkPt = theGraph.find_vertex(end_vertex);

        if (startPt == NULL) {
            *err_msg = strdup( "NOTICE: Starting vertex not found on any edge" );
            (*path_count) = 1;
            *path = noPathFound(start_vertex);
            return 0;
        }

        if (sinkPt == NULL) {
            *err_msg = strdup( "NOTICE: Ending vertex not found on any edge" );
            (*path_count) = 1;
            *path = noPathFound(start_vertex);
            return 0;
        }

        if (start_vertex == end_vertex) {
            *err_msg = strdup( "NOTICE: Starting and Ending vertices are the same" );
            (*path_count) = 1;
            *path = noPathFound(start_vertex);
            return 0;
        }
        log << "NOTICE: Step 2: Starting Yen graph \n";

	THROW_ON_SIGINT
        KruskalMinSpanningTree kruskalGraph(theGraph);
	THROW_ON_SIGINT

        log << "NOTICE: Step 3: Getting the paths \n";
        BasePath paths;
        paths = kruskalGraph.Kruskal(start_vertex, end_vertex, true);
	THROW_ON_SIGINT

        if (paths.size() == 0) {
            *err_msg = strdup( "NOTICE: No path found between Starting and Ending vertices" );
            (*path_count) = 1;
            *path = noPathFound(start_vertex);
            return 0;
        }




        log << "NOTICE: Step 4: Calculating the number of tuples \n";
        int count = 0;
        int seq = 0;
        count += paths.size() + 1;   // add final vertex
        log << "NOTICE Count: " << count << "\n";
#if 0
// move around this lines to force a return with an empty path and the logging messages
// cool for debugging
*err_msg = strdup( log.str().c_str());
(*path_count) = 1;
*path = noPathFound(start_vertex);
return 0;
#endif
        // get the space required to store all the paths
        pgr_path_element3_t *kruskel_path;
        kruskel_path = 0;
        kruskel_path = pgr_get_memory3(count, kruskel_path);

        int sequence = 0;
        dpPrint(theGraph, paths, kruskel_path, sequence, 0);

        log << "NOTICE Sequence: " << sequence << "\n";
        if (count != sequence) {
            log << "ERROR: Internal count and real count are different. \nERROR: This should not happen: Please report in GitHub: pgrouting issues.";
            *err_msg = strdup( log.str().c_str());
            return -1;
        }
        #if 1
        *err_msg = strdup("OK");
        #else
        *err_msg = strdup( log.str().c_str());
        #endif
        *path = kruskel_path;
        *path_count = count;
        return EXIT_SUCCESS;
   } catch ( ... ) {
     *err_msg = strdup( "Caught unknown expection!" );
     return -1;
   }
}

static  void dpPrint(const KruskalGraph &theGraph,
                     const BasePath &thePath,
                     pgr_path_element3_t *path,
                     int &sequence, int route_id) {
        // the row data:  seq, route, nodeid, edgeId, cost
        long nodeId, edgeId, lastNodeId;
        double cost;

        for (unsigned int i = 0; i < thePath.size(); i++) {
                edgeId = thePath.getEdgeOriginalID(i);
                nodeId = theGraph.getVertexOriginalID(thePath[i]->getStart());
                cost = thePath[i]->Weight();
                if (i == thePath.size()-1)
                      lastNodeId = theGraph.getVertexOriginalID(thePath[i]->getEnd());

               path[sequence].route_id = route_id;
               path[sequence].vertex_id = nodeId;
               path[sequence].edge_id = edgeId;
               path[sequence].cost = cost;
               sequence++;
                if (i == thePath.size()-1) {
                      path[sequence].route_id = route_id;
                      path[sequence].vertex_id = lastNodeId;
                      path[sequence].edge_id = -1;
                      path[sequence].cost = 0;
                      sequence++;
               }
        }
}

static  pgr_path_element3_t* noPathFound(long start_id) {
        pgr_path_element3_t *no_path;
        no_path = pgr_get_memory3(1, no_path);
        no_path[0].route_id  = 0;
        no_path[0].vertex_id = start_id;
        no_path[0].cost = 0;
        no_path[0].edge_id = -1;
        return no_path;
}

