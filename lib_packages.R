pkg = c('shiny', 'shinyWidgets', 'shinythemes', 'shinydashboard', 'shinyjs',
        'DT',
        'xts', 'zoo', 'PerformanceAnalytics', 'PortfolioAnalytics',
        'highcharter',
        'dplyr')
sapply(pkg, require, character.only = TRUE)
rm(pkg)