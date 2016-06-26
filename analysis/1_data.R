###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #1: Data Processing   ###
###==============================###

# basic programmatic housekeeping
proj_path <- "~/git_repos/crm_comp2016/analysis/"
data_path <- paste0(proj_path, "/../data/")
library(data.table)
library(ggplot2)

# load data using included helper script
#source("load_mouse_data.R")  #includes example causal DAG
micedata <- data.table(readRDS(paste0(data_path, "mouse_data.RDS")))
codebook <- data.table(readRDS(paste0(data_path, "variable_names.RDS")))

# examine missing-ness in observed full data structure
knockout <- subset(micedata, is.na(rowSums(micedata[, c(5:26), with = FALSE])))
missvars <- colnames(micedata)[which(is.na(colSums(micedata[, c(5:26),
                                                   with = FALSE])))]
missinfo <- (codebook$nam)[which(codebook$ph %in% missvars)]
