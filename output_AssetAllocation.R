tabPanel("Asset Allocation",
         #
         sidebarPanel(
           style = "position:fixed; width:20%",
           uiOutput('aaDate'),
           br()
         ),
         #
         mainPanel(
           style = "margin-left:25vw",
           tabsetPanel(
             type = "tabs",
             tabPanel("Black-Litterman",
                      br()
             ),
             tabPanel("Mean-Variance",
                      br()
             ),
             tabPanel("Risk-parity",
                      br()
             ),
             tabPanel("Asset Liability Management",
                      br()
             )
           )
         )
)
