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

ggplot(bubb35, aes(x=family, y=total_obs, size = number_of_taxa)) +
  geom_point(alpha=0.25) +
  scale_size(range = c(.1, 10), name="Taxa Observed") +
  theme(axis.text.x = element_text(angle = 45))

