###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #1: Data Processing   ###
###==============================###

# basic programmatic housekeeping
proj_path <- getwd()
data_path <- paste0(getwd(), "/../data/")
library(SuperLearner)
library(data.table)
library(ggplot2)

# load data using included helper script
setwd(data_path)
#source("load_mouse_data.R")  #includes example causal DAG
micedata <- data.table(readRDS("mouse_data.RDS"))
codebook <- data.table(readRDS("variable_names.RDS"))

# examine missing-ness in observed full data structure
knockout <- subset(micedata, is.na(rowSums(micedata[, c(5:26), with = FALSE])))
missvars <- colnames(micedata)[which(is.na(colSums(micedata[, c(5:26),
                                                   with = FALSE])))]
missinfo <- (codebook$nam)[which(codebook$ph %in% missvars)]

# clean up data further as necessary...

