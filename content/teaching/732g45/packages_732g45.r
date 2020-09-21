# Load packages
require(ggplot2)
require(grid)
require(gridExtra)
require(RColorBrewer)
require(dplyr)
require(tidyr)
require(stringr)
require(xtable)
require(GGally)
require(portfolio)
require(kableExtra)
require(captioner)
tables <- captioner(prefix = "Tabell")
figures <- captioner(prefix = "Figur")


# Sourcing the hietala_theme
source("hietala_theme.R")

# Loading data used for examples
data(iris)

exempeldata <- read.csv2(file = "data_sets/732G45_exempeldata.csv")
