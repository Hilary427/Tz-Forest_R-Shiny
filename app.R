# Load Required Libraries 
library(shiny)      # Loads the Shiny package to build interactive web applications in R.
library(leaflet)   # Loads the Leaflet package,- to create interactive maps using the 'Leaflet' JavaScript library and the 'htmlwidgets' package.

# Building the UI (User Interface)

ui <- fluidPage(                                # fluidPage(): Creates a responsive layout that adjusts to the screen size.
  titlePanel("Tanzania Forest Reserves Map"),   # titlePanel(): Displays the title at the top of the app.
  leafletOutput(                                # leafletOutput("map", ...): Creates a placeholder in the UI where the Leaflet map will be rendered.  
    "map", 
    width = "100%", 
    height = "800px")
)

# Create Server Logic

server <- function(input, output, session) {    # Defines the server-side logic of the Shiny app - using default arguments to handle user input, output rendering, and session-specific data.
  output$map <- renderLeaflet({                 # renderLeaflet(): Tells Shiny to render a Leaflet map in the UI element with ID "map"
    leaflet() %>%                               # leaflet(): Initializes a new Leaflet map object.
      setView(lng = 35.09, lat = -6.13,         # setView(): Sets the initial center of the map to Tanzania (long 35.09, lat -6.13) with a zoom level of 7.
              zoom = 7) %>%
      # %>% pipe operator - chain of reaction: takes the output of the expression on its left and passes it as the first argument to the function on its right
      
      # Add the base layers
      addTiles(group = "OSM") %>%               # addTiles(): Adds the default OpenStreetMap tile layer
      addProviderTiles("Esri.WorldImagery",     # addProviderTiles(): Adds a satellite imagery layer from Esri.
                       # "Esri.WorldImagery" is a built-in provider in the {leaflet} package
                       group = "Imagery") %>%   # group = "Imagery": Names this layer for use in the layer control.
      
      
      # Add Web Map Service (WMS) Layer for Forest Reserves
      addWMSTiles(                                         # addWMSTiles(): Adds a Web Map Service (WMS) layer from a GeoServer.
        baseUrl = "https://geo-maa.utu.fi/geoserver/wms",  # baseUrl: The URL of the WMS server.
        layers = "tanzania_forest_reserves_2020",          
        options = WMSTileOptions(format = "image/png",     # WMSTileOptions(...): Sets options for the WMS layer
                                 transparent = TRUE),
        group = "Forest Reserves"
      ) %>%
      
      # Add Layer Control
      addLayersControl(                           # addLayersControl(): Adds a control box to the map to switch between base maps and toggle overlays.
        baseGroups = c("OSM", "Imagery"),         # baseGroups: Lists the base layers users can switch between.
        overlayGroups = c("Forest Reserves"),     # overlayGroups: Lists the overlays users can toggle on/off.
        options = layersControlOptions(           
          collapsed = FALSE)                      # collapsed = FALSE: Keeps the control panel expanded by default.
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)              # Combines the UI and server into a complete Shiny app and runs it.
