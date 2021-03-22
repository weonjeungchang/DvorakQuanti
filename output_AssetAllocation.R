tabPanel("Asset Allocation",
         tags$head(tags$style(HTML('#weight_sum_min{height: 22px}
                                    #weight_sum_max{height: 22px}
                                    #box_bounds{height: 60px}'))),
         style = "margin-top:80px; width:100%",
         tabsetPanel(
           type = "tabs",
           tabPanel("Mean-Variance",
                    br(),
                    sidebarPanel(
                      style = "position:absolute; margin-top:5px; width:400px",
                      HTML('<font color="red"><b><big><u> Constraints </u></big></b></font>'),
                      br(),
                      prettyRadioButtons(inputId = "weight_sum_const",
                                         label = HTML('<b>Sum of Weights Constraint</b><br>:maximum/minimum sum of portfolio weights'),
                                         choices = list("full_investment"="full_investment",
                                                        "weight_sum"="weight_sum"), 
                                         inline = TRUE,
                                         selected = "full_investment"),
                      
                      shinyjs::useShinyjs(),  # Set up shinyjs
                      fluidRow(column(width = 5,
                                      uiOutput('weight_sum_min')),
                               column(width = 5, ofset = 2,
                                      uiOutput('weight_sum_max'))
                      ),
                      br(),br(),
                      prettyRadioButtons(inputId = "box_const",
                                         label = HTML('<b>Box Constraint</b><br>:upper and lower bounds on the asset weights'),
                                         choices = list("long_only"="long_only",
                                                        "box"="box"), 
                                         inline = TRUE,
                                         selected = "long_only"),
                      fileInput(inputId = 'box_bounds',
                                label = 'upper/lower bounds',
                                buttonLabel = "upload"),
                      HTML('<b>Group Constraints</b><br>:minimum and maximum weight per group<br>(industries, sectors or geography)<br>'),
                      HTML('<b>Position Limit Constraint</b><br>'),
                      HTML('<b>Diversification Constraint</b><br>'),
                      HTML('<b>Turnover Constraint</b><br>'),
                      HTML('<b>Target Return Constraint</b><br>'),
                      HTML('<b>Factor Exposure Constraint</b><br>'),
                      HTML('<b>Transaction Cost Constraint</b><br>'),
                      HTML('<b>Leverage Exposure Constraint</b><br>'),
                      HTML('<b>Checking and en-/disabling constraints</b><br>'),
                      br(),
                      HTML('<font color="red"><b><big><u> Objectives </u></big></b></font>'),
                      br(),
                      prettyRadioButtons(inputId = "risk_objtv",
                                         label = "Risk Objective",
                                         choices = list("var"="var",
                                                        "ETL"="ETL"), 
                                         inline = TRUE,
                                         selected = "var"),
                      prettyRadioButtons(inputId = "return_objtv",
                                         label = "Return Objective",
                                         choices = list("mean"="mean"), 
                                         inline = TRUE,
                                         selected = "mean"),
                      prettyRadioButtons(inputId = "riskBudget_objtv",
                                         label = "Risk Budget Objective",
                                         choices = list("var"="var",
                                                        "ETL"="ETL"), 
                                         inline = TRUE,
                                         selected = "var")
                    ),
                    #
                    mainPanel(
                      style = "margin-left:450px; margin-top:5px",
                      plotOutput('mv.EfficientFrontier'),
                      tableOutput("pot.assets"),
                      fluidRow(column(width = 3,
                                      tableOutput("pot.constraints")),
                               column(width = 3, ofset = 2,
                                      tableOutput("pot.objectives"))
                      ),
                      br(),
                      DT::dataTableOutput("MV_Return")
                    )
           ),
           tabPanel("Black-Litterman",
                    br(),
                    sidebarPanel(
                      style = "position:absolute; margin-top:5px; width:400px",
                    ),
                    mainPanel(
                      style = "margin-left:450px; margin-top:5px",
                      # HTML("<font color=red><b><big> - timeSeries returns (xts)</big></b></font>"),
                      DT::dataTableOutput("BL_Return"),
                      br(),
                      hr(),
                      HTML("◆ Computed Data"),
                      br(),br(),
                      tableOutput("Mu"),
                      tableOutput("P"),
                      tableOutput("Sigma"),
                      tableOutput("Omega"),
                      tableOutput("Views"),
                      br()
                    )
           ),
           tabPanel("Risk-parity",
                    br()
           ),
           tabPanel("Asset Liability Management",
                    br()
           ),
           tabPanel("Sample Data",
                    br()
           )
         )
)
