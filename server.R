library(shiny)
library(googleVis)
library(ggplot2)

function(input, output, session) {

  observe({
    cities <- unique(Pollution_test[Pollution_test$State==input$State,"City"])#[[1]]
    print(cities)
    print(cities[1])
    updateSelectizeInput(session,
                         inputId = "City",
                         choices=cities,
                         selected = cities[1])
  })
  
  observe({
    cities <- unique(Pollution_test[Pollution_test$State==input$state,"City"])#[[1]]
    print(cities)
    print(cities[1])
    updateSelectizeInput(session,
                         inputId = "city",
                         choices=cities,
                         selected = cities[1])
  })
  
  observe({
    cities <- unique(P_byyear[P_byyear$State==input$state1,"City"])#[[1]]
    print(cities)
    print(cities[1])
    updateSelectizeInput(session,
                         inputId = "city1",
                         choices=cities,
                         selected = cities[1])
  })

  
  CalendarPol <- reactive({
    Pollution_test %>% filter(., City==input$City, between(Date.Local,input$Date_range[1],input$Date_range[2])) %>% 
      select(.,Date.Local,input$Chemical)
    
    })
  Chemicals_bycity<-reactive({
    
    Pollution_bycity%>% filter(State == input$state, City==input$city) %>%
      gather(key="Pollutant", value="value", median_NO2, median_SO2, median_CO, median_O3)
    
    
  })
  Pollution_Annual<-reactive({
    P_byyear%>%filter(State == input$state1, City==input$city1,Pollutant == input$chemical1) 
      
})
   Pollution_Monthly=reactive({
     P_bymonth%>%filter(State == input$state1, City==input$city1,Pollutant == input$chemical1)})
    
  Values_bychemicaltop<-reactive({
   
    P_S%>%filter(.,Pollutant == input$chemicals)%>%filter(., City%in%P_Stop$City[which(P_Stop$Pollutant == input$chemicals)])
        
        })
          
  Values_bychemicalBottom<-reactive({
    # choice = input$chemical
    # temp=str_sub(choice,start = 1, end = (str_length(choice)-4))
    # new2=paste0('median_',temp)
    
    
    P_S%>%filter(.,Pollutant == input$chemicals)%>%filter(., City%in%P_Stop1$City[which(P_Stop1$Pollutant == input$chemicals)])
    
  })
  

  chosen_cities<-reactive({
  P_S5%>%filter(.,Pollutant == input$chemical)%>%filter(., City%in%P_S5$City[which(P_S5$Pollutant == input$chemical)])  
    
    
  })  
    
 
   
  output$AirQuality <- renderGvis({
    data <- CalendarPol()
    gvisCalendar(CalendarPol(),
                 datevar="Date.Local", 
                 numvar=input$Chemical,
                 options=list(
                   title="Daily Air Quality",
                   height=1200,
                   calendar="{yearLabel: { fontName: 'Times-Roman',
                   fontSize: 32, color: '#1A8763', bold: true},
                   cellSize: 10,
                   cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                   focusedCellColor: {stroke:'red'}}")
                 )
  })
   
  output$Boxplot_chemical <- renderPlot({
    
    ggplot(Chemicals_bycity(),aes(x=Pollutant,y=value))+geom_boxplot(aes(color=Pollutant))+labs(x="pollutant",y="Air Quality")+
   ggtitle("Pollution by chemical")
            
    })
  
   output$top_citiesBC=renderPlot({
      ggplot(Values_bychemicaltop(),aes(x=reorder(City,value,median),y=value))+geom_boxplot(aes(color=City))+labs(x="City",y="Air Quality")+ggtitle("Top Ten Polluted Cities")+coord_flip()
    
   })
   
   output$Bottom_citiesBC=renderPlot({
     ggplot(Values_bychemicalBottom(),aes(x=reorder(City,value,median),y=value))+geom_boxplot(aes(color=City))+labs(x="City",y="Air Quality")+ggtitle("Least Polluted Cities")+coord_flip()
     
   })
   output$chosen_cities=renderPlot({
     ggplot(chosen_cities(),aes(x=reorder(City,value,median),y=value))+geom_boxplot(aes(color=City))+labs(x="City",y="Air Quality")+ggtitle("Pollution in main cities")
     
   })
  
    output$Pollution_Annual=renderPlot({
      ggplot(Pollution_Annual(),aes(x=Year,y=value))+geom_point(aes(color=Year),position="jitter")+geom_smooth(method="lm")+
        labs(x="Year",y="Air Quality")+ggtitle("Evolution of Pollution over the years")+
      geom_hline(yintercept=50)
      })
    
     output$Pollution_bymonth=renderPlot({
      
       ggplot(Pollution_Monthly(),aes(x=Month,y=value))+geom_point(aes(color=Month),position="jitter")+geom_smooth(method="lm")+
         labs(x="Month",y="Air Quality")+ggtitle("Evolution of Pollution over the months")+
         geom_hline(yintercept=50)
     })
    
}
  
  
  
  

