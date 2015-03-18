/*
 * kShortest path algorithm for PostgreSQL
 *
 * Copyright (c) 2011 Dave Potts
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

#include "postgres.h"
#include "executor/spi.h"

#include "postgres_types.h"
#include "postgres_connection.h"

char *
pgr_text2char(text *in)
{
  char *out = palloc(VARSIZE(in));

  memcpy(out, VARDATA(in), VARSIZE(in) - VARHDRSZ);
  out[VARSIZE(in) - VARHDRSZ] = '\0';
  return out;
}

int pgr_finish(int code, int ret)
{
  code = SPI_finish();
  if (code  != SPI_OK_FINISH )
  {
    elog(ERROR,"couldn't disconnect from SPI");
    return -1 ;
  }			
  return ret;
}
			  
int pgr_fetch_edge_columns(SPITupleTable *tuptable, pgr_edge_t *edge_columns, 
                   bool has_reverse_cost)
{
  edge_columns->id = SPI_fnumber(SPI_tuptable->tupdesc, "id");
  edge_columns->source = SPI_fnumber(SPI_tuptable->tupdesc, "source");
  edge_columns->target = SPI_fnumber(SPI_tuptable->tupdesc, "target");
  edge_columns->cost = SPI_fnumber(SPI_tuptable->tupdesc, "cost");

  DBG("columns: id %ld source %ld target %ld cost %f", 
      edge_columns->id, edge_columns->source, 
      edge_columns->target, edge_columns->cost);

  if (has_reverse_cost) {
    edge_columns->reverse_cost = SPI_fnumber(SPI_tuptable->tupdesc, 
                                               "reverse_cost");

    DBG("columns: reverse_cost cost %f", edge_columns->reverse_cost);
  }
    
  return 0;
}


void
pgr_fetch_edge(HeapTuple *tuple, TupleDesc *tupdesc, 
           pgr_edge_t *edge_columns, pgr_edge_t *target_edge)
{
  Datum binval;
  bool isnull;

  binval = SPI_getbinval(*tuple, *tupdesc, edge_columns->id, &isnull);
  if (isnull)
    elog(ERROR, "id contains a null value");
  target_edge->id = DatumGetInt64(binval);

  binval = SPI_getbinval(*tuple, *tupdesc, edge_columns->source, &isnull);
  if (isnull)
    elog(ERROR, "source contains a null value");
  target_edge->source = DatumGetInt64(binval);

  binval = SPI_getbinval(*tuple, *tupdesc, edge_columns->target, &isnull);
  if (isnull)
    elog(ERROR, "target contains a null value");
  target_edge->target = DatumGetInt64(binval);

  binval = SPI_getbinval(*tuple, *tupdesc, edge_columns->cost, &isnull);
  if (isnull)
    elog(ERROR, "cost contains a null value");
  target_edge->cost = DatumGetFloat8(binval);

  if (edge_columns->reverse_cost != -1) 
    {
      binval = SPI_getbinval(*tuple, *tupdesc, edge_columns->reverse_cost, 
                             &isnull);
      if (isnull)
        elog(ERROR, "reverse_cost contains a null value");
      target_edge->reverse_cost =  DatumGetFloat8(binval);
    }
}



int pgr_retrieve_data_from_sql(char *sql, pgr_edge_t *edges, long *totalTuples, bool has_reverse_cost) {

  int SPIcode;
  void *SPIplan;
  Portal SPIportal;
  bool moredata = TRUE;
  int ntuples;
  long total_tuples = 0;

#ifndef _MSC_VER
  pgr_edge_t edge_columns = {.id= -1, .source= -1, .target= -1, 
                                 .cost= -1, .reverse_cost= -1};
#else // _MSC_VER
  pgr_edge_t edge_columns = {-1, -1, -1, -1, -1};
#endif // _MSC_VER

  int ret = -1;

  DBG("Retriving Data  %s\n",sql);
        
  SPIcode = SPI_connect();
  if (SPIcode  != SPI_OK_CONNECT)
    {
      elog(ERROR, "kshortest_path: couldn't open a connection to SPI");
      return -1;
    }

  SPIplan = SPI_prepare(sql, 0, NULL);
  if (SPIplan  == NULL)
    {
      elog(ERROR, "kshortest_path: couldn't create query plan via SPI");
      return -1;
    }

  if ((SPIportal = SPI_cursor_open(NULL, SPIplan, NULL, NULL, true)) == NULL) 
    {
      elog(ERROR, "shortest_path: SPI_cursor_open('%s') returns NULL", sql);
      return -1;
    }

  while (moredata == TRUE)
    {
      SPI_cursor_fetch(SPIportal, TRUE, TUPLIMIT);

      if (edge_columns.id == -1) 
        {
          if (pgr_fetch_edge_columns(SPI_tuptable, &edge_columns, 
                                 has_reverse_cost) == -1)
	    return pgr_finish(SPIcode, ret);
        }
      ntuples = SPI_processed;
      total_tuples += ntuples;
      if (!edges)
        edges = (pgr_edge_t *)palloc(total_tuples * sizeof(pgr_edge_t));
      else
        edges = (pgr_edge_t *)repalloc(edges, total_tuples * sizeof(pgr_edge_t));

      if (edges == NULL) 
        {
          elog(ERROR, "Out of memory");
	    return pgr_finish(SPIcode, ret);	  
        }

      if (ntuples > 0) 
        {
          int t;
          SPITupleTable *tuptable = SPI_tuptable;
          TupleDesc tupdesc = SPI_tuptable->tupdesc;
                
          for (t = 0; t < ntuples; t++) 
            {
              HeapTuple tuple = tuptable->vals[t];
              pgr_fetch_edge(&tuple, &tupdesc, &edge_columns, 
                         &edges[total_tuples - ntuples + t]);
            }
          SPI_freetuptable(tuptable);
        } 
      else 
        {
          moredata = FALSE;
        }
    }

      
  DBG("Total %ld tuples in query", total_tuples);
  return SPIcode;
}


pgr_path_element3_t* pgr_get_memory3(int size, pgr_path_element3_t *path){
	if(path ==0  ){
		path=malloc(size * sizeof(pgr_path_element3_t));
	} else {
		path=realloc(path,size * sizeof(pgr_path_element3_t));
	}
	return path;
}
