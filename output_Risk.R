tabPanel("Risk",
         #
         sidebarPanel(
           style = "position:fixed; width:20%",
           br()
         ),
         #
         mainPanel(
           style = "margin-left:25vw",
           tabsetPanel(
             type = "tabs",
             tabPanel("Ex-Anter Risk",
                      br()
             ),
             tabPanel("Risk Budgeting",
                      br()
             ),
             tabPanel("Ex-Post Risk",
                      br()
             )
           )
         )
)