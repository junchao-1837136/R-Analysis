library("shiny")
library("ggplot2")
library("plotly")
library("lintr")
library('rsconnect')


# table needed for the 3rd page -- Allan Ji

data3 <- read.csv("data/GlobalLandTemperaturesByCountry.csv")
# data3$Country[data3$Country == "脜land"] <- "Åland"
# data3$Country[data3$Country == "C么te D\'Ivoire"] <- "Côte D'Ivoire"
# data3$Country[data3$Country == "Cura莽ao"] <- "Curaçao"
# data3$Country[data3$Country == "Saint Barth茅lemy"] <- "Saint Barthélemy"
distinct_countries <- data3 %>%
  distinct(Country)

# -----------------------------------------

intro_tab <- tabPanel(
  "Introduction",
  includeCSS("style.css"),
  
  verticalLayout(
    fluidPage(
      div(img(src = "image_environment.jpg", 
              height = "65%", width = "65%", 
              align = "center"),
          style="text-align: center;")
    ),
    
    p(),
    
    textOutput(
      outputId = "intro"
    )
   
  )

  
  
)

# ---------------tab 1---------------------------

tab1 <- tabPanel(
  "Global Map",

  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "year",
        label = "Choose the Year",
        value = 1900,
        min = 1850,
        max = 2010

      ),

      p("( The map need some time to load. Please wait for a while. )")

    ),

    mainPanel(
      plotlyOutput(
        outputId = "map"
      )
    )
  ),

  fluidPage(
    h2("Description"),
    p("In this map, the global average tempertature are largely depend
      on the latitude of each country."),
    p("In the same latitude, the average
      temperature of USA is around 9.02 Celsius, which is 3 Celsius higher than
      that of China in 1900. The average temperture of countries in central
      Asia are all above 10 Celsius.")
  )
)

# ---------------tab 2---------------------------
sidebar2 <- sidebarPanel(
  selectInput(
    "y_var",
    label = "Choose the Data",
    choices = list(
      "Average Land Temperature" = "avg_temp",
      "Average Land Max Temperature" = "avg_max",
      "Average Land Min Temperature" = "avg_min"
    ),
    selected = "Average Land Temperature"
  ),
  sliderInput(
    "starting_year",
    label = "Choose the Starting Year",
    min = 1850,
    max = 2010,
    value = 1900
  )
)

descrip2 <- fluidPage(
  h2("Description"),
  p("This helps you generate a scartter plot showing the world temperature change from
    a certain year to 2015. You can use the list to choose the data you want to draw,
    including average land temperature, average land max temperature, and average land
    min temperature. And you can use the slider to choose the starting year that you
    are interested to see.")
)

main2 <- mainPanel(
  plotlyOutput(outputId = "scatter")
)

tab2 <- tabPanel(
  "World Temperature Change Trend",
  sidebarLayout(
    sidebar2,
    main2
  ),
  descrip2
)


# -------------------------Page 3----------------------------- 

plot_sidebar3 <- sidebarPanel(
  selectInput(
    inputId = "country3",
    label = "Country",
    choices = distinct_countries,
    selected = "Africa"
  ),
  sliderInput(
    "year3",
    "Year",
    min = 1750,
    max = 2010,
    value = c("1750", "2010"),
    step = 10
  )
)

plot_main3 <- mainPanel(
  plotlyOutput(outputId = "TemperaturePlot")
)

text3 <- fluidPage(
  includeCSS("css.css"),
  h2("Description"),
  p("You can use the list and the slider to choose how the pattern of average temperature looks 
    like in a particular country and time interval. Therefore you can easily observe the 
    temperature change and some interesting points, like the year with maximum temperature or the
    year with maximum change of temperature. Feel free to try putting the cursor on the graph for
    looking at specific data"),
  tags$p(id = "paragraph1", class = "redborder", "Special Notice: If you change starter year from the slider but the x axis does not change, 
         or if the plot is blank, then there is insufficient data to show.")
)

tab3 <- tabPanel(
  "Average Temperature in different country",
  sidebarLayout(
    plot_sidebar3,
    plot_main3
  ),
  text3
)

# ------------------------------------------------------------
summary <- tabPanel(
  "Summary",
  
  fluidPage(
    textOutput(
      outputId = "finding1"
    ),
    p(),
    textOutput(
      outputId = "finding2"
    ),
    p(),
    textOutput(
      outputId = "finding3"
    )
  )
)


# ---------------ui-------------------------
ui <- navbarPage(
  "Global Temperature Change",
  intro_tab,
  tab1,
  tab2,
  tab3,
  summary
)
