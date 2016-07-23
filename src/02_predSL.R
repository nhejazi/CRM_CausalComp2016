###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #3: Imputation w/ SL  ###
###==============================###

options(scipen = 999) #no scientific notation
library(data.table); library(dplyr); library(dtplyr); library(SuperLearner)
SL.library <- c("SL.loess", "SL.stepAIC", "SL.gam", "SL.mean", "SL.xgboost",
                "SL.glm", "SL.glmnet", "SL.nnet", "SL.randomForest")

# generate observed data and find variables with missingness
obs_O <- as.data.frame(micedata[, c(5:26), with = FALSE])
varsNA <- names(which(is.na(colSums(obs_O, na.rm = FALSE))))

# variable scaling
scaled_O <- as.data.frame(scale(obs_O))

yfit <- list()  #store predicted values over all folds of cross-validation

for (idx in 1:length(varsNA)) {
  set.seed(0)
  #get prediction covariate
  y <- scaled_O %>%
        dplyr::select(which(colnames(.) %in% varsNA[idx])) %>%
        unlist() %>%
        as.vector()

  #make missingness indicators for other covariates
  indNA <- list()
  varsNAind <- varsNA[varsNA %ni% varsNA[idx]]
  for (i in 1:length(varsNAind)) {
    indicatorNA <- as.integer(!is.na(scaled_O[, varsNAind[i]]))
    indNA[[i]] <- indicatorNA
  }

  #generate indicators and remove testing covariate from training data structure
  I <- as.data.frame(matrix(unlist(indNA), nrow = nrow(scaled_O), byrow = TRUE))
  X <- scaled_O %>%
        dplyr::select(which(colnames(.) != varsNA[idx]))

  #replace all missing values in training/testing data structures with zeros
  X[is.na(X)] <- 0
  y[is.na(y)] <- 0

  #add indicator variables to training data structure
  X <- cbind(X, I)

  #use SuperLearner to predict missing gene Y
  yfit.SL <- SuperLearner(y, X, family = gaussian(), SL.library = SL.library,
                          verbose = TRUE)
  yfit[[idx]] <- as.vector(yfit.SL$SL.predict)
}


# find indices of missing values for covariates with missingness
indNA <- list()
for (i in 1:sum(is.na(colMeans(obs_O)))) {
  indNA[[i]] <- which(is.na(obs_O[,varsNA[i]]))
}


# un-normalize predicted values from the SuperLearner
yfit_untrans <- list()
for (i in 1:length(yfit)) {
  yfit_untrans[[i]] <- (yfit[[i]]*sd(obs_O[, varsNA[i]], na.rm = TRUE)) +
                       mean(obs_O[, varsNA[i]], na.rm = TRUE)
}
yfit.pred <- do.call("cbind", lapply(yfit_untrans, as.data.frame))


# replace missing values in original data structure with predicted values
res_O <- obs_O  #make copy to avoid overwriting original observed data structure
for (i in 1:length(yfit_untrans)) {
  res_O[which(is.na(res_O[, varsNA[i]])),
        varsNA[i]] <- yfit_untrans[[i]][which(is.na(res_O[, varsNA[i]]))]
}


# find the MSE associated with predictions for each covariate of interest
O.varsNA <- obs_O %>%
              dplyr::select(which(colnames(.) %in% varsNA)) %>%
              as.data.frame()

mse.pred <- (colSums(as.data.frame(yfit.pred) - O.varsNA,
                     na.rm = TRUE)^2)/(rep(nrow(O.varsNA),
                                           length(varsNA)) -
                                       colSums(is.na(O.varsNA)))

# find average MSE across covariates via weighted average and add to MSE vector
weights <- (rep(nrow(O.varsNA),length(indNA)) - sapply(indNA, length))/
            sum(rep(nrow(O.varsNA), length(indNA)) - sapply(indNA, length))
mse.pred <- c(mse.pred, sum(weights * mse.pred))
names(mse.pred) <- c(varsNA, "MSE_WeightedAvg")


# export matrix of all covariates with missingness and just imputed values
colnames(yfit.pred) <- varsNA
yfit.pred <- data.table(yfit.pred)

impute.SL <- list()
for (i in 1:length(varsNA)) {
    impute.SL[[i]] <- yfit.pred %>%
                        as.data.frame(.) %>%
                        dplyr::slice(indNA[[i]]) %>%
                        dplyr::select(which(colnames(.) %in% varsNA[i]))
}

sapply(impute.SL, write.table, file = paste0(proj_path,
                                             "/results/imputedSL.csv"),
       append = TRUE, sep = ",", col.names = FALSE, row.names = FALSE)

data.table::fwrite(yfit.pred, file.path = paste0(proj_path,
                                                 "/results/fittedSL.csv"))


# clean up workspace a bit
rm("i", "idx", "indicatorNA", "indNA", "SL.library", "varsNAind", "yfit.SL",
   "I", "X", "y", "yfit", "scaled_O")

#EndScript
