library(dplyr)
library(lubridate)
library(tidyr)
# reading the CSV file
#Pollution_Test contains the daily values of air quality per day for each city in each state
Pollution_test=read.csv('Pollution_test.csv',sep=",",stringsAsFactors = FALSE)
Pollution_test=Pollution_test%>%mutate(.,Date.Local=as.Date(Date.Local))

#Pollution_by_city: air quality values per month of each year per city
Pollution_bycity=read.csv('Pollution_bycity.csv',sep=",",stringsAsFactors = FALSE)

#gathering the pollutant air quality (Pollution_4)
P_S=Pollution_bycity%>%
  gather(key="Pollutant", value="value", median_NO2, median_SO2, median_CO, median_O3)
#Getting the overall median for each city
#Modelling top 10 polluted cities by chemical
P_Stop=P_S%>%group_by(.,Pollutant,City,State)%>%summarise(.,m=median(value))%>%
 group_by(.,Pollutant)%>%
  top_n(10,m)
print(P_Stop)

#Getting the overall median for each city
#Modelling least 10 polluted cities by chemical
P_Stop1=P_S%>%group_by(.,Pollutant,City,State)%>%summarise(.,m=median(value))%>%
  group_by(.,Pollutant)%>%
  top_n(-10,m)


#choosing 5 cities and doing a boxplot:
 P_S5=P_S%>%filter(.,City%in%c('Boston','New York','Chicago','Los Angeles','Houston','Phoenix','Seattle','San Francisco'))%>%
  group_by(.,Pollutant,City,State)
 
 #Figuring out pollution by year for each city 
 P_byyear=P_S%>%group_by(.,Year)
 #Figuring out pollution monthly variations for each city
  P_bymonth=P_S%>%group_by(.,Month)
 



# checking city weight on totol pollution generated (2000-2010)
# table_by_city <- Pollution_bycity%>%
#     group_by(.,State,City)%>%
#     summarise(.,NO2 = sum(median_NO2),SO2 = sum(median_SO2), CO = sum(median_CO), CO3 = sum(median_O3))
# 
# totals <- table_by_city%>%summarise(.,sum_NO2=sum(NO2),sum_SO2=sum(SO2),sum_CO=sum(CO),sum_CO3=sum(CO3))
# 
# New_Table=New_table%>%mutate(.,PC_NO2=NO2/totals$sum_NO2,PC_SO2=SO2/totals$sum_SO2,PC_O3=NO2/totals$sum_O3,PC_CO=CO/totals$sum_CO)
# Top_NO2=New_Table%>%arrange(.,desc(PC_NO2))%>%top_n(10)
# Top_SO2=New_Table%>%arrange(.,desc(PC_SO2))%>%top_n(10)
# Top_CO=New_Table%>%arrange(.,desc(PC_CO))%>%top_n(10)
# Top_O3=New_Table%>%arrange(.,desc(PC_O3))%>%top_n(10)