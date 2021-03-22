tabPanel("Performance Attribution",
         includeMarkdown('performanceAttribution.Rmd'),
         
         sidebarPanel(
           style = "position:fixed; width:20%",
           uiOutput('assetType'),
           br(),
           uiOutput('paDate'),
           br(),
           selectInput(inputId = "fundCd",
                       label = "Choose a FUND",
                       choices = c("Uni Index-Equity 9 Discretionary",
                                  "Tops Premium Equity-Equity 16",
                                  "Shinhan Life Uni Short-Term",
                                  "Shinhan Life Pension Short-Term",
                                  "Shinhan SRI Equity Hybrid VL 1",
                                  "Shinhan SRI Bond Hybrid VL",
                                  "Shinhan Nonparticipating VIP Bond VL Ⅲ",
                                  "Shinhan Saving Bond VL",
                                  "Shinhan Life VUL Premium",
                                  "SH Fundamental Index",
                                  "Tops Premium Equity VL 1",
                                  "SH Tops Fundamental Index Equity",
                                  "SHL VUL Hybrid Growth-Bond VL",
                                  "Tops Premium Equity - MMF",
                                  "Tops Fundamental Index-MMF",
                                  "Shinhan Life UNI MMF Index",
                                  "VIP VL Index-MMF",
                                  "Pension Bond type II (Bond 1)",
                                  "Pension Stable Growth-Bond2")),
         br(),
         selectInput(inputId = "bmCd",
                     label = "Choose a BenchMark",
                     choices = c("KOSPI200",
                                 "KOSDAQ150")),
         ),
         #
         mainPanel(
           style = "margin-left:25vw",
           tabsetPanel(
             type = "tabs",
             tabPanel("Brinson-Fachler",
                      br()
             ),
             tabPanel("Bottom-up",
                      br()
             ),
             tabPanel("Lehmann",
                      br()
             ),
             tabPanel("4-factor",
                      br()
             ),
             tabPanel("Campisi",
                      br()
             )
           )
         )
)
