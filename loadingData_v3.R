rm(list = ls())
R.Version()
sessionInfo()
#http://geog.uoregon.edu/GeogR/topics/netCDF-read-ncdf4.html
#muy buen tutorial:
#http://philmassie.com/tag/r/
#https://www.r-bloggers.com/a-netcdf-4-in-r-cheatsheet/
#http://stackoverflow.com/questions/14586482/how-to-extract-variable-names-from-a-netcdf-file-in-r
# tuve que instalar desde la shell lo siguiente
# sudo apt-get install libudunits2-dev
# para poder instalar las librerias de netcdf


##############
#R packages
##############
library(ncdf4)
library(lubridate)
##############

address="/home/jlaraya/chirps_data/netcdf_original/"
saveResultsHere="/home/jlaraya/chirps_data/converted2txt/"
setwd(address)
files=dir()
files0=files

#files=files[3]  #para probar



nc_version()  #Returns a string that is the version number of the ncdf4 package
ncin <- nc_open(files[1])
print(ncin)  #Prints information about a netCDF file, including the variables and dimensions it contains.

latSJ=9.934739
lonSJ=-84.087502

lonBottom=lonSJ-2
lonTop=lonSJ+2

latBottom=latSJ-2
latTop=latSJ+2

coordAll=NULL
#incremento=0
strt=Sys.time()
for(i in seq(1,length(files))) {#nc =nc_open(files[i])
                                # Read the whole nc file and read the length of the varying dimension (here, the 3rd dimension, specifically time)
                                print(paste("Processing the file:  ",files[i],sep=""))
                                nc = ncdf4::nc_open(files[i])
                                etadata <- capture.output(print(nc))
                                lon=ncvar_get(nc,"longitude")  
                                lat=ncvar_get(nc,"latitude") 
                                time=ncvar_get(nc,"time")
                                
                                lonRangeIndex=which(lon>lonBottom & lon< lonTop)
                                lonRange=lon[which(lon>lonBottom & lon< lonTop)]
                                latRangeIndex=which(lat>latBottom & lat<latTop)
                                latRange=lat[which(lat>latBottom & lat<latTop)]
                                variables = names(nc[['var']])
                                
                                for (lo in seq(1,length(lonRangeIndex))){for (la in seq(1,length(latRangeIndex))){
                                
                                prec <- ncvar_get(nc,variables,start=c(lonRangeIndex[lo],latRangeIndex[la],1),count = c(1,1,-1))
                                #nc_close(nc)
                                tunits <- ncatt_get(nc,"time","units")
                                startingDay0=as.Date(strsplit(tunits$value," ")[[1]][3])
                               
                                #year=strsplit(strsplit(tunits$value," ")[[1]][3],"-")[[1]][1]+incremento
                                #incremento=incremento+1
                                year=as.numeric(substr(files[i],13,16))-1
                                startingDay=as.Date(paste(year,"-01-01",sep=""))
                                date<- seq(from = startingDay, to = startingDay+length(prec), by = 1)
                                date <- date[!(format(date,"%m") == "02" & format(date, "%d") == "29") ,drop = FALSE]  #removing leap day
                                prec2=as.data.frame(cbind(lon=round(lonRange[lo],3),lat=round(latRange[la],3),day=format(date,"%d"),month=format(date,"%m"),year=format(date,"%Y"),prec))
                                
                                #si no hay datos en el archivo no se guarda
                                prec3=na.omit(prec2)
                                if(nrow(prec3)==0) {next}
                                coord=subset(prec2,select=c(lat,lon))[1,]
                                coordAll=rbind(coordAll,coord)
                                
                                write.table(prec2,quote=FALSE,file=paste(saveResultsHere,"precDia_CHIRPS_lon_",round(lonRange[lo],3),"_lat_",round(latRange[la],3),"_year_",year,".txt",sep=""),row.names=T,col.names=T)                                                                                                         
                                }}
                                
                                }


 coordAll=unique(coordAll)                               
 write.table(coordAll,quote=FALSE,file="coordenadas_archivos.txt",row.names=T,col.names=T)                                                             
                                
 print("##########################################################")
 print(paste("Total processing time:",as.character(Sys.time()-strt),sep=""))



                                
                                
                             






