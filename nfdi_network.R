################################################################
# Author:  Lukas C. Bossert                                    #
# deviated from https://github.com/dorothearrr/NFDI_Netzwerk   #
# E-mail:  bossert@itc.rwth-aachen.de                          #
################################################################
#!/usr/bin/env Rscript
nfdi_currentpath <- getwd()
setwd(nfdi_currentpath)
set.seed(4211)
if (!require("pacman")) install.packages("pacman")
  pacman::p_load_current_gh("mattflor/chorddiag")
  pacman::p_load(dplyr, magrittr, ggplot2, tidyr, curl)
if (!require("threejs")) install.packages("threejs")
if (!require("htmlwidgets")) install.packages("htmlwidgets")
if (!require("igraph")) install.packages("igraph")
if (!require("networkD3")) install.packages("networkD3")
if (!require("magrittr")) install.packages("magrittr")
library('chorddiag')
library('htmlwidgets')
library('igraph')
library('networkD3')
library('magrittr')

nfdi_edges_2019 <- read.csv("2019/nfdi_edges_2019.csv", header=T, as.is=T,)
nfdi_edges_2020 <- read.csv("2020/nfdi_edges_2020.csv", header=T, as.is=T,)
nfdi_network <- function(nfdi_section,nfdi_section_name) {
  nfdi_export_network <- function(nfdi_number_suffix) {
    ExportFileName <- paste(nfdi_section_name,"/",nfdi_section_name,"_nfdi_network_",nfdi_number_suffix,sep="")
    png(filename=ExportFileName,6000,6000)
  }
  nfdi_net <- graph_from_data_frame(nfdi_section, directed=F)
  nfdi_net <- simplify(nfdi_net,remove.multiple = F, remove.loops = T)
  nfdi_D <- data.frame(get.edgelist(nfdi_net))  # convert to data frame
  nfdi_ones <- rep(1, nrow(nfdi_D))   # a column of 1s
  nfdi_result <- aggregate(nfdi_ones, by = as.list(nfdi_D), FUN = sum)
  names(nfdi_result) <- c("from", "to", "weight")
  nfdi_result
  nfdi_net <- graph_from_data_frame(nfdi_result, directed=F)
  E(nfdi_net)$width <- E(nfdi_net)$weight*20
  graph_attr(nfdi_net, "layout") <- layout_with_graphopt
  edge_attr(nfdi_net, "curved") <- 0.1
  edge_attr(nfdi_net, "color") <- "#808080"
  vertex_attr(nfdi_net, "color") <- adjustcolor("#435FAC", alpha.f = .5)
  vertex_attr(nfdi_net, "label.cex") <- 10
  vertex_attr(nfdi_net, "size") <- degree(nfdi_net)
  vertex_attr(nfdi_net, "label.degree") <- 1
  vertex_attr(nfdi_net, "label.dist") <- .75
  vertex_attr(nfdi_net, "label.family") <- "Roboto"
  nfdi_export_network("1.png")
  set.seed(4211)
  plot(nfdi_net)
  dev.off()
  nfdi_net_clp <- cluster_optimal(nfdi_net)
  nfdi_export_network("2.png")
  set.seed(4211)
  plot(nfdi_net_clp, nfdi_net)
  dev.off()
  V(nfdi_net)$community <- nfdi_net_clp$membership
  nfdi_colrs <- adjustcolor( c("blue", "tomato", "gold", "yellowgreen"), alpha.f = .5)
  vertex_attr(nfdi_net, "color") <- nfdi_colrs[V(nfdi_net)$community]
  nfdi_export_network("3.png")
  set.seed(4211)
  plot(nfdi_net)
  dev.off()
  nfdi_t1 <- graph.data.frame(nfdi_section, directed=FALSE)
  nfdi_t1 <- simplify(nfdi_t1,remove.multiple = F, remove.loops = T)
  nfdi_t2 <- get.adjacency(nfdi_t1)
  nfdi_t3 = as.matrix(nfdi_t2)
  nfdi_group_colors <- c("#435FAC","#AEC3FD")
chord <- chorddiag(
    nfdi_t3,
    # type = "bipartite",
    # width = 1000,
    # height = 1000,
    margin = 120,
    showGroupnames = TRUE,
    groupNames = NULL,
    groupColors = nfdi_group_colors,
    groupThickness = 0.1,
    groupPadding = 1,
    groupnamePadding =20,
    groupnameFontsize = 18,
    groupedgeColor = NULL,
    chordedgeColor = "#808080",
    categoryNames = NULL,
    categorynamePadding = 100,
    categorynameFontsize = 18,
    showTicks = F,
    tickInterval = 1,
    ticklabelFontsize = 10,
    fadeLevel = 0.1,
    showTooltips = TRUE,
    showZeroTooltips = TRUE,
    tooltipNames = NULL,
    tooltipUnit = NULL,
    tooltipFontsize = 20,
    tooltipGroupConnector = " <> ",
    precision = 2,
    clickAction = NULL,
    clickGroupAction = NULL
  )
  if (!require("plotly")) install.packages("plotly")
  library('plotly')
  nfdi_export_network_html <- paste(nfdi_section_name,"_nfdi_network","_4.html",sep="")
  htmlwidgets::saveWidget(as_widget(chord),nfdi_export_network_html)
  nfdi_export_network_png <- paste(nfdi_section_name,"_nfdi_network","_4.png",sep="")
  webshot::webshot(
    url = nfdi_export_network_html,
    file = nfdi_export_network_png,
    vheight = 1500,
    vwidth=1500,
  )
  nfdi_export_network_html <- paste(nfdi_section_name,"_nfdi_network","_5.html",sep="")
  simpleNetwork(nfdi_section,
    # width=1200,
    # height=800,
    linkDistance = 50,
    charge = -300,
    fontSize = 7,
    fontFamily = "Roboto",
    linkColour = "#808080",
    nodeColour = "#435FAC",
    opacity = 1,
    zoom = T
  ) %>%
   saveNetwork(file = nfdi_export_network_html)
}
nfdi_network(nfdi_edges_2019,"2019")
nfdi_network(nfdi_edges_2020,"2020")

system("mv 2019*.* 2019/")
system("mv 2020*.* 2020/")

print('R done')
