if(!require(leaflet)){
  install.packages("leaflet")
  library(leaflet)
}
library(leaflet)

function(input, output, session) {

  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })

  observe({
    
    yearIn <- input$year
    monthIn <- input$month
    filt_delays <- delays[(delays$Year == yearIn) & (delays$Month == monthIn),]
    
    colorData <- filt_delays[["average_delay"]]
    
    pal <- colorBin("Spectral", colorData, 12, pretty = TRUE)
   
    radius <-  filt_delays[["volumne"]] * 10000 * 0.75
    
    leafletProxy("map", data = filt_delays) %>% 
      clearShapes() %>%
      addCircles(~long, ~lat, radius=radius,
                 stroke=FALSE, fillOpacity=0.9, fillColor=pal(colorData)) %>%
      addLegend("bottomright", pal=pal, values=colorData, title="Average Flight Delay (minutes)", 
                layerId="colorLegend")
  })

  #### trial of pops
  
  # Show a popup of the zip code and probability of accident
  showZipcodePopup <- function(lat, lng) {
    
    yearIn <- input$year
    monthIn <- input$month
    filt_delays <- delays[(delays$Year == yearIn) & (delays$Month == monthIn),]
    
    selectedAirport <- filt_delays[(filt_delays$lat == lat) & (filt_delays$long == lng),]
    
    content <- as.character(tagList(
      
      tags$h5("Airport:", selectedAirport$airport),
      tags$h5("Average Arrival Delay (minutes):", round(selectedAirport$average_delay,digits=1)),
      tags$h5("IATA:", selectedAirport$iata),
      tags$h5("City:", selectedAirport$city),
      tags$h5("State:", selectedAirport$state)
      
    ))
    
    leafletProxy("map") %>% addPopups(lng, lat, content)
    
  }
  
  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    isolate({
      showZipcodePopup(event$lat, event$lng)
    })
  })
  
}
