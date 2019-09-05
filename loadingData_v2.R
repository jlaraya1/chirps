rm(list = ls())
R.Version()
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

##############

address="/home/jlaraya/chirps_data/netcdf_original/"
saveResultsHere="/home/jlaraya/chirps_data/converted2txt/"
setwd(address)
files=dir()
files0=files

files=files[4]  #para probar



nc_version()  #Returns a string that is the version number of the ncdf4 package
ncin <- nc_open(files[1])
print(ncin)  #Prints information about a netCDF file, including the variables and dimensions it contains.

for(i in seq(1,length(files))) {#nc =nc_open(files[i])
                                # Read the whole nc file and read the length of the varying dimension (here, the 3rd dimension, specifically time)
                                datAll=NULL
                                nc = ncdf4::nc_open(files[i])
                                attributes(nc)$names  #list of atributes
                                print(paste("The file has",nc$nvars,"variables,",nc$ndims,"dimensions and",nc$natts,"NetCDF attributes"))
                                variables = names(nc[['var']]) #it shows the variables,also:  attributes(nc$var)$names
                                variables2= attributes(nc$var)$names
                                lon=ncvar_get(nc,"longitude")  
                                lat=ncvar_get(nc,"latitude") 
                                time=ncvar_get(nc,"time")
                                tunits <- ncatt_get(nc,"time","units")
                                tunits$value
                                variables = names(nc[['var']])
                                prec =  ncvar_get(nc,"precip")
                                dim(prec)
                                
                                # > dim(prec)
                                # [1] 7200 2000  212
                                # > dim(lat)
                                # [1] 2000
                                # > dim(lon)
                                # [1] 7200
                                # > dim(time)
                                # [1] 212
                                
                                
                                #saving the separated values
                                # write.table(lon,quote=FALSE,file=paste(saveResultsHere,"/","lon","_",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=F,col.names=T)
                                # write.table(lat,quote=FALSE,file=paste(saveResultsHere,"/","lat","_",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=F,col.names=T)
                                # write.table(time,quote=FALSE,file=paste(saveResultsHere,"/","time","_",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=F,col.names=T)
                                # write.table(prec,quote=FALSE,file=paste(saveResultsHere,"/","prec","_",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=F,col.names=T)
                             
                                ###########################################
                                #taking a look at the atributes:
                                ncatt_get(nc, attributes(nc$var)$names[1])  #attributes(nc$var)$names[1]  
                                missingValue=ncatt_get(nc, attributes(nc$var)$names[1])[[5]]
                                #see what this command does:
                             
                          
                             
                                strt=Sys.time()
                                datAll=NULL
                                for (lo in seq(1,10)){for (la in seq(1,10)){for (ti in seq(1,10)){dat=as.data.frame(prec[lo,la,ti])
                                                                                                   print(paste("indices lat:",la,"---","lon:",lo,sep=""))
                                                                                                   print(dat)
                                                                                                   #names(dat)=paste("hour",1:ncol(dat),sep="_") 
                                                                                                   #rownames(dat)=paste("level",1:nrow(dat),sep="_") 
                                                                                                   dat2=cbind(lat=lat[la],lon=lon[lo],time[ti],dat)  
                                                                                                   datAll=as.data.frame(rbind(datAll,dat2))
                                                                                                   }}}
                                
                                 write.table(datAll,quote=FALSE,file=paste(saveResultsHere,"/","datAll-",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=T,col.names=T)                               
                                 print(paste("time:",as.character(Sys.time()-strt),sep=""))
                                 }


# print("##########################################################")
# print(paste("Total processing time:",as.character(Sys.time()-strt),sep=""))


#1
#here you get a matrix for 12 depth levels and 24 hours
#for the coordinates with indexes 300 and 200
# > lon[300,200]
# [1] -174.9875
# > lat[300,200]
# [1] 78.82996
                                
                                
                             






