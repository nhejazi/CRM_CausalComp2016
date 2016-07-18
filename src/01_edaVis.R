###==============================###
### Nima Hejazi & Alan Hubbard   ###
### CRM Workshop and Conference  ###
### Montreal, Canada, July 2016  ###
### Causal Inference Competition ###
### Script #2: Exploratory Vis.  ###
###==============================###


# basic programmatic housekeeping
proj_path <- paste0(path.expand("~"), "/git_repos/CRM_CausalComp2016")
library(ggplot2); library(GGally); library(qgraph); library(ProjectTemplate)
set.seed(0)
if( getwd() != proj_path) setwd(proj_path)
load.project()

# examine and plot correlation structure in genomic covariates
data_genomic <- micedata %>%
                  na.omit() %>%
                  select(which(substr(colnames(micedata),1,4) %in% "IMPC"))

corr_genomic <- data_genomic %>%
                  cor()

pdf(paste0(proj_path, "/figs/genes_correlationPlot.pdf"))
p.corr_genomic <- ggcorr(corr_genomic)
plot(p.corr_genomic)
dev.off()


# generating correlation undirected acyclic graph with qgraph
pdf(paste0(proj_path, "/figs/genes_correlationGraph.pdf"))
p.corr_graph <- qgraph(corr_genomic, layout = "spring", labels = codebook$nam,
                       label.scale = FALSE, label.cex = 1, node.width = 0.5)
dev.off()


# generating sparse graph above from Graphical Lasso using qgraph
pdf(paste0(proj_path, "/figs/genes_glassoGraph.pdf"))
p.glasso_graph <- qgraph(corr_genomic, layout = "spring", graph = "glasso",
                         sampleSize = nrow(micedata), labels = codebook$nam,
                         label.scale = FALSE, label.cex = 1, node.width = 0.5)
dev.off()
