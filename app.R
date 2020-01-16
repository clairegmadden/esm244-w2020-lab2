#how to make a shiny app starting from scratch
#attach packages
library(tidyverse)
library(shiny)
library(shinythemes)
library(here)

# read in spooky_data.csv

spooky <- read_csv(here("data", "spooky_data.csv"))

# create a user interface, fluid page allows for page width to adjust automatically based on screen size of the viewer's device

#build app in small pieces! get overall layout code set before messing with smaller pieces and reactivity components

#going to create our first widget so the user can select a state
#selectInput function exists solely to create widgets, first argument names the widget, second argument tells people what to do, third argument tells the app what the choices should be (if only a few you can use choices = c("name1", "name2" etc.), if a lot of choices you can use the unique function)


ui <- fluidPage(
  theme = shinytheme("superhero"),
  titlePanel("Here is my awesome title"),
  sidebarLayout(
    sidebarPanel("My widgets are here",
                 selectInput(inputId = "state_select",
                             label = "Choose a state:",
                             choices = unique(spooky$state)
                              )
                 ),
    mainPanel("My outputs are here",
              tableOutput(outputId = "candy_table")
              )
  )
)

# next we need to take our input selection (named state_select) do something! - start working in the server

# next week we will make different tabs in the app, should include a landing page that explains the purpose of ui and app

# need to tell the server function to keep an eye out for inputs and outputs
# anything for back end reactivity goes in the {}
# create a reactive subset of the spooky df that only contains information for the state_select - filter to match whatever the user selected

server <- function(input, output){

  state_candy <- reactive({
     spooky %>%
       filter(state == input$state_select) %>%
       select(candy, pounds_candy_sold)
   })

# functions build manually are not seperated by a comma, they are just seperate script chunks inside of the function

  output$candy_table <- renderTable({
    state_candy() #reactive objects need to be called with () at the end to be recognized

  })

}

#currently, R doesn't have any idea that ui and server should be connected in a single shiny app

shinyApp(ui = ui, server = server)

# we just built an app!
# for R to recognize this as an app, needs to be saved as "app.R"


# now we're going to add things that are just on the ui but not reactive at all



