#set the working directory
getwd()
setwd("G:/Fall 2020/George Mason University/STAT -515")
getwd()

#Install the necessary packages
#install.packages("rgeos")
library(rgeos)
library(maptools)
library(leaflet)
library(rgdal)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(plotly)
library(hrbrthemes)
library(viridis)
library(maps)
library(stringr)
#Read in the Shape file
NYmap <- readOGR("G:/Fall 2020/George Mason University/AIT 580/Chapter 9 IDMA/NYS_Civil_Boundaries","Counties")
plot(NYmap)

#Read Census Data into a variable
Census <- read.csv('Census_2000_and_2010_Population__Villages.csv', header=TRUE)
Census
colnames(Census) <- c("Geographic Area","Population2000",
                      "Population2010","Population Change Number",
                      "Population Change Percent","SUMLEV","State","County" ,
                      "SubCounty","Place","FuncStat")
View(Census)

#Map the Geographic area data with the shapefile data
View(NYmap)
class(NYmap) #Spatial Polygon Dataframe
summary(NYmap)
#NAMES Column in NYmap corresponds to County column in the dataset
NYmap$NAME
Census$County
#group by County

Census_grp <- Census %>% group_by(County) %>%
summarise(tot_pop_by_county = sum(Population2000))
View(Census_grp)

NYmap$NAME  
Census_grp$County  

#To find out if there is a difference between the two character vectors
setdiff(Census_grp$County,NYmap$NAME)

Census_grp$County <- Census_grp$County %>%
  gsub(' & Steuben','',.)

Census_grp$County <- Census_grp$County %>%
  gsub(' & Erie','Cattaragus',.)
  
Census_grp$County <- Census_grp$County %>%  
  gsub('cattaraugus','Cattaragus',.)

Census_grp$County <- Census_grp$County %>%    
  gsub('chenango','Chenango',.)

Census_grp$County <- Census_grp$County %>%  
  gsub('Chenango & Madison','Chenango',.)

Census_grp$County <- Census_grp$County %>%  
  gsub(' & Herkimer','Fulton',.)
  
Census_grp$County <- Census_grp$County %>%  
  gsub('Genesee & Wyoming','Genesse',.)

Census_grp$County <- Census_grp$County %>%
  gsub('ontario','Ontario',.)

Census_grp$County <- Census_grp$County %>%
  gsub('Ontario & Yates','Ontario',.)

Census_grp$County

setdiff(Census_grp$County,NYmap$NAME)
NYmap$NAME
Census_grp$County

Census_grp <- Census_grp %>% group_by(County) %>%
  summarise(tot_pop_by_county = sum(tot_pop_by_county))
View(Census_grp)

Census_grp$County <- Census_grp$County %>%  
  gsub('Genesee','Genesse',.)

Census_grp$County <- Census_grp$County %>%  
  gsub('FultonFulton','Fulton',.)

Census_grp$County <- Census_grp$County %>%  
  gsub('Cattaragus','Cattaraugus',.)

Census_grp$County <- Census_grp$County %>%  
  gsub('CattaraugusCattaraugus','Cattaraugus',.)

Census_grp <- Census_grp %>% group_by(County) %>%
  summarise(tot_pop_by_county = sum(tot_pop_by_county))
View(Census_grp)

setdiff(Census_grp$County,NYmap$NAME)
NYmap$NAME
#Genesee, St Lawrence
Census_grp$County <- Census_grp$County %>%  
  gsub('Genesse','Genesee',.)

Census_grp$County <- Census_grp$County %>%  
  gsub('St. Lawrence','St Lawrence',.)

#This should be a null value, so the Spatial dataframe and the dataframe match
setdiff(Census_grp$County,NYmap$NAME) 

#Add Missing values as NA since data is not available for them
nrow(Census_grp)
Census_grp[nrow(Census_grp) + 1,] = list("Bronx", NA)
Census_grp[nrow(Census_grp) + 1,] = list("Kings",NA)
Census_grp[nrow(Census_grp) + 1,] = list("Richmond",NA)
Census_grp[nrow(Census_grp) + 1,] = list("Queens",NA)
View(Census_grp)
#map the data from one vector into the other
NYmap$NAME <- Census_grp$County
View(NYmap$NAME)

#Create the choropleth map of population in 2000

NYmap_proj <- spTransform(NYmap, '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')

leaflet() %>%
  addTiles() %>%
  #setView(40,79,4) %>%
  addPolygons(data = NYmap_proj,
    stroke = TRUE, 
    color = 'blue', 
    weight = 1.5, 
  )
#Add labels
mylabels <- paste(
  "County: ", NYmap$NAME, "<br/>",
  "Population on April 1st 2000: ", Census_grp$tot_pop_by_county, "<br/>"
  ) %>%
  lapply(htmltools::HTML)
#plug the labels into leaflet code
leaflet()%>%
  addTiles()%>%
  addPolygons(data = NYmap_proj,
              stroke = TRUE,
              color = 'blue',
              weight = 1.5,
              label = mylabels,
              labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), 
                                          textsize = "13px", 
                                          direction = "auto"))
#Add colors
map_color <- colorFactor(topo.colors(16),unique(Census_grp$tot_pop_by_county))

#Plug it in the leaflet code
plot_2000 <- leaflet()%>%
  addTiles()%>%
  addPolygons(data = NYmap_proj,
              fillColor = ~map_color(Census_grp$tot_pop_by_county),
              stroke = TRUE,
              color = 'blue',
              weight = 1.5,
              label = mylabels,
              labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), 
                                          textsize = "13px", 
                                          direction = "auto")) 

plot_2000 
#==============================================================================#
#Compare 2010 Population
Census_grp_2010 <- Census %>% group_by(County) %>%
  summarise(tot_pop_by_county_2010 = sum(Population2010))
View(Census_grp_2010)
#Data Cleaning
#To find out if there is a difference between the two character vectors
setdiff(Census_grp_2010$County,NYmap$NAME)

Census_grp_2010$County <- Census_grp_2010$County %>%
  gsub(' & Steuben','',.)

Census_grp_2010$County <- Census_grp_2010$County %>%
  gsub(' & Erie','Cattaragus',.)

Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub('cattaraugus','Cattaragus',.)

Census_grp_2010$County <- Census_grp_2010$County %>%    
  gsub('chenango','Chenango',.)

Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub('Chenango & Madison','Chenango',.)

Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub(' & Herkimer','Fulton',.)

Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub('Genesee & Wyoming','Genesse',.)

Census_grp_2010$County <- Census_grp_2010$County %>%
  gsub('ontario','Ontario',.)

Census_grp_2010$County <- Census_grp_2010$County %>%
  gsub('Ontario & Yates','Ontario',.)

Census_grp_2010$County

setdiff(Census_grp_2010$County,NYmap$NAME)
NYmap$NAME
Census_grp_2010$County

Census_grp_2010 <- Census_grp_2010 %>% group_by(County) %>%
  summarise(tot_pop_by_county_2010 = sum(tot_pop_by_county_2010))
View(Census_grp_2010)

Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub('Genesee','Genesse',.)

Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub('FultonFulton','Fulton',.)

Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub('Cattaragus','Cattaraugus',.)

Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub('CattaraugusCattaraugus','Cattaraugus',.)

Census_grp_2010 <- Census_grp_2010 %>% group_by(County) %>%
  summarise(tot_pop_by_county_2010 = sum(tot_pop_by_county_2010))
View(Census_grp_2010)

setdiff(Census_grp_2010$County,NYmap$NAME)
NYmap$NAME
#Genesee, St Lawrence
Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub('Genesse','Genesee',.)

Census_grp_2010$County <- Census_grp_2010$County %>%  
  gsub('St. Lawrence','St Lawrence',.)

#This should be a null value, so the Spatial dataframe and the dataframe match
setdiff(Census_grp_2010$County,NYmap$NAME) 

#To add missing values in the dataset with NA
nrow(Census_grp_2010)
Census_grp_2010[nrow(Census_grp_2010) + 1,] = list("Bronx", NA)
Census_grp_2010[nrow(Census_grp_2010) + 1,] = list("Kings",NA)
Census_grp_2010[nrow(Census_grp_2010) + 1,] = list("Richmond",NA)
Census_grp_2010[nrow(Census_grp_2010) + 1,] = list("Queens",NA)
View(Census_grp_2010)
#map the data from one vector into the other
NYmap$NAME <- Census_grp_2010$County
View(NYmap$NAME)

#Create the choropleth map of population in 2010
map_color2 <- colorFactor(topo.colors(16),unique(Census_grp_2010$tot_pop_by_county_2010))

#Add labels
mylabels2 <- paste(
  "County: ", NYmap$NAME, "<br/>",
  "Population on April 1st 2010: ", Census_grp_2010$tot_pop_by_county_2010, "<br/>"
) %>%
  lapply(htmltools::HTML)

plot2010 <- leaflet()%>%
  addTiles()%>%
  addPolygons(data = NYmap_proj,
              fillColor = ~map_color2(Census_grp_2010$tot_pop_by_county_2010),
              stroke = TRUE,
              color = 'blue',
              weight = 1.5,
              label = mylabels2,
              labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), 
                                          textsize = "13px", 
                                          direction = "auto"))
plot2010

#Trend in population from 2000 to 2010

pop2000 <- ggplot(Census_grp, aes(County,tot_pop_by_county/1000000))+
  geom_bar(color = "blue", stat = "identity")+
  scale_fill_brewer(palette = "Set1")+
  labs(x = 'County', y = 'Population in 2000',title = 'Population on the State of New York in the year 2000')+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust =1))
pop2000

View(Census_grp_2010)
pop2010 <- ggplot(Census_grp_2010, aes(County,tot_pop_by_county_2010/1000000))+
  geom_bar(color = "blue", stat = "identity")+
  scale_fill_brewer(palette = "Set1")+
  labs(x = 'County', y = 'Population in 2010',title = 'Population on the State of New York in the year 2010')+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
pop2010

#Populous Cities or Villages

#install.packages("hrbrthemes")

NY <- map_data("county", "new york")
View(NY)
NY <- NY[!duplicated(NY$subregion), ]
View(NY)

NY$subregion <- str_to_title(NY$subregion)
colnames(NY) <- c("long","lat","group","order","region","County") 
#Combine two dataframes
Census_grp <- inner_join(Census_grp,NY, by = "County")
View(Census_grp)

Census_grp <- Census_grp %>%
  arrange(tot_pop_by_county) %>%
  mutate( name=factor(County, unique(County))) %>%
  mutate( mytext=paste(
    "County: ", County, "\n", 
    "Population: ", tot_pop_by_county, sep="")
  )

bmap <- ggplot() +
  geom_polygon(data = NYmap_proj, aes(x = long, y = lat, group = group),fill="grey", alpha=0.5) +
  geom_point(data = Census_grp,aes(x= long, y= lat,size = tot_pop_by_county/1000000,color = tot_pop_by_county/1000000))+
  coord_map()


bmap

#2010 
Census_grp_2010 <- inner_join(Census_grp_2010,NY, by = "County")
View(Census_grp_2010)
Census_grp_2010 <- Census_grp_2010 %>%
  arrange(tot_pop_by_county_2010) %>%
  mutate( name=factor(County, unique(County))) %>%
  mutate( mytext=paste(
    "County: ", County, "\n", 
    "Population: ", tot_pop_by_county_2010, sep="")
  )
bmap2010 <- ggplot() +
  geom_polygon(data = NYmap_proj, aes(x = long, y = lat, group = group),fill="grey", alpha=0.5) +
  geom_point(data = Census_grp_2010,aes(x= long, y= lat,size = tot_pop_by_county_2010/1000000,color = tot_pop_by_county_2010/1000000))+
  coord_map()


bmap2010

#Population Projection  - Linear Regression to determine population of New York County
#display all pair-wise relationships, then choose the pair(s) that
# seem the most interesting

Census_LM <- select(Census, c("Population2000","Population2010","Population Change Number", "Population Change Percent"))
pairs(Census_LM)

plot(Census_LM$Population2000 , Census_LM$Population2010)
title(main = 'Relationship between Population in 2000 vs Population in 2010')
plot(Census_LM$Population2000 , Census_LM$`Population Change Number`)
title(main = 'Relationship between Population in 2000 vs Population Change Number')
plot(Census_LM$Population2000 , Census_LM$`Population Change Percent`)
title(main = 'Relationship between Population in 2000 vs Population Change Percent')
# Create and show a linear model (lm) of the relationship
Year <- c(2000,2010)
PopulationNYCounty <- c(8008686,8175133)
#Create a dataframe with these observations
Pop <- data.frame(Year, PopulationNYCounty)
View(Pop)
#Predictor Variable - Year -- x
#Response Variable - Population -- y
model1 <- lm(PopulationNYCounty ~ Year, data = Pop)
model1
# Display the summary stats for the relationship
summary(model1)
x = Pop$Year
print(x)
y = Pop$PopulationNYCounty
print(y)
plot(x,y,col = "blue",main = "Population of New York County",
     abline(lm(y~x)),cex = 1,pch = 1,xlab = "Years",ylab = "Population in Million")
#Predict population till 2022
prediction <- predict(model1, data.frame(Year = c(2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022)))

prediction
#Add the predicted values to the dataframe
Pop_new = rbind(Pop, data.frame("Year" = c(2011:2022), "PopulationNYCounty" = c(prediction[1:12])))
Pop_new
#Fit a linear regression line
ggplot(Pop_new, ylim=c(20000000,40000000),aes(Year, PopulationNYCounty))+
  geom_point()+
  geom_smooth(method = lm, se = FALSE)+
  labs(X = "Years", y = "Population")+
  labs(title = "New York County Population from 2000 to 2022")+
  theme(plot.title = element_text(hjust = 0.5))
  