###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #1: Data Processing   ###
###==============================###

# basic programmatic housekeeping
proj_path <- "~/git_repos/CRM_CausalComp2016/analysis/"
data_path <- "~/git_repos/CRM_CausalComp2016/data/"
library(data.table)

# load data using included helper script
#source("load_mouse_data.R")  #includes example causal DAG
micedata <- data.table(readRDS(paste0(data_path, "mouse_data.RDS")))
codebook <- data.table(readRDS(paste0(data_path, "variable_names.RDS")))

# examine missing-ness in observed full data structure
knockout <- subset(micedata, is.na(rowSums(micedata[, c(5:26), with = FALSE])))
miss_subj <- which(is.na(rowSums(as.data.frame(micedata)[, 5:26])))

#EndScript
