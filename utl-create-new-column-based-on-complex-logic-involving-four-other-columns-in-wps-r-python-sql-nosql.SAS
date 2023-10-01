%let pgm=utl-create-new-column-based-on-complex-logic-involving-four-other-columns-in-wps-r-python-sql-nosql;

Create new column based on complex logic involving four other columns n wps r python sql nosql

subset columns based on value in additional column R

   Solutions

       1 wps datastep
         select;
             when ( T_out = 10.5  or (T_out >= 10.5 and T_out < 12.5) ) T_in = T_10_12;
             when ( T_out >= 12.5 and T_out < 14.5                    ) T_in = T_12_14;
             otherwise                                                  T_in = T_14_16;

       2 wps sql
         case
           when ( T_out = 10.5  | (T_out >= 10.5 & T_out < 12.5)  )  then T_10_12
           when ( T_out >= 12.5 & T_out < 14.5                    )  then T_12_14
           else                                                           T_14_16
         end as                                                           T_in
       3 wps r base

       4 wps r sql
         same as 2

       5 wps python sql
         same as 2

github
https://tinyurl.com/mwsckrmm
https://github.com/rogerjdeangelis/utl-create-new-column-based-on-complex-logic-involving-four-other-columns-in-wps-r-python-sql-nosql

Stackoverflow R
https://tinyurl.com/y6a63kbv
https://stackoverflow.com/questions/77212091/subset-columns-based-on-value-in-additional-column-r
/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/
options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  informat id $2.;
input
   ID T_10_12 T_12_14 T_14_16 T_out;
cards4;
a 11 12.0 13.0 10.5
b 15 16.0 18.0 12.3
c 14 16.0 17.5 14.5
d 14 16.0 16.5 15.1
e 13 14.0 15.0 15.0
f 16 17.0 18.0 13.0
g 15 16.5 17.2 12.0
h 12 13.0 13.0 13.0
i 11 12.0 13.0 13.0
j 12 12.0 14.0 14.0
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                  |                                                      |                              */
/* SD1.HAVE total obs=10            |  PROCESS (SQL is self documenting?)                  |     OUTPUT                   */
/*                                  |                                                      |                              */
/* ID T_10_12 T_12_14 T_14_16 T_OUT |              T_out T_in                              |  T_out  T_in  Logic          */
/*                                  |                                                      |                              */
/*  a    11*    12.0    13.0   10.5 |  when (T_out = 10.5  or                              |  10.5  *11.0 T_out=10.5 then */
/*       ===                        |        (T_out >= 10.5 and T_out < 12.5)) then T_10_12|         ===  T_in=T_10_12    */
/*  b    15     16.0    18.0   12.3 |  when (T_out >= 12.5 and T_out < 14.5)   then T_12_14|  12.3   15.0                 */
/*  c    14     16.0    17.5   14.5 |  else                                         T_14_16|  14.5   17.5                 */
/*  d    14     16.0    16.5   15.1 |  end ad T_in                                         |  15.1   16.5                 */
/*  e    13     14.0    15.0   15.0 |                                                      |  15.0   15.0                 */
/*  f    16     17.0    18.0   13.0 |                                                      |  13.0   17.0                 */
/*  g    15     16.5    17.2   12.0 |                                                      |  12.0   15.0                 */
/*  h    12     13.0    13.0   13.0 |                                                      |  13.0   13.0                 */
/*  i    11     12.0    13.0   13.0 |                                                      |  13.0   12.0                 */
/*  j    12     12.0*   14.0   14.0 |                                                      |  14.0  *12.0 T_out >= 12.5 & */
/*              =====               |                                                      |         ====T_out <  14.5    */
/**************************************************************************************************************************/
/*                            _       _            _
/ | __      ___ __  ___    __| | __ _| |_ __ _ ___| |_ ___ _ __
| | \ \ /\ / / `_ \/ __|  / _` |/ _` | __/ _` / __| __/ _ \ `_ \
| |  \ V  V /| |_) \__ \ | (_| | (_| | || (_| \__ \ ||  __/ |_) |
|_|   \_/\_/ | .__/|___/  \__,_|\__,_|\__\__,_|___/\__\___| .__/
             |_|                                          |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";

data sd1.want;

  set sd1.have;

    select;
        when ( T_out = 10.5  or (T_out >= 10.5 and T_out < 12.5) ) T_in = T_10_12;
        when ( T_out >= 12.5 and T_out < 14.5                    ) T_in = T_12_14;
        otherwise                                                  T_in = T_14_16;
    end;

    keep t_in t_out;

run;quit;
');

proc print data=sd1.want;
run;quit;


/*___                                   _
|___ \  __      ___ __  ___   ___  __ _| |
  __) | \ \ /\ / / `_ \/ __| / __|/ _` | |
 / __/   \ V  V /| |_) \__ \ \__ \ (_| | |
|_____|   \_/\_/ | .__/|___/ |___/\__, |_|
                 |_|                 |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x('
options validvarname=any;
libname sd1 "d:/sd1";
proc sql;
    create
       table sd1.want as
    select
       id
      ,case
         when ( T_out = 10.5  | (T_out >= 10.5 & T_out < 12.5)  )  then T_10_12
         when ( T_out >= 12.5 & T_out < 14.5                    )  then T_12_14
         else                                                           T_14_16
       end as                                                           T_in
    from
       sd1.have
;quit;
');

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* bs    ID    T_in                                                                                                       */
/*                                                                                                                        */
/*  1    a     11.0                                                                                                       */
/*  2    b     15.0                                                                                                       */
/*  3    c     17.5                                                                                                       */
/*  4    d     16.5                                                                                                       */
/*  5    e     15.0                                                                                                       */
/*  6    f     17.0                                                                                                       */
/*  7    g     15.0                                                                                                       */
/*  8    h     13.0                                                                                                       */
/*  9    i     12.0                                                                                                       */
/* 10    j     12.0                                                                                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____                               _
|___ /  __      ___ __  ___   _ __  | |__   __ _ ___  ___
  |_ \  \ \ /\ / / `_ \/ __| | `__| | `_ \ / _` / __|/ _ \
 ___) |  \ V  V /| |_) \__ \ | |    | |_) | (_| \__ \  __/
|____/    \_/\_/ | .__/|___/ |_|    |_.__/ \__,_|___/\___|
                 |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=have;
submit;
library(dplyr);
want <- have %>%
  mutate(T_IN = case_when(
    T_OUT == 10.5                ~ T_10_12,
    T_OUT >= 10.5 & T_OUT < 12.5 ~ T_10_12,
    T_OUT >= 12.5 & T_OUT < 14.5 ~ T_12_14,
    .default =                     T_14_16
  )) %>%
  select(ID, T_IN, T_OUT);
want;
endsubmit;
import data=sd1.want r=want;
run;quit;
');

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                                                                                                        */
/*  The WPS E                                                                                                             */
/*                                                                                                                        */
/*     ID T_IN T_OUT                                                                                                      */
/*  1   a 11.0  10.5                                                                                                      */
/*  2   b 15.0  12.3                                                                                                      */
/*  3   c 17.5  14.5                                                                                                      */
/*  4   d 16.5  15.1                                                                                                      */
/*  5   e 15.0  15.0                                                                                                      */
/*  6   f 17.0  13.0                                                                                                      */
/*  7   g 15.0  12.0                                                                                                      */
/*  8   h 13.0  13.0                                                                                                      */
/*  9   i 12.0  13.0                                                                                                      */
/*  10  j 12.0  14.0                                                                                                      */
/*                                                                                                                        */
/* WPS                                                                                                                    */
/*                                                                                                                        */
/* The WPS System                                                                                                         */
/*                                                                                                                        */
/*    ID T_IN T_OUT                                                                                                       */
/* 1   a 11.0  10.5                                                                                                       */
/* 2   b 15.0  12.3                                                                                                       */
/* 3   c 17.5  14.5                                                                                                       */
/* 4   d 16.5  15.1                                                                                                       */
/* 5   e 15.0  15.0                                                                                                       */
/* 6   f 17.0  13.0                                                                                                       */
/* 7   g 15.0  12.0                                                                                                       */
/* 8   h 13.0  13.0                                                                                                       */
/* 9   i 12.0  13.0                                                                                                       */
/* 10  j 12.0  14.0                                                                                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*  _                                           _
| || |   __      ___ __  ___   _ __   ___  __ _| |
| || |_  \ \ /\ / / `_ \/ __| | `__| / __|/ _` | |
|__   _|  \ V  V /| |_) \__ \ | |    \__ \ (_| | |
   |_|     \_/\_/ | .__/|___/ |_|    |___/\__, |_|
                  |_|                        |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=have;
submit;
library(sqldf);
want <- sqldf("
    select
       id
      ,T_OUT
      ,case
         when ( T_OUT = 10.5  or (T_OUT >= 10.5 and T_OUT < 12.5)  )  then T_10_12
         when ( T_OUT >= 12.5 and T_OUT < 14.5                     )  then T_12_14
         else                                                              T_14_16
       end as                                                              T_IN
    from
       have
");
want;
endsubmit;
import data=sd1.want r=want;
run;quit;
');

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                                                                                                        */
/*  The WPS Proc R                                                                                                        */
/*                                                                                                                        */
/*     ID T_OUT T_IN                                                                                                      */
/*  1   a  10.5 11.0                                                                                                      */
/*  2   b  12.3 15.0                                                                                                      */
/*  3   c  14.5 17.5                                                                                                      */
/*  4   d  15.1 16.5                                                                                                      */
/*  5   e  15.0 15.0                                                                                                      */
/*  6   f  13.0 17.0                                                                                                      */
/*  7   g  12.0 15.0                                                                                                      */
/*  8   h  13.0 13.0                                                                                                      */
/*  9   i  13.0 12.0                                                                                                      */
/*  10  j  14.0 12.0                                                                                                      */
/*                                                                                                                        */
/* WPS Base                                                                                                               */
/*                                                                                                                        */
/* Obs    ID    T_OUT    T_IN                                                                                             */
/*                                                                                                                        */
/*   1    a      10.5    11.0                                                                                             */
/*   2    b      12.3    15.0                                                                                             */
/*   3    c      14.5    17.5                                                                                             */
/*   4    d      15.1    16.5                                                                                             */
/*   5    e      15.0    15.0                                                                                             */
/*   6    f      13.0    17.0                                                                                             */
/*   7    g      12.0    15.0                                                                                             */
/*   8    h      13.0    13.0                                                                                             */
/*   9    i      13.0    12.0                                                                                             */
/*  10    j      14.0    12.0                                                                                             */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                                     _   _
| ___|  __      ___ __  ___   _ __  _   _| |_| |__   ___  _ __
|___ \  \ \ /\ / / `_ \/ __| | `_ \| | | | __| `_ \ / _ \| `_ \
 ___) |  \ V  V /| |_) \__ \ | |_) | |_| | |_| | | | (_) | | | |
|____/    \_/\_/ | .__/|___/ | .__/ \__, |\__|_| |_|\___/|_| |_|
                 |_|         |_|    |___/
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x("
options validvarname=any lrecl=32756;
libname sd1 'd:/sd1';
proc python;
export data=sd1.have python=have;
submit;
print(have);
from os import path;
import pandas as pd;
import numpy as np;
import pandas as pd;
from pandasql import sqldf;
mysql = lambda q: sqldf(q, globals());
from pandasql import PandaSQL;
pdsql = PandaSQL(persist=True);
sqlite3conn = next(pdsql.conn.gen).connection.connection;
sqlite3conn.enable_load_extension(True);
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll');
mysql = lambda q: sqldf(q, globals());
want = pdsql('''
    select
       id
      ,T_OUT
      ,case
         when ( T_OUT = 10.5  or (T_OUT >= 10.5 and T_OUT < 12.5)  )  then T_10_12
         when ( T_OUT >= 12.5 and T_OUT < 14.5                     )  then T_12_14
         else                                                              T_14_16
       end as                                                              T_IN
    from
       have
''');
print(want);
endsubmit;
import data=sd1.want python=want;
run;quit;
");

proc print data=sd1.want;
run;quit;

 /**************************************************************************************************************************/
 /*                                                                                                                        */
 /*  The WPS Python                                                                                                        */
 /*                                                                                                                        */
 /*     ID  T_OUT  T_IN                                                                                                    */
 /*  0  a    10.5  11.0                                                                                                    */
 /*  1  b    12.3  15.0                                                                                                    */
 /*  2  c    14.5  17.5                                                                                                    */
 /*  3  d    15.1  16.5                                                                                                    */
 /*  4  e    15.0  15.0                                                                                                    */
 /*  5  f    13.0  17.0                                                                                                    */
 /*  6  g    12.0  15.0                                                                                                    */
 /*  7  h    13.0  13.0                                                                                                    */
 /*  8  i    13.0  12.0                                                                                                    */
 /*  9  j    14.0  12.0                                                                                                    */
 /*                                                                                                                        */
 /*  WPS BASE                                                                                                              */
 /*                                                                                                                        */
 /* Obs    ID    T_OUT    T_IN                                                                                             */
 /*                                                                                                                        */
 /*   1    a      10.5    11.0                                                                                             */
 /*   2    b      12.3    15.0                                                                                             */
 /*   3    c      14.5    17.5                                                                                             */
 /*   4    d      15.1    16.5                                                                                             */
 /*   5    e      15.0    15.0                                                                                             */
 /*   6    f      13.0    17.0                                                                                             */
 /*   7    g      12.0    15.0                                                                                             */
 /*   8    h      13.0    13.0                                                                                             */
 /*   9    i      13.0    12.0                                                                                             */
 /*  10    j      14.0    12.0                                                                                             */
 /*                                                                                                                        */
 /**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
