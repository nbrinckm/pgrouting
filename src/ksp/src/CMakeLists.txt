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

set(routing_ksp_SRCS 
                     ./../../kruskal/src/DijkstraShortestPathAlg.cpp ./../../kruskal/src/DijkstraShortestPathAlg.h
                     YenTopKShortestPathsAlg.cpp YenTopKShortestPathsAlg.h
                     ksp.c ksp.h
                     KSPDriver.cpp
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


add_library(routing_ksp ${LIBRARY_MODE_TARGET} ${routing_ksp_SRCS})

if(WIN32)
  if(MSVC)
    set_target_properties(routing_ksp PROPERTIES COMPILE_FLAGS "-DHAVE_GETHOSTNAME")
  endif(MSVC)
endif(WIN32)

if(APPLE)
  set_target_properties(routing_ksp
    PROPERTIES
    LINK_FLAGS "-bundle_loader ${POSTGRESQL_EXECUTABLE} -bundle")
endif(APPLE)

install(TARGETS routing_ksp DESTINATION ${LIBRARY_INSTALL_PATH})
