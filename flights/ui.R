if(!require(leaflet)){
  install.packages("leaflet")
  library(leaflet)
}
library(leaflet)

months <- seq(1,12)
years <- seq(2000,2008)

navbarPage(
  title="IBM Data Science Experience", id="nav",

  tabPanel(
    div(class="outer",

      tags$head(
        # Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      leafletOutput("map", width="100%", height="100%"),

      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto", 

        h2("Choose year & month"),
        
        selectInput("year", "Year", years), 
        selectInput("month", "Month", months)

      ),

      tags$div(id="cite",'Data Scientists: Jorge Castañón, Oscar Lara, Shahab Sheikh, Jihyoung Kim',fontsize=20)
      
    )
  )
)
