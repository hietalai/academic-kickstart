knitr::opts_chunk$set(echo = TRUE, fig.height = 2, fig.align = "center", fig.width = 6, eval = FALSE)

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

require(multcomp)

data(iris)
data("PlantGrowth")

data("InsectSprays")

data("ToothGrowth")

### Example data for paired tests (taken from http://www.sthda.com/english/wiki/paired-samples-t-test-in-r)
# Weight of the mice before treatment
before <-c(200.1, 190.9, 192.7, 213, 241.4, 196.9, 172.2, 185.5, 205.2, 193.7)
# Weight of the mice after treatment
after <-c(392.9, 393.2, 345.1, 393, 434, 427.9, 422, 383.9, 392.3, 352.2)
# Create a data frame
mice_data <- data.frame(before, after)


hietala_theme <- theme_bw() +
  theme(axis.title.y = element_text(angle = 0, vjust = 0.5, size = 11),
        axis.title.x = element_text(size = 11),
        plot.title = element_text(hjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "gray70"),
        panel.grid.minor.y = element_line(color = "gray80"),
        axis.text = element_text(size = 10, color = "black"))

theme_set(hietala_theme)
# rm(hietala_theme)
