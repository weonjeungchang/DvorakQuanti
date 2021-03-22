
## 메모리 청소
rm(list = ls())
gc()

# ==============================================================================
# package (sapply)
# ==============================================================================
source('lib_packages.R', local = TRUE)

# ==============================================================================
# data
# ==============================================================================
# source('data.R', local = TRUE)

load("/home/WJJang/shiny/WJJang/PortfolioAttribution-master/data/attrib.rda")
# View(attrib.allocation)
# View(attrib.currency)
# View(attrib.hierarchy)
# View(attrib.returns)
# View(attrib.weights)

# Load the data
Rp = attrib.returns[, 1:10]
index(Rp) <- as.Date(index(Rp),"%Y/%m/%d")
Rb = attrib.returns[, 11:20]
index(Rb) <- as.Date(index(Rb),"%Y/%m/%d")
# rp = attrib.returns[, 21]
# rb = attrib.returns[, 22]
# Rf = attrib.returns[, 23:32]
# Rpl = attrib.returns[, 33:42]
# Rbl = attrib.returns[, 43:52]
# Rbh = attrib.returns[, 53:62]

# Dp = attrib.returns[, 63:72]
# Db = attrib.returns[, 73:82]
wp = attrib.weights[1, ]
wb = attrib.weights[2, ]
# wpf = attrib.weights[3, ]
# wbf = attrib.weights[4, ]
# h = attrib.hierarchy
# allocation = attrib.allocation
# F = attrib.currency[, 1:10]
# S = attrib.currency[, 11:20]

src_dir <- c("/home/WJJang/shiny/WJJang/PortfolioAttribution-master/R")
arr_src_file <- list.files(src_dir)
src_file_cnt <- length(arr_src_file)
for(i in 1:src_file_cnt) {
    src_file <- paste0(src_dir, '/', arr_src_file[i])
    source(src_file)
}
rm(src_dir)
rm(arr_src_file)
rm(src_file_cnt)
rm(src_file)
rm(i)

# df_result <- Attribution(Rp, wp, Rb, wb, method = "none", linking = "carino")
# assign("rst_Attribution" , df_result, envir = .GlobalEnv)
# View(df_result$`Excess returns`)
# View(df_result$Allocation)
# View(df_result$Selection)


load("/home/WJJang/shiny/WJJang/indexes.rda")
R <- indexes
rm(indexes)


# ==============================================================================
# Define UI for application that draws a histogram
# ==============================================================================
ui <- navbarPage(

    "DvorakQuanti",
    # shinythemes::themeSelector(),
    theme = shinythemes::shinytheme("flatly"),

    position = "fixed-top", header = NULL,
    
    source('output_attribution.R', local = TRUE)$value,
    # source('output_PerformanceAttribution.R', local = TRUE)$value,
    source('output_AssetAllocation.R', local = TRUE)$value,
    source('output_Risk.R', local = TRUE)$value,
    source('output_Smoothing.R', local = TRUE)$value,
    source('output_author.R', local = TRUE)$value
)


# ==============================================================================
# Define server logic required to draw a histogram
# ==============================================================================
server <- function(input, output) {

    source('read_ui.R', local = TRUE)
    source('read_attribution.R', local = TRUE)
    source('read_AssetAllocation.R', local = TRUE)
}


# ==============================================================================
# Run the application 
# ==============================================================================
shinyApp(ui = ui, server = server)


