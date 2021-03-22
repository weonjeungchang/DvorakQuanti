output$assetType = renderUI({
  prettyRadioButtons(
    inputId = 'assetType',
    label = 'Select a Asset Classification',
    choices = list('STOCK' = 'S', 'BOND' = 'B'),
    selected = 'S',
    shape = 'round',
    inline = TRUE,
    status = 'primary',
    fill = TRUE,
    animation = 'pulse'
  )
})

output$paDate = renderUI({
  dateRangeInput('paDate', 'Date Range',
                 start = '2018-01-01',
                 end = Sys.Date(),
                 min = '2018-01-01',
                 max = Sys.Date(),
                 format = "yyyy-mm-dd",
                 separator = " - ")
})

output$weight_sum_min = renderUI({
  numericInput("weight_sum_min",
               label = 'minimum',
               min=0.00,
               max=1.00,
               step=0.05,
               value = 0.80)
})

output$weight_sum_max = renderUI({
  numericInput("weight_sum_max",
               label = 'maximum',
               min=0.00,
               max=1.00,
               step=0.05,
               value = 1.00)
})
