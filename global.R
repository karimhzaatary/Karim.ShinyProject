library(dplyr)
library(lubridate)
library(tidyr)
# reading the CSV file
Pollution_test=read.csv('Pollution_test.csv',sep=",",stringsAsFactors = FALSE)
Pollution_test=Pollution_test%>%mutate(.,Date.Local=as.Date(Date.Local))
Pollution_bycity=read.csv('Pollution_bycity.csv',sep=",",stringsAsFactors = FALSE)
P_S=Pollution_bycity%>%
  gather(key="Pollutant", value="value", median_NO2, median_SO2, median_CO, median_O3)

P_Stop=P_S%>%group_by(.,Pollutant,City,State)%>%summarise(.,m=median(value))%>%
 group_by(.,Pollutant)%>%
  top_n(10,m)
print(P_Stop)

P_Stop1=P_S%>%group_by(.,Pollutant,City,State)%>%summarise(.,m=median(value))%>%
  group_by(.,Pollutant)%>%
  top_n(-10,m)


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