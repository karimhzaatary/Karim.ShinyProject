library(dplyr)
library(lubridate)
library(tidyr)
# reading the CSV file
 Pollution=read.csv('~/pollution_us_2000_2016.csv')
# 1.Pollution contains readings for N02,CO,SO2 and CO air pollution in US cities between 2000 and 2010.
# transforming Date column into "Date type"
 Pollution=Pollution%>%
   mutate(.,Date.Local=mdy(Date.Local))
 # Extracting Month and year
 Pollution_1=Pollution%>%
   mutate(.,Month=month(Date.Local))
 Pollution_1=Pollution_1%>%
   mutate(.,Year=year(Date.Local))
 #Eliminating the code columns
 Pollution_2=Pollution_1%>%select(.,-c(State.Code,County.Code,Address,Site.Num,County,SO2.Units,CO.Units,NO2.Units,O3.Units)) 
#  We are left with state,city and chemical data
# The mean and air quality concentration values for NO2 and O3 are available (4 values per day).AQI values for SO2 and CO are missing.
# Linear regression to find missing air qualities (SO2 & CO)
 Pollution_3 <- Pollution_2 %>%
      mutate(.,
             CO.Mean=if_else(is.na(CO.AQI),NaN,CO.Mean),
             SO2.Mean=if_else(is.na(SO2.AQI),NaN,as.double(SO2.Mean)))
 
 fit_CO = lm(Pollution_3$CO.AQI~Pollution_3$CO.Mean)
 fit_SO2=lm(Pollution_3$SO2.AQI~Pollution_3$SO2.Mean)
 Pollution_2 <- Pollution_2 %>%
   mutate(.,
          CO.AQI=if_else(is.na(CO.AQI),17.35*CO.Mean-0.33,as.double(CO.AQI)),
          SO2.AQI=if_else(is.na(SO2.AQI),3.4896*SO2.Mean+0.94,as.double(SO2.AQI)))

#grouping pollution air qulity values by State,city and Date
 Pollution_3 <-Pollution_2 %>%
   group_by(.,State,City,Date.Local,Month,Year)%>%
   summarise_at(.,c("NO2.Mean","NO2.AQI",
                    "O3.Mean","O3.AQI",
                    "SO2.Mean","SO2.AQI",
                    "CO.Mean","CO.AQI"),mean,na.rm=TRUE)#%>%
  summarise_at(.,c("NO2.1st.Max.Value","SO2.1st.Max.Value","CO.1st.Max.Value","O3.1st.Max.Value",
                 "NO2.1st.Max.Hour","O3.1st.Max.Hour",'SO2.1st.Max.Hour',"CO.1st.Max.Hour"),max,rm.na=T)
  Pollution_3=Pollution_3%>%filter(.,City!="Not in a city")

write.csv(Pollution_3,'Pollution_test.csv')
# graphing macro trend

# group air quality variants by median and plot over the years (Pollution_4 is the values of air pollution by month of each year)
  library(ggplot2)
 Pollution_4=Pollution_3%>%group_by(.,State,City,Year,Month)%>%summarise(.,median_NO2=median(NO2.AQI),
                                                                         median_SO2=median(SO2.AQI),
                                                                         median_CO=median(CO.AQI),
                                                                         median_O3=median(O3.AQI))
 
 Pollution_4=Pollution_4%>%filter(.,City!="Not in a city")
 # Trend for each city (all chemicals) 
   # Cities Chosen (NY,LA,Pheonix,SF,Boston)
 library(reshape2)
 G_NY=Pollution_4%>%filter(.,City=="New York")
 G_LA=Pollution_4%>%filter(.,City=="Los Angeles")
 G_Pheonix=Pollution_4%>%filter(.,City=="Pheonix")
 G_SF=Pollution_4%>%filter(.,City=="San Francsico")
 G_Boston=Pollution_4%>%filter(.,City=="Boston")

 G_NY <- melt(G_NY,id.vars='City', measure.vars=c('median_NO2','median_SO2','median_CO', 'median_O3'))
  (ggplot(G_NY) +
   geom_boxplot(aes(x=City, y=value, color=variable))+labs(title='Air Quality Median distribution', 
                                                            x='NewYork', 
                                                            y='Air Quality')+theme_bw())
 
 G_LA= melt(G_LA,id.vars='City', measure.vars=c('median_NO2','median_SO2','median_CO', 'median_O3'))
 
 (ggplot(G_LA) +geom_boxplot(aes(x=City, y=value, color=variable))
   +labs(title='Air Quality Median distribution', x='Los Angeles', y='Air Quality')+theme_bw())
 
 G_Boston= melt(G_Boston,id.vars='City', measure.vars=c('median_NO2','median_SO2','median_CO', 'median_O3'))
 
 (ggplot(G_Boston) +geom_boxplot(aes(x=City, y=value, color=variable))
   +labs(title='Air Quality Median distribution', x='Los Angeles', y='Air Quality')+theme_bw())
 

 write.csv(Pollution_4,'Pollution_bycity.csv')
 
  
 #Plot of top 10 polluted cities(NO2)
 Pollution_5=Pollution_4%>%
    select(.,State,City,median_NO2)%>%
    group_by(.,City)%>%summarise(.,m=median(median_NO2))%>%arrange(.,desc(m))%>%top_n(10)
  Pollution_6=Pollution_4%>%filter(.,City%in%Pollution_5$City)
  (g2=ggplot(Pollution_6,aes(x=City,y=median_NO2))+geom_boxplot()+labs(x="cities",y="NO2 Air quality",title="Air quality N02 for top 20 polluted cities")   
  )+coord_flip()       
  Pollution_7=Pollution_4%>%
    select(.,State,City,median_NO2)%>%
    group_by(.,City)%>%summarise(.,m=median(median_NO2))%>%arrange(.,(m))%>%top_n(-10)
  #Plot of least 10 polluted cities(NO2)
  Pollution_7=Pollution_4%>%filter(.,City%in%Pollution_7$City)
  (g3=ggplot(Pollution_7,aes(x = reorder(City,median_NO2),y=median_NO2))+geom_boxplot()
  +labs(x="cities",y="NO2 Air quality",title="Air quality N02 for least polluted cities")   
  )+coord_flip()
  
  #plot for some cities (Boxplot)
  Polluted=Pollution_4%>%select(.,State,City,Year,Month,median_NO2,median_SO2,median_O3,median_CO)%>%
    filter(.,City%in%c("New York","Boston","Los Angelos","Pheonix","Seattle","Miami","Houston","Chicago","Denver","Washington"))
  
(g_main=ggplot(Polluted)+geom_boxplot(aes(x=reorder(City,median_NO2),y=median_NO2)))+coord_flip()
 
  #Scatter plot time series
  
  (g_scatter=ggplot(Pollution_4,aes(x=Year,y=value)+geom_point(aes(color=City),position="jitter"))+geom_smooth(method="lm"))

  
  

