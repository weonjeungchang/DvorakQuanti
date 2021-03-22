
# ==============================================================================
# reactive
# ==============================================================================



# **************************************************************************************************
# Mean-Variance
# **************************************************************************************************

# ------------------------------------------------------------------------------
# reactive
# ------------------------------------------------------------------------------
MeanVariance.exec <- reactive({
pspec <- portfolio.spec(assets=colnames(R))
pspec <- add.constraint(portfolio=pspec, type="full_investment")
pspec <- add.constraint(portfolio=pspec, type="long_only")
pspec <- add.objective(portfolio=pspec, type='risk', name='var')
pspec <- add.objective(portfolio=pspec, type='return', name='mean')
create.EfficientFrontier(R,
                         portfolio     = pspec,
                         type          ='mean-var', # 'mean-var':QP solver, 'mean-ETL':LP solver
                         n.portfolios  = 100,
                         risk_aversion = NULL,
                         match.col     = NULL,
                         search_size   = NULL)
})  

output$MV_Return <- DT::renderDataTable(
  DT::datatable({
    R
  },
  rownames=rownames(data.frame(R)),
  colnames=colnames(data.frame(R)),
  selection = "none",
  options = list(scrollX = TRUE,
                 scrollY = TRUE,
                 searching = FALSE),
  caption = HTML("<font color='#FF9655'><b> - TimeSeries Return data </b></font>")
  )
)

output$pot.assets <- renderTable({
  df_result <- MeanVariance.exec()
  t(data.frame(df_result$portfolio$assets))
  },
  rownames = TRUE,
  digits=16,
  bordered = TRUE,
  caption = "Potfolio's assets"
)

output$pot.constraints <- renderTable({
  df_result <- MeanVariance.exec()
  c(df_result$portfolio$constraints[[1]]$type,
    df_result$portfolio$constraints[[1]]$min_sum,
    df_result$portfolio$constraints[[1]]$max_sum,
    df_result$portfolio$constraints[[2]]$type)
  },
  rownames = TRUE,
  bordered = TRUE,
  width = '200px',
  caption = "Potfolio's constraints"
)

output$pot.objectives <- renderTable({
  df_result <- MeanVariance.exec()
  c(df_result$portfolio$objectives[[1]]$name,
    df_result$portfolio$objectives[[2]]$name)
  },
  rownames = TRUE,
  bordered = TRUE,
  width = '150px',
  caption = "Potfolio's objectives"
)

output$mv.EfficientFrontier <- renderPlot({
  df_result <- MeanVariance.exec()
  plot(df_result$frontier[,2], df_result$frontier[,1],
       xlab = 'Risk',ylab = 'Returns',
       type = 'l',
       lty = 1,
       lwd = 3,
       main = 'Mean Variance Optimizer',col = 'blue')
})



# ==============================================================================
# Black-Litterman
# ==============================================================================
output$BL_Return <- DT::renderDataTable(
  DT::datatable({
    R
  },
  rownames=rownames(data.frame(R)),
  colnames=colnames(data.frame(R)),
  selection = "none",
  options = list(scrollX = TRUE,
                 scrollY = TRUE,
                 searching = FALSE),
  caption = HTML("<font color='#FF9655'><b> - TimeSeries Return data </b></font>")
  )
)

output$Mu <- renderTable({
  t(data.frame(colMeans(R)))
  },
  rownames = TRUE,
  digits=17,
  bordered = TRUE,
  caption = "Mu : Expected Return"
)

output$P <- renderTable({
  diag(ncol(R))
  },
  rownames = TRUE,
  digits=0,
  bordered = TRUE,
  caption = "P : Pick Matrix"
)

output$Sigma <- renderTable({
  cov(R)
  },
  rownames = TRUE,
  digits=17,
  bordered = TRUE,
  caption = "Sigma : Covariance"
)

output$Omega <- renderTable({
  tcrossprod(colMeans(R) %*% cov(R), colMeans(R))
  },
  rownames = TRUE,
  digits=21,
  bordered = TRUE,
  caption = "Omega : "
)

output$Views <- renderTable({
  sqrt( diag( tcrossprod(colMeans(R) %*% cov(R), colMeans(R)) ) )
  },
  rownames = TRUE,
  digits=21,
  bordered = TRUE,
  caption = "Views : "
)


