##############################################################################################
# Este script permite visualizar los puntos geográficos de cada una de las series temporales
# usando los script "loadingData_v....R"
# Desarrollado por: José Luis Araya López
# Contacto: jlaraya1@gmail.com
##############################################################################################

rm(list = ls())
R.Version()


selectSomeFiles<-function(files,init,fin,prefix,typeOfFile){
  #####################################################
  # This function allows you to extract some files
  # after reading files=dir(). You have to provide
  # the initial index (ini) and final index (fin)
  # of the common prefix of the files you want to
  #extract. "typeOfFile" allows you to enter the type
  #of file (.txt,.pdf) that you are looking for...
  #####################################################
  e=substr(files,init,fin)
  prefix=as.character(prefix)
  typeOfFile=as.character(typeOfFile)
  index=NULL
  subfiles=NULL
  for(i in seq(1,length(e))){if(e[i]==prefix){index=append(index,i)}}
  subfiles=files[index]
  ii=grep(typeOfFile,subfiles)
  subfiles=subfiles[ii]
  return(subfiles)}


library(maps)
library(mapdata)
library(fields)
data(worldMapEnv)


ruta<-"/home/jlaraya/chirps_data/netcdf_original/"
setwd(ruta)
files=dir()
coord=selectSomeFiles(files,1,11,"coordenadas",".txt") 


coord_CHIRPS=read.table(coord,header=TRUE)
png(paste(ruta,"mapasCHIRPS",".png",sep=""))
#map('world',xlim=c(min(grupo$LONDEC)-lonDelta_inf,max(grupo$LONDEC)+lonDelta_sup),ylim=c( (min(grupo$LATDEC)-latDelta_inf), (max(grupo$LATDEC)+latDelta_sup)),boundary=TRUE, fill=TRUE,col="yellow")
map('world',xlim=c(min(coord_CHIRPS$lon)-2,max(coord_CHIRPS$lon)+2),ylim=c(min(coord_CHIRPS$lat)-2,max(coord_CHIRPS$lat)+2),boundary=TRUE, fill=TRUE,col="yellow")
points(as.numeric(as.character(coord_CHIRPS$lon)), as.numeric(as.character(coord_CHIRPS$lat)), pch=16, col="red", cex=0.3) 
map.axes(cex.axis=0.6)
title("Series de tiempo CHIRPS usadas para el territorio nacional")
dev.off() 







