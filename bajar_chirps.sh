#!/bin/bash
 # This is a comment 

echo "Bajando los archivos CHIRPS solicitados, por favor espere..." 

#ftp://chg-ftpout.geog.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/global_daily/netcdf/p05/chirps-v2.0.1981.days_p05.nc

direccion=ftp://chg-ftpout.geog.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/global_daily/netcdf/p05/

#string=chirps-v2.0.1981.days_p05.nc
string1="chirps-v2.0."
string2=".days_p05.nc"



for i in $(seq 1982 2018)
do
   mystring="$direccion$string1$i$string2"
   echo "$mystring"
   wget $mystring
done

echo "***Compilacion exitosa***"
