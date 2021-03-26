library('RPostgreSQL')
library('ggplot2')
library('ggrepel')
library('grid')
library('gridExtra') 

#create connection object
con <- dbConnect(drv =PostgreSQL(), 
                 user="aaronwells", 
                 password="waLatKa08mNts#",
                 host="localhost", 
                 port=5435, 
                 dbname="flora_of_csp")



#query the database and store the data in datafame
donutd <- dbGetQuery(con, "SELECT * from public.taxa_by_lifeform_donut_chart_view ;")
dim(donutd)

donutd$percentage = round((donutd$count / sum(donutd$count))*100,1) #calc. percentage

# Compute the cumulative percentages (top of each rectangle)
donutd$ymax <- cumsum(donutd$percentage)

# Compute the bottom of each rectangle
donutd$ymin <- c(0, head(donutd$ymax, n=-1))

# Compute label position
donutd$labelPosition <- (donutd$ymax + donutd$ymin) / 2

# Compute a good label
donutd$label <- paste0(donutd$percentage,"%")

cbPalette <- c("#009E73","#F0E442","#56B4E9","#0072B2","#CC79A7","#7F00FF","#D55E00","#E69F00","#CC0000","#999999","#000000")


donutd$Lifeform<-as.factor(donutd$Lifeform)

donutd$Lifeform <- reorder(donutd$Lifeform, donutd$sort_order)


names(cbPalette) <- donutd$Lifeform

p <- ggplot(donutd, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Lifeform)) +
  geom_rect() +
  #geom_text( x=5, aes(y=labelPosition, label=label, color=Lifeform), size=6) + # x here controls label position (inner / outer)
  geom_label_repel(aes(label = label, x = 4, y = (ymin + ymax)/2),inherit.aes = F, show.legend = F, size = 3.5) +
  scale_fill_manual(values = cbPalette) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none")

p1 <- p + scale_color_manual(name = "Lifeform",breaks = c("Coniferous Tree","Deciduous Tree","Low or Tall Shrub","Dwarf Shrub","Forb","Graminoid","Spore-bearing","Moss","Liverwort","Lichen","Fungi"), values = c("Coniferous Tree" = "#009E73","Deciduous Tree" = "#F0E442","Low or Tall Shrub" = "#56B4E9","Dwarf Shrub" = "#0072B2","Forb" = "#CC79A7","Graminoid" = "#7F00FF","Spore-bearing" = "#D55E00","Moss" = "#E69F00","Liverwort" = "#CC0000","Lichen" = "#999999","Fungi" = "#000000")) 

print(p1)

legend <- cowplot::get_legend(p)

grid.newpage()
grid.draw(legend)

#legend not printing in donut chart plot
#create barchart first with legend, snip out legend
#then create donut chart
# combine later in GIMP
p <- ggplot(donutd, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Lifeform)) +
  geom_rect() +
  scale_fill_manual(values = cbPalette) +
  #geom_text( x=5, aes(y=labelPosition, label=label, color=Lifeform), size=6) + # x here controls label position (inner / outer)
  geom_label_repel(aes(label = label, x = 4, y = (ymin + ymax)/2),inherit.aes = F, show.legend = F, size = 3.5) +
  #scale_fill_manual(values = cbPalette) +
  coord_polar(theta="y") +
  xlim(c(-1, 4)) +
  theme_void() +
  theme(legend.position = "none")

p1 <- p + scale_color_manual(name = "Lifeform",breaks = c("Coniferous Tree","Deciduous Tree","Low or Tall Shrub","Dwarf Shrub","Forb","Graminoid","Spore-bearing","Moss","Liverwort","Lichen","Fungi"), values = c("Coniferous Tree" = "#009E73","Deciduous Tree" = "#F0E442","Low or Tall Shrub" = "#56B4E9","Dwarf Shrub" = "#0072B2","Forb" = "#CC79A7","Graminoid" = "#7F00FF","Spore-bearing" = "#D55E00","Moss" = "#E69F00","Liverwort" = "#CC0000","Lichen" = "#999999","Fungi" = "#000000")) 

print(p1)
