library(tidyr)
library(dplyr)

P_S=Pollution_bycity%>%
  gather(key="Pollutant", value="value", median_NO2, median_SO2, median_CO, median_O3)

P_Stop=P_S%>%group_by(.,Pollutant,City,State)%>%summarise(.,m=median(value))%>%
  group_by(.,Pollutant)%>%top_n(10,m)
P=P_S%>%filter(.,Pollutant == 'median_NO2')%>%filter(., City%in%P_Stop$City[which(P_Stop$Pollutant == 'median_NO2')])
(ggplot(P,aes(x=reorder(City,value,median),y=value))+geom_boxplot(aes(color=City)))


choice = 'SO2.AQI'

temp=str_sub(choice,start = 1, end = (str_length(choice)-4))
new=paste0('median_',temp)

table_by_city <- Pollution_bycity%>%
  group_by(.,State,City)%>%
  summarise(.,NO2 = sum(median_NO2),SO2 = sum(median_SO2), CO = sum(median_CO), O3 = sum(median_O3))

totals <- table_by_city%>%summarise(.,sum_NO2=sum(NO2),sum_SO2=sum(SO2),sum_CO=sum(CO),sum_O3=sum(O3))

New_Table=table_by_city%>%mutate(.,PC_NO2=NO2/sum(table_by_city$NO2),
                                 PC_SO2=SO2/sum(table_by_city$SO2),
                                 PC_O3=O3/sum(table_by_city$O3),
                                 PC_CO=CO/sum(table_by_city$CO))


Top_NO2=New_Table%>%arrange(.,desc(PC_NO2))%>%select(.,State,City,PC_NO2)%>%head(5)
Top_SO2=New_Table%>%arrange(.,desc(PC_SO2))%>%top_n(10)
Top_CO=New_Table%>%arrange(.,desc(PC_CO))%>%top_n(10)
Top_O3=New_Table%>%arrange(.,desc(PC_O3))%>%top_n(10)
(ggplot(Top_NO2,aes(x=PC_NO2))+geom_densitye(aes(color=City)))

