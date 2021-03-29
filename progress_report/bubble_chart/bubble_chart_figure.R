library('RPostgreSQL')
library('ggplot2')
library('ggrepel')
library('grid')
library('gridExtra') 
library('dplyr')

#create connection object
con <- dbConnect(drv =PostgreSQL(), 
                 user="aaronwells", 
                 password="waLatKa08mNts#",
                 host="localhost", 
                 port=5435, 
                 dbname="flora_of_csp")



#query the database and store the data in datafame
bubb <- dbGetQuery(con, "SELECT * from public.count_of_family_bubble_chart_view;")
dim(bubb)

bubb35 <- bubb[1:35,]

bubb35$family <- reorder(bubb35$family, -bubb35$sort_order)


height <- 4
width <- 5.5
resize <- 1.5
hghts <- c(3, 5)

p <- ggplot(bubb35, aes(x=family, y=total_obs, size = as.factor(number_of_taxa_rank),fill = category)) +
  geom_point(aes(fill = as.factor(category)), shape = 21) +
  scale_size_manual(values = c(3, 6, 9), labels = c("<10", "10 to 30", ">30")) +
  theme_bw() +
  labs(x = "Taxonomic Family",y = "Number of Observations") +
  scale_fill_manual(values = c("#0AB45A", "#FA78FA", "#000000", "#A1A1A1", "#F0F032", "#FAE6BE", "#AA0A3C")) +
  #scale_size(range = c(.1, 10), name="Taxa Observed") +
  theme(axis.text.x = element_text(angle = 45,vjust = 1,hjust = 1)) 

p1 <- p + labs(size = "Taxa Observed",fill = 'Category')

pdf(file = "Fig_Family_Bubble_Chart_9x6pnt5.pdf", width = 9, height = 6.5)

print(p1)

dev.off()