
if (!require("circlize")) install.packages("circlize")
library('circlize')

if (!require("Cairo")) install.packages("Cairo")
library('Cairo')

nfdi_circle <- read.csv("2020/nfdi_edges_2020.csv",header = T, as.is = T)

Cairo::Cairo(
  30, #length
  30, #width
  file = paste("nfdi_chorddiagram", ".png", sep = ""),
  type = "png", #tiff
  # bg = "transparent", #white or transparent depending on your requirement
  bg = "white", #white or transparent depending on your requirement
  dpi = 600,
  units = "cm" #you can change to pixels etc
)

grid.col = c(NFDI4Microbiota = "red",
             DAPHNE4NFDI = "grey",
             DataPLANT = "grey",
             FAIRmat = "grey",
             GHGA = "grey",
             KonsortSWD = "grey",
             MaRDI = "grey",
             NFDIMatWerk = "grey",
             NFDINeuro = "blue",
             NFDI4Agri = "blue",
             NFDI4BioDiversity = "grey",
             NFDI4Cat = "grey",
             NFDI4Chem = "grey",
             NFDI4Culture = "grey",
             NFDI4DataScience = "blue",
             NFDI4Earth = "grey",
             NFDI4Health = "grey",
             NFDI4Immuno = "blue",
             NFDI4Ing = "grey",
             NFDI4Memory = "grey",
             NFDI4Microbiota = "grey",
             NFDI4Objects = "grey",
             NFDIxCS = "grey",
             PUNCH4NFDI = "grey",
             TextPlus = "grey",
             BERDatNFDI = "grey",
             NFDI4SD = "grey"
             )


chordDiagram(nfdi_circle,
             grid.col = grid.col,
             # row.col = c("#FF000080", "#00FF0010", "#0000FF10"),
             directional = 1, 
             direction.type = c("diffHeight", "arrows"),
             diffHeight = -mm_h(2),
             link.arr.type = "big.arrow",
             )
 

dev.off()
