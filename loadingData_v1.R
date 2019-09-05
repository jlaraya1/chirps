rm(list = ls())
R.Version()
#http://geog.uoregon.edu/GeogR/topics/netCDF-read-ncdf4.html
#muy buen tutorial:
#http://philmassie.com/tag/r/
#https://www.r-bloggers.com/a-netcdf-4-in-r-cheatsheet/

address="//192.168.13.1/share/Nikitin/?????/???-???????-???/temp-netcdf"
saveResultsHere="C:/Users/Jose/Documents/datos3D/results"
setwd(address)
files=dir()
files0=files

# [1] "temp-result-day-20140218.nc" "temp-result-day-20140219.nc" "temp-result-day-20140220.nc" "temp-result-day-20140221.nc"
# [5] "temp-result-day-20140222.nc" "temp-result-day-20140223.nc" "temp-result-day-20140224.nc" "temp-result-day-20140225.nc"
# [9] "temp-result-day-20140226.nc" "temp-result-day-20140227.nc" "temp-result-day-20140228.nc" "temp-result-day-20140301.nc"
# [13] "temp-result-day-20140302.nc" "temp-result-day-20140303.nc" "temp-result-day-20140304.nc" "temp-result-day-20140305.nc"
# [17] "temp-result-day-20140306.nc" "temp-result-day-20140307.nc" "temp-result-day-20140308.nc" "temp-result-day-20140309.nc"

library(ncdf4)


nc_version()  #Returns a string that is the version number of the ncdf4 package

#this is one way of generating a list of the files:
addressAll2=NULL
for (i in seq(1,length(files))){addressAll=paste(address,files[i],sep="/")
                                addressAll2=append(addressAll2,addressAll)  }

#this is another way, which is more succint:
#Open all files
addressAll2= list.files("//192.168.13.1/share/Nikitin/?????/???-???????-???/temp-netcdf/",pattern="*.nc",full.names=TRUE)
write.table(addressAll2,quote=FALSE,file=paste(saveResultsHere,"addressAll2.txt",sep="/"),row.names=F,col.names=F)

# [1] "//192.168.13.1/share/Nikitin/?????/???-???????-???/temp-netcdf temp-result-day-20140218.nc"
# [2] "//192.168.13.1/share/Nikitin/?????/???-???????-???/temp-netcdf temp-result-day-20140219.nc"
# [3] "//192.168.13.1/share/Nikitin/?????/???-???????-???/temp-netcdf temp-result-day-20140220.nc"
# [4] "//192.168.13.1/share/Nikitin/?????/???-???????-???/temp-netcdf temp-result-day-20140221.nc"
# [5] "//192.168.13.1/share/Nikitin/?????/???-???????-???/temp-netcdf temp-result-day-20140222.nc"

ncin <- nc_open(files[1])
print(ncin)  #Prints information about a netCDF file, including the variables and dimensions it contains.

##################################################

#http://stackoverflow.com/questions/14586482/how-to-extract-variable-names-from-a-netcdf-file-in-r

#Open all files
files= list.files("//192.168.13.1/share/Nikitin/?????/???-???????-???/temp-netcdf/",pattern="*.nc",full.names=TRUE)

# Loop over files

for(i in seq(1,length(files))) {#nc =nc_open(files[i])
                                # Read the whole nc file and read the length of the varying dimension (here, the 3rd dimension, specifically time)
                                datAll=NULL
                                nc = ncdf4::nc_open(files[i])
                                attributes(nc)$names  #list of atributes
                                print(paste("The file has",nc$nvars,"variables,",nc$ndims,"dimensions and",nc$natts,"NetCDF attributes"))
                                variables = names(nc[['var']]) #it shows the variables,also:  attributes(nc$var)$names
                                variables2= attributes(nc$var)$names
                                lon=ncvar_get(nc,"nav_lon") 
                                lat=ncvar_get(nc,"nav_lat") 
                                depth=ncvar_get(nc,"deptht_bnds")
                                time=ncvar_get(nc,"time_counter_bnds")
                                temp =  ncvar_get(nc,"votemper")
                                #saving the separated values
                                #write.table(lon,quote=FALSE,file=paste(saveResultsHere,"/","lon","_",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=F,col.names=T)
                                #write.table(lat,quote=FALSE,file=paste(saveResultsHere,"/","lat","_",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=F,col.names=T)
                                #write.table(depth,quote=FALSE,file=paste(saveResultsHere,"/","depth","_",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=F,col.names=T)
                                #write.table(time,quote=FALSE,file=paste(saveResultsHere,"/","time","_",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=F,col.names=T)
                                #write.table(temp,quote=FALSE,file=paste(saveResultsHere,"/","temp","_",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=F,col.names=T)
                             
                                ###########################################
                                #taking a look at the atributes:
                                ncatt_get(nc, attributes(nc$var)$names[1])  #attributes(nc$var)$names[1]  =
                                #see what this command does:
                             
                                # > attributes(nc$var)$names[1]
                                # [1] "nav_lon"
                                # > attributes(nc$var)$names[2]
                                # [1] "nav_lat"
                                # > attributes(nc$var)$names[3]
                                # [1] "deptht_bnds"
                                # > attributes(nc$var)$names[4]
                                # [1] "time_counter_bnds"
                                # > attributes(nc$var)$names[5]
                                # [1] "votemper"
                                # > attributes(nc$var)$names[6]
                                # [1] NA
                                # > attributes(nc$var)$names[7]
                                # [1] NA
                             
                                # Retrieve a matrix of for the variable data using the ncvar_get function:
                                lon2=ncatt_get(nc, attributes(nc$var)$names[1])
                                lat2=ncatt_get(nc, attributes(nc$var)$names[2])
                                depth2=ncatt_get(nc, attributes(nc$var)$names[3])
                                time2=ncatt_get(nc, attributes(nc$var)$names[4])
                                temp2=ncatt_get(nc, attributes(nc$var)$names[5])
                                print(paste(dim(lat2), "latitudes and", dim(lon2), "longitudes"))
                                
                                lon3=ncvar_get(nc, attributes(nc$var)$names[1])
                                lat3=ncvar_get(nc, attributes(nc$var)$names[2])
                                depth3=ncvar_get(nc, attributes(nc$var)$names[3])
                                time3=ncvar_get(nc, attributes(nc$var)$names[4])
                                temp3=ncvar_get(nc, attributes(nc$var)$names[5])
                                
                                # > dim(lat3)
                                # [1] 406 452
                                # > dim(lon3)
                                # [1] 406 452
                                # > dim(depth3)
                                # [1]  2 12
                                # > dim(time3)
                                # [1]  2 24
                                # > dim(temp3)
                                # [1] 406 452  12  24
                                print(paste("iterator number",i,sep="="))
                                strt=Sys.time()
                               
                                for (ii in seq(1,2)){for (iii in seq(1,2)){
                                
                                #for (ii in seq(1,dim(lat)[1])){for (iii in seq(1,dim(lat)[2])){ 
                                                                                                dat=as.data.frame(temp3[ii,iii,,])
                                                                                                print(paste("indices lat:",ii,"---","lon:",iii,sep=""))
                                                                                                names(dat)=paste("hour",1:ncol(dat),sep="_") 
                                                                                                rownames(dat)=paste("level",1:nrow(dat),sep="_") 
                                                                                                dat2=cbind(lat=lat[ii,iii],lon=lon[ii,iii],dat)  
                                                                                                datAll=as.data.frame(rbind(datAll,dat2))
                                                                                               }}
                                
                                write.table(datAll,quote=FALSE,file=paste(saveResultsHere,"/","datAll-",strsplit(files0[i],".nc")[[1]],i,".txt",sep=""),row.names=T,col.names=T)                               
                                print(paste("time:",as.character(Sys.time()-strt),sep=""))
                                }
print("##########################################################")
print(paste("Total processing time:",as.character(Sys.time()-strt),sep=""))


#1
#here you get a matrix for 12 depth levels and 24 hours
#for the coordinates with indexes 300 and 200
# > lon[300,200]
# [1] -174.9875
# > lat[300,200]
# [1] 78.82996
                                
                                
                             






