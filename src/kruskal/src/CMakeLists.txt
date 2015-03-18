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

set(pgr_kruskal_SRCS kruskalMinSpanningTree.cpp kruskalMinSpanningTree.h \
                      kruskal.c kruskal.h \
                      kruskalDriver.cpp kruskalGraph.h \
                      kruskalGraph.cpp kruskalGraph.cpp)

add_library(pgr_kruskal ${LIBRARY_MODE_TARGET} ${pgr_kruskal_SRCS})

if(WIN32)
  if(MSVC)
    set_target_properties(pgr_kruskal PROPERTIES COMPILE_FLAGS "-DHAVE_GETHOSTNAME")
  endif(MSVC)
endif(WIN32)

if(APPLE)
  set_target_properties(pgr_kruskal
    PROPERTIES
    LINK_FLAGS "-bundle_loader ${POSTGRESQL_EXECUTABLE} -bundle")
endif(APPLE)

install(TARGETS pgr_kruskal DESTINATION ${LIBRARY_INSTALL_PATH})
