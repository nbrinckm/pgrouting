set(LIBRARY_OUTPUT_PATH ../../../lib/)

include_directories(${PGROUTING_INCLUDE_DIRECTORIES} ${POSTGRESQL_INCLUDE_DIR})
if(WIN32)
    include_directories(${POSTGRESQL_INCLUDE_DIR}/port/win32)
endif(WIN32)

if(APPLE)
    set(LIBRARY_MODE_TARGET "MODULE")
else(APPLE)
    set(LIBRARY_MODE_TARGET "SHARED")
endif(APPLE)

set(routing_kruskal_SRCS DijkstraShortestPathAlg.cpp DijkstraShortestPathAlg.h
                     YenTopKShortestPathsAlg.cpp YenTopKShortestPathsAlg.h
                     kruskal.c kruskal.h
                     kruskalDriver.cpp
                     insertionGraph.h insertionGraph.cpp
                     ./../../common/src/BaseVertex.h
                     ./../../common/src/BaseEdge.h
                     ./../../common/src/BasePath.h
                     ./../../common/src/GraphElements.h
                     ./../../common/src/Graph.h
                     ./../../common/src/Graph.cpp
                     ./../../common/src/vrp_assert.cpp
                     ./../../common/src/vrp_assert.h
                     ./../../common/src/signalhandler.cpp
                     ./../../common/src/signalhandler.h
                     ./../../common/src/postgres_types.h
                     ./../../common/src/postgres_connection.c
                     ./../../common/src/postgres_connection.h )


add_library(routing_kruskal ${LIBRARY_MODE_TARGET} ${routing_kruskal_SRCS})

if(WIN32)
  if(MSVC)
    set_target_properties(routing_kruskal PROPERTIES COMPILE_FLAGS "-DHAVE_GETHOSTNAME")
  endif(MSVC)
endif(WIN32)

if(APPLE)
  set_target_properties(routing_kruskal
    PROPERTIES
    LINK_FLAGS "-bundle_loader ${POSTGRESQL_EXECUTABLE} -bundle")
endif(APPLE)

install(TARGETS routing_kruskal DESTINATION ${LIBRARY_INSTALL_PATH})
