library(shiny)
library(dplyr)
library(leaflet)
library(plotly)



#reading the Salary_data_each_year.csv 
salary_data<-read.csv('Salary_data_each_year.csv')
#ds salaries
cleaned_data<-read.csv('ds_salaries.csv')

lat_values<-list()
lon_values<-list()

countries<-read.csv('world-administrative-boundaries.csv',sep=';')
countries<-countries[c('Geo.Point','ISO.3166.1.Alpha.2.Codes','English.Name')]
colnames(countries)<-c('geo_point','Country','english_name')
new_data<-countries %>% filter(Country %in% unique(salary_data$Country))
data<-merge(new_data,salary_data,by='Country')
for (value in 1:length(data$geo_point)){
  values<-str_split(data$geo_point[value],',')
  lat<-as.double(values[[1]][1])
  lon<-as.double(values[[1]][2])
  lat_values<-append(lat_values,lat)
  lon_values<-append(lon_values,lon)
}
data$latitude=lat_values
data$longitude=lon_values

data_2020<-data %>% filter(Avg.Salary.2020!=0.00)
data_2021<-data %>% filter(Avg.Salary.2021!=0.00)
data_2022<-data %>% filter(Avg.Salary.2022!=0.00)

if (interactive()){
  ui<-fluidPage(
    titlePanel("Scope and salaries of various IT roles during 2020 to 2022"),
    sidebarLayout(
      sidebarPanel(
        position='left',
        textOutput('side_text'),
        h4('Main tab'),
        textOutput('main_text'),
        h4('Explore tab'),
        textOutput('explore_text'),
        width=3
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Main",
                             radioButtons('year','Select the year:',
                                          c('2020','2021','2022'),inline = TRUE),
                             leafletOutput('world_map'),
                             selectInput('country_inp','Select the country:',
                                         choices=unique(data$english_name)),
                             actionButton('button','Go')),
                    tabPanel("Explore",
                             textOutput('country_name_dis'),
                             plotlyOutput('explore_plot')
                             
                    )
        )
      )
    )
  )
  
  #defining the server
  server<-function(input,output,session){
    output$main_text<-renderText('In this main tab, use of radio buttons that will 
    help the user to select the year, 
    which will be the main that visualizes the 
    leaflet map that returns the world map, this will shows the 
    exact locations of the countries. This is completely interactive
    which will the user to zoom in/out. At the bottom, there will be a select option tool
                                 to select the country name which will need a button to load the data
                                 for the initial plot.')
    
    output$explore_text<-renderText('In the explore tab, there will be a bar-chart 
                                    plotted using plotly library. This will make the user to 
                                    point out the bar in the plot to get the average salary. 
                                    ')
                                 
    
    output$side_text<-renderText('This project is made to visualize the relation of IT job 
                   roles and the salaries paid. There are three main aspects used to narrate
                   to visualize. 1 - Spatial data to point out the countries,
                   2 - Average covid 19 cases, 3 - Average salary for a particular job role.' 
                  )
      observeEvent(input$button, {
      output$country_name_dis<-renderText({
        paste('Country name: ', input$country_inp)
      })
      
      
      
      output$explore_plot <- renderPlotly({
        country_code=unique(data.frame(data %>% filter(english_name == input$country_inp))$Country)
        year_data<-cleaned_data %>% filter(work_year==input$year,company_location==country_code)
        modified_data<-year_data %>% group_by(job_title) %>% summarise(avg_salary = mean(salary_in_usd))
        if (length(modified_data$job_title)>0){
          plot_ly(x = modified_data$job_title, y = modified_data$avg_salary, type = 'bar',
                  title=paste('Country name: ',input$country_inp))
        }
        
      })
      
    })
    
    
    
    ####
    output$world_map <- renderLeaflet({
      if (input$year=='2020'){
        updateSelectInput(session, "country_inp",
                          label = 'Select the country: ',
                          choices = data_2020$english_name)
        leaflet() %>% 
          addTiles() %>%
          addMarkers(lng=as.double(data_2020$longitude),lat = as.double(data_2020$latitude),
                     popup=paste('Country name: ',data_2020$english_name,
                                 '<br/>','Average covid cases: ',
                                 data_2020$'X2020.Covid.19.Average.cases',
                                 '<br/>','Average salary: '
                                 ,round(data_2020$Avg.Salary.2020,2),' $'))
      }
      else if (input$year=='2021'){
        updateSelectInput(session, "country_inp",
                          label = 'Select the country: ',
                          choices = data_2021$english_name)
        leaflet() %>% 
          addTiles() %>%
          addMarkers(lng=as.double(data_2021$longitude),lat = as.double(data_2021$latitude),
                     popup=paste('Country name: ',data_2021$english_name,
                                 '<br/>','Average covid cases: ',
                                 data_2021$'X2021.Covid.19.Average.cases',
                                 '<br/>','Average salary: '
                                 ,round(data_2021$Avg.Salary.2021,2),' $'))
      }
      
      else if (input$year=='2022'){
        updateSelectInput(session, "country_inp",
                          label = 'Select the country: ',
                          choices = data_2022$english_name)
        leaflet() %>% 
          addTiles() %>%
          addMarkers(lng=as.double(data_2022$longitude),lat = as.double(data_2022$latitude),
                     popup=paste('Country name: ',data_2022$english_name,
                                 '<br/>','Average covid cases: ',
                                 data_2022$'X2022.Covid.19.Average.cases',
                                 '<br/>','Average salary: '
                                 ,round(data_2022$Avg.Salary.2022,2),' $'))
      }
      
    })
    
    
    
    
  }
  
  #running the application
  
  shinyApp(ui = ui, server = server)
}


