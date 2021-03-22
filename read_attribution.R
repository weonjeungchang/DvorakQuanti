
# ==============================================================================
# reactive
# ==============================================================================
Attribution.exec <- reactive({                
  df_result <- Attribution(Rp, wp, Rb, wb,
                           wpf = NA, wbf = NA, S = NA, F = NA, Rpl = NA, Rbl = NA, Rbh = NA, 
                           bf = input$bf,
                           method = input$method,
                           linking = input$linking,
                           geometric = input$geometric,
                           adjusted = input$adjusted)   
  assign("rst_Attribution" , df_result, envir = .GlobalEnv)
})  



# ==============================================================================
# Chart : ExcessReturnsLineChart
# ==============================================================================
output$ExcessReturnsLineChart <- renderHighchart({
  Attribution.exec()
  df_result <- as.data.frame(rst_Attribution$`Excess returns`)

  highchart() %>%
    hc_title(text= "Excess Returns") %>%
    hc_subtitle(text= "(portfolio returns) - (benchmark returns)") %>%
    hc_xAxis(categories = rownames(df_result)) %>%
    hc_yAxis(title = list(text = "Returns")) %>%
    hc_add_series(
      data = df_result[,1] *100,
      type = "line",
      name = "Excess Returns"
    ) %>%
    hc_add_series(
      data = coredata(Return.portfolio(Rp, wp, geometric = FALSE)) *100,
      type = "line",
      name = "Portfolio Returns"
    ) %>%
    hc_add_series(
      data = coredata(Return.portfolio(Rb, wb, geometric = FALSE)) *100,
      type = "line",
      name = "Benchmark Returns"
    )
})

# ==============================================================================
# Chart : AttributionAreaChart
# ==============================================================================
output$AttributionAreaChart <- renderHighchart({
  Attribution.exec()
  if(input$method == 'none') {
    df_interaction <- rst_Attribution$Interaction[1:nrow(rst_Attribution$Interaction)-1,c('Total')] *100
  }
  else {
    df_interaction <- rep(0, times=nrow(rst_Attribution$Allocation)-1)
  }
  highchart() %>%
    hc_title(text= "Attribution") %>%
    hc_subtitle(text= "Allocation/Selection/Interaction") %>%
    hc_xAxis(categories = rownames(rst_Attribution$Allocation)) %>%
    hc_yAxis(title = list(text = "effect")) %>%
    hc_add_series(
      data = rst_Attribution$Allocation[1:nrow(rst_Attribution$Allocation)-1,c('Total')] *100,
      type = "column",
      name = "Allocation",
      color = '#24CBE5'
    ) %>%
    hc_add_series(
      data = rst_Attribution$Selection[1:nrow(rst_Attribution$Selection)-1,c('Total')] *100,
      type = "column",
      name = "Selection",
      color = '#FF9655'
    ) %>%
    hc_add_series(
      data = df_interaction,
      type = "column",
      name = "Interaction",
      color = '#FFF263'
    )
})

# ==============================================================================
# Chart : AllocationPieChart
# ==============================================================================
output$AllocationPieChart <- renderHighchart({
  Attribution.exec()
  df_result <- cbind(t(rst_Attribution$Allocation[nrow(rst_Attribution$Allocation),1:ncol(rst_Attribution$Allocation)-1]), data.frame(colnames(rst_Attribution$Allocation[,1:ncol(rst_Attribution$Allocation)-1])))
  colnames(df_result) <- c('y', 'name')
  highchart() %>%
    hc_title(text= "Allocation by sector") %>%
    hc_subtitle(text= "Total Allocation Effect") %>%
    hc_chart(type = "pie") %>%
    # hc_xAxis(categories = colnames(rst_Attribution$Allocation[,1:ncol(rst_Attribution$Allocation)-1])) %>%
    # hc_yAxis(categories = list(colnames(rst_Attribution$Allocation[,1:ncol(rst_Attribution$Allocation)-1]))) %>%
    hc_add_series(
      data = df_result
    ) %>%
    hc_plotOptions(
      series = list(showInLegend = FALSE,
                    dataLabels = list(format = "{point.name} : ({point.y:.9f})",
                                      distance = 1))
    ) %>%
    hc_tooltip(valueDecimals = 0,
               pointFormat = "({point.y:.9f})"
    ) %>%
    hc_legend(enabled = TRUE)
})


  
# output$ExcessReturns <- renderTable({
#   Attribution.exec()
#   df_result <- cbind(coredata(Return.portfolio(Rp, wp, geometric = FALSE)),
#                      coredata(Return.portfolio(Rb, wb, geometric = FALSE)),
#                      rst_Attribution$`Excess returns`)
#   colnames(df_result) <- c('portfolio.returns', 'benchmark.returns', 'excess.returns')
#   df_result
#   },
#   width = "100%",
#   rownames = TRUE,
#   colnames = TRUE,
#   bordered = TRUE,
#   digits=14
# )
output$ExcessReturns <- renderDataTable({
  Attribution.exec()
  df_result <- cbind(coredata(Return.portfolio(Rp, wp, geometric = FALSE)),
                     coredata(Return.portfolio(Rb, wb, geometric = FALSE)),
                     rst_Attribution$`Excess returns`)
  colnames(df_result) <- c('portfolio.returns', 'benchmark.returns', 'excess.returns')
  df_result
},
rownames=rownames(data.frame(rst_Attribution$`Excess returns`)),
selection = "none",
options = list(scrollX = TRUE,
               scrollY = TRUE,
               paging = FALSE,
               searching = FALSE)
)

output$Allocation <- DT::renderDataTable(
  DT::datatable({
    Attribution.exec()
    rst_Attribution$Allocation
  },
  rownames=rownames(data.frame(rst_Attribution$Allocation)),
  selection = "none",
  options = list(scrollX = TRUE, scrollY = TRUE,
                 paging = FALSE,
                 searching = FALSE),
  caption = HTML("<font color='#FF9655'><b> - Allocation</b></font>")
  )
)

output$Selection <- DT::renderDataTable(
  DT::datatable({
    Attribution.exec()
    rst_Attribution$Selection
  },
  rownames=rownames(data.frame(rst_Attribution$Selection)),
  selection = "none",
  options = list(scrollX = TRUE, scrollY = TRUE,
                   paging = FALSE,
                   searching = FALSE),
  caption = HTML("<font color='#FF9655'><b> - Selection</b></font>")
  )
)

output$Interaction <- DT::renderDataTable(
  DT::datatable({
    Attribution.exec()
    rst_Attribution$Interaction
  },
  rownames=rownames(data.frame(rst_Attribution$Interaction)),
  selection = "none",
  options = list(scrollX = TRUE, scrollY = TRUE,
                   paging = FALSE,
                   searching = FALSE),
  caption = HTML("<font color='#FF9655'><b> - Interaction</b></font>")
  )
)



output$Rp <- renderTable(
  Rp,
  digits=12,
  bordered = TRUE
)

output$wp <- renderTable(
  t(wp),
  digits=2,
  bordered = TRUE
)

output$Rb <- renderTable(
  Rb,
  digits=12,
  bordered = TRUE
)

output$wb <- renderTable(
  t(wb),
  digits=2,
  bordered = TRUE
)



output$returns <- DT::renderDataTable(
  DT::datatable({
    attrib.returns
  }
  , options = list(scrollX = TRUE, scrollY = TRUE,
                   searching = FALSE)
  )
)

output$weights <- DT::renderDataTable(
  DT::datatable({
    attrib.weights
  }
  , options = list(scrollX = TRUE, scrollY = TRUE,
                   searching = FALSE)
  )
)

output$hierarchy <- DT::renderDataTable(
  DT::datatable({
    attrib.hierarchy
  }
  , options = list(scrollX = TRUE, scrollY = TRUE,
                   searching = FALSE)
  )
)

output$allocation <- DT::renderDataTable(
  DT::datatable({
    attrib.allocation
  }
  , options = list(scrollX = TRUE, scrollY = TRUE,
                   searching = FALSE)
  )
)

output$currency <- DT::renderDataTable(
  DT::datatable({
    attrib.currency
  }
  , options = list(scrollX = TRUE, scrollY = TRUE,
                   searching = FALSE)
  )
)