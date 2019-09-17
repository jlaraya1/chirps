

 
rm(list = ls())
R.Version()

#################
#libraries
library(maps)
library(mapdata)
library(fields)
data(worldMapEnv)
##################

datosFaltantes <- function(codDatoFaltante,datos) {
  #codDatoFaltante: el numero usando como representación del dato faltante en el
  #vector columna analizado (ej. -9,-99,etc)
  #datos: vector columna al cual se va a reemplazar por NA los datos codificados 
  #como faltantes
  i<-which(datos==codDatoFaltante)
  datos<-replace(datos,i,NA) 
  datos<-datos
}
reporte <- function(archivo,reso,resol,ruta,calculo,prefijo,diviHora,tipoRep) {
  ##################################################################
  #archivo: archivo al que se le calculará el reporte
  #resol: resolución del reporte: "month", "day"
  #reso: resolución de los datos originales
  #ruta: ruta del directorio donde se almacenan los resultados
  #calculo: "promedio", "total"  o   "moda"  según corresponda
  #encab: encabezado de los datos
  #prefijo: un prefijo identificador del archivo, para saber que es
  #tipoRep: "todo" y se imprimen todas las columnas. resumido" y se imprimen solo una parte
  ##################################################################
  #datos<-read.table(archivo,sep="",fill=TRUE,blank.lines.skip=TRUE,header=T)
  datos<-read.table(archivo,sep="",fill=TRUE,blank.lines.skip=TRUE,header=T,row.names=NULL)
  names(datos)=c("CONT","LON","LAT","DIA","MES","AGNO","DATOS")
  
  datos$DATOS<-datosFaltantes(-9999,datos$DATOS)

   #Procedo a ordenar por fechas crecientes:
   datosFechas<-paste(as.character(datos$AGNO),"-",as.character(datos$MES),"-",as.character(datos$DIA),"-",as.character(0),"-00-00")
   datosFechas <- ymd_hms(datosFechas)

   redond<-floor_date(datosFechas,reso)
   datos<-data.frame(cbind(redond,datos))
   datos<- datos[order(datos$redond),]
   datos$redond<-floor_date(datos$redond,resol)
  #write.table(datos,quote=FALSE,file=paste(ruta,calculo,"datosOrdenados",archivo), col.names = TRUE, row.names = FALSE) 
  if(tolower(calculo)=="promedio"){ reporteDia<-ddply(datos,"redond", summarise,LONGIUTD = max(LON,na.rm = TRUE),LATITUD = max(LAT,na.rm = TRUE),DATOS2 = mean(DATOS,na.rm = TRUE),MAX = max(DATOS,na.rm = TRUE),MIN = min(DATOS,na.rm = TRUE),TotDatSinNA  =length(na.omit(DATOS)),TotDat =length(DATOS),.progress="text") }
  if(tolower(calculo)=="total")   { reporteDia<-ddply(datos,"redond", summarise, LONGITUD = max(LON,na.rm = TRUE),LATITUD = max(LAT,na.rm = TRUE),DATOS2 = sum(DATOS,na.rm = TRUE) , TotDatSinNA =length(na.omit(DATOS)),TotDat =length(DATOS),.progress="text") }
  if(tolower(calculo)=="moda")    { reporteDia<-ddply(datos,"redond", summarise, DATOS2 = Mode(DIR,na.rm = FALSE),.progress = "text")   }    
  reporteDia$DATOS3<- elimPorcNanes(reporteDia$DATOS2,reporteDia$TotDatSinNA,reporteDia$TotDat,70) 
  if(tolower(tipoRep)=="resumido")   { reporteDia=subset(reporteDia,select=c("redond","CUENCA","ESTACION","DATOS3")) }
  write.table(reporteDia,quote=FALSE,file=paste(ruta,calculo,prefijo,archivo,sep="-"), col.names = TRUE, row.names = FALSE) 
  
  #plot(reporteDia$DATOS3,type="l",pch=19,col="red",cex=0.5,xlab="Contador",ylab="magnitud")
  #title(archivo)
  
  print(head(reporteDia))
  reporteDia<-reporteDia
}


reportesD_Q_M_Y<- function(lista,opcion,reso,resol,guardeEn,Calculo,prefijoDia,tipoRep) {
  #función para generar reportes diarios, 
  #opcion= 1,2,etc
  #rutaDia <-"../resultadosDay/"
  #prefijoDia=c("tempAutoWeek-","HRAutoWeek-","lluvAutoWeek-")
  #resol<-"day";diviHora<-1
  #Calculo= "promedio"
  opcion=as.numeric(opcion)
  diviHora=1
  for(j in 1:length(prefijoDia)){
    for (i in 1:length(lista)) {rep <-reporte(lista[i],reso,resol,guardeEn,Calculo,prefijoDia,diviHora,tipoRep)  }    }
  
  
}




selectSomeFiles<-function(files,init,fin,prefix,typeOfFile){
  #####################################################
  # This function makes possible to extract some files
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


joinData<-function(ruta,files,saveResultsHere){
  
  #Esta función genera una serie de resultados a partir de los archivos de datos CHIRPS
  # que se encuentran en "ruta". Los "files" allí ubicados se tratan con un conjunto de 
  # algoritmos cuyo propósito es dar series de tiempo unificadas. Los resultados se guardan en
  # "saveResultsHere"
  
  
  
  station_coord_all=NULL
  for (i in seq(1, length(files))){ station_coord=strsplit(files[i],"_")  
  lon=as.numeric(station_coord[[1]][4]);lat=as.numeric(station_coord[[1]][6]);year=as.numeric(strsplit(station_coord[[1]][8],".txt")[[1]][1])
  station_coord2=as.matrix(cbind(lon,lat,year))
  station_coord_all=rbind(station_coord_all,station_coord2)   }
  
  locations=as.data.frame(unique(subset(station_coord_all,select=lat:lon)))
  years=unique(subset(station_coord_all,select=year))
  write.table(locations,quote=FALSE,file=paste(saveResultsHere,"locations_CHIRPS_ts.txt",sep=""),row.names=T,col.names=T)   
  write.table(years,quote=FALSE,file=paste(saveResultsHere,"years_CHIRPS_ts.txt",sep=""),row.names=T,col.names=T) 
  
  
  #mapeamos estas estaciones a ver cómo se ve:

  
  png(paste(saveResultsHere,"mapasCHIRPS2",".png",sep=""))
  map('world',xlim=c(min(locations$lon)-2,max(locations$lon)+2),ylim=c(min(locations$lat)-2,max(locations$lat)+2),boundary=TRUE, fill=TRUE,col="yellow")
  points(as.numeric(as.character(locations$lon)), as.numeric(as.character(locations$lat)), pch=16, col="red", cex=0.3) 
  map.axes(cex.axis=0.6)
  title("Series de tiempo CHIRPS usadas para el territorio nacional")
  dev.off() 
  
  ############################################################################################################
  #prueba de consistencia de los archivos: deben de tener todos un unico año,si todo está bien: archRaros=NULL
  archRaros=NULL
  dimeAll=NULL
  ts_all=NULL
  dime=NULL
  for(i in seq(1,length(files))){a=read.table(files[i],header=TRUE)
  if ((max(a$year>min(a$year)))){archRaros=append(archRaros,files[i])}
  dime=cbind(longitud=a$lon[1],latitud=a$lat[1],No_fil=dim(a)[1],No_col=dime[2],mx_prec=max(a$prec,na.rm=TRUE),mn_prec=min(a$prec,na.rm=TRUE),percentage_NA=100*sum(is.na(a$prec)*1)/nrow(a))
  dimeAll=rbind(dimeAll,dime)
  }
  
  dimeAll=as.data.frame(dimeAll)
  write.table(archRaros,quote=FALSE,file=paste(saveResultsHere,"archRaros.txt",sep=""),row.names=T,col.names=T) 
  write.table(dimeAll,quote=FALSE,file=paste(saveResultsHere,"estadisticas.txt",sep=""),row.names=T,col.names=T) 
  
  
  #unificar los archivos con las mismas coordenadas...
  tablaAll=NULL
  for(i in seq(1,length(files))){a=read.table(files[i],header=TRUE)
  lon=as.numeric(strsplit(files[i],"_")[[1]][4]);lat=as.numeric(strsplit(files[i],"_")[[1]][6])
  tabla=cbind(i,lon,lat);tablaAll=rbind(tablaAll,tabla)
  }
  
  #El siguiente algoritmo concatena los archivo bajo uno solo con continuidad para cada uno de los puntos geográficos:
  tablaAll=as.data.frame(tablaAll)
  soloCoord=as.data.frame(unique(subset(tablaAll,select=c("lon","lat"))))   # las coordenadas no repetidas
  write.table(tablaAll,quote=FALSE,file=paste(saveResultsHere,"coord_todas.txt",sep=""),row.names=T,col.names=T) 
  write.table(soloCoord,quote=FALSE,file=paste(saveResultsHere,"coord_no_repetidas.txt",sep=""),row.names=T,col.names=T) 
  
  for(i in seq(1,nrow(soloCoord))){indices= which(soloCoord$lon[i]==tablaAll$lon & soloCoord$lat[i]==tablaAll$lat )
  files2=files[indices]
  tsAll=NULL
  for(ii in seq(1,length(files2))){  ts= read.table(files2[ii],header=TRUE)
  tsAll=rbind(tsAll,ts)          }
  
  ts_file=paste("precDia_CHIRPS_lon_",ts$lon[1],"_lat_",ts$lat[1],".txt",sep="")
  write.table(tsAll,quote=FALSE,file=paste(saveResultsHere,ts_file,sep=""),row.names=T,col.names=T) 
  write.table(files2,quote=FALSE,file=paste(saveResultsHere,"groups_",ts_file,sep=""),row.names=T,col.names=T) 
  }
  

}


ruta<-"/home/jlaraya/chirps_data/converted2txt/"
saveResultsHere="/home/jlaraya/chirps_data/joining_ts/"
setwd(ruta)
files=dir()

joinData(ruta,files,saveResultsHere)


#revisando las dimensiones de los archivos unidos:
ruta<-"../joining_ts/"
setwd(ruta)
files=dir()
files2=selectSomeFiles(files,1,7,"precDia",".txt")

dimAll=NULL
for(i in seq(1,length(files2))){ 
  inicio=paste(dat$day[1],dat$month[1],dat$year[1],sep="-")
  final=paste(dat$day[nrow(dat)],dat$month[nrow(dat)],dat$year[nrow(dat)],sep="-")
  dat=read.table(files2[i],header=TRUE)
  dimen=cbind(archivo=files2[i],nFil=nrow(dat),nCol=ncol(dat),inicio,final)
  dimAll=rbind(dimAll,dimen)

}

dimAll=as.data.frame(dimAll)
#rownames(dimAll)=NULL; names(dimAll)=c("file","nFil","nCol")
#dimAll$nFil=as.numeric(dimAll$nFil);dimAll$nCol=as.numeric(dimAll$nCol)
write.table(dimAll,quote=FALSE,file="dimension_files",row.names=T,col.names=T) 



#Generación de reportes mensuales y anuales:
#source("/home/jlaraya/Documents/BaseEspejo/codigo/funciones.R")

#################################################
#Cálculo de totales mensuales de precipitación
#################################################
#################
#import Libraries
library("plyr")
library("lubridate")
################
opcion=4
Calculo= "total"
guardeEn <-"../resumen_mes/"
prefijo="mensual-"
reso<-"day"
resol<-"month"
tipoRep<-"todo"
reportesD_Q_M_Y(files2,opcion,reso,resol,guardeEn,Calculo,prefijo,tipoRep)

################
opcion=4
Calculo= "total"
guardeEn <-"../resumen_agno/"
prefijo="mensual-"
reso<-"day"
resol<-"month"
tipoRep<-"todo"
reportesD_Q_M_Y(files2,opcion,reso,resol,guardeEn,Calculo,prefijo,tipoRep)

#################
guardeEn <-"../resumen_agno/"
prefijo="anual-"
resol<-"year"
reportesD_Q_M_Y(files2,opcion,reso,resol,guardeEn,Calculo,prefijo,tipoRep)

