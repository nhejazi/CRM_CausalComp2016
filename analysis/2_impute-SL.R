###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #2: Impute using SL   ###
###==============================###


full_data <- micedata[, c(5:26), with = FALSE]

for (idx in 1:length(missvars)) {
  y_idx <- which(colnames(full_data) == missvars[idx])
  y <- subset(full_data, select = y_idx)
  X <- subset(full_data, select = -y_idx)

  

  for (icol in 1:ncol(X)) {
    if (sum(X[, icol]) == "NA") {
      na_idx <- which(
    }
  }

}

X=Xdat
xp=dim(Xdat)[2]

if(xp > 0) {
  sna=apply(Xdat,2,sum.na)
  nmesX=names(Xdat)

  for(k in 1:xp){
    if(sna[k] > 0) {
        ix=as.numeric(is.na(Xdat[,k])==F)
        Xdat[is.na(Xdat[,k]),k]=0
        Xdat=data.frame(Xdat,ix)
        nmesX=c(nmesX,paste("Imiss_",nmesX[k],sep=""))
    }
  }
  names(Xdat)=nmesX
}
