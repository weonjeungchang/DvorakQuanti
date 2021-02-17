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

output$aaDate = renderUI({
  dateRangeInput('aaDate', 'Date Range',
                 start = '2018-01-01',
                 end = Sys.Date(),
                 min = '2018-01-01',
                 max = Sys.Date(),
                 format = "yyyy-mm-dd",
                 separator = " - ")
})
