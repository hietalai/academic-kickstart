---
# Course title, summary, and position.
weight: 7

# Page metadata.
title: Annorlunda visualiseringar
linktitle: Annorlunda visualiseringar
date: "2020-09-21"
lastmod: "2020-09-21"
draft: false  # Is this a draft? true/false
toc: true  # Show table of contents? true/false
type: docs  # Do not modify.

tags:
- Swedish
- Programming
- R
- Visualization
- Tree map
- Parallell coordinate plot

# Add menu entry to sidebar.
# - name: Declare this menu item as a parent with ID `name`.
# - weight: Position of link in menu.
menu:
  732G45:
    name: Annorlunda visualiseringar
    parent: 732G45
    weight: 7
---




## Tree maps
För att skapa en tree map behöver vi först ladda paketet `portfolio` samt hämta hem den förändrade `treemap`-funktionen via `source()`.


```r
require(portfolio)

source("https://raw.githubusercontent.com/canadice/visualization_literature/master/treemapbrewer.r")
```

Nu har vi skapat och laddat in en ny funktion i R som heter `treemap_brewer()` som har följande argument:

- `id` styr vilken variabel i datamaterialet som används som etikett i varje cell,
- `group` styr vilken variabel som anger vilka/hur många celler som ska skapas,
- `area` styr vilken variabel som bestämmer storleken på cellen,
- `color` styr vilken variabel som bestämmer färgnyansen på cellen,
- `textcol` styr färgen på texten i cellerna,
- `linecol` styr färgen på kantlinjen mellan cellerna,
- `pal` anger en `RColorBrewer` palette med färger som används för färgläggning av cellerna,
- `main` styr diagramrubriken.

För att exemplifiera denna diagramtyp kommer `iris`-data användas igen. En beskrivning av detta material finns tidigare i kodmanualen. Vi vill nu skapa en tree map där vi vill se samband mellan `Sepal.Length` och `Petal.Length` för de tre olika arterna (`Species`) av blommor. För att kunna skapa detta diagram behöver vi ha **en** observation per art, så lite databearbetning behöver först göras i antingen Excel eller R. 

Vi vill alltså *aggregera* materialet från det rådata (mikrodata) som anges för varje objekt till gruppvis data (makrodata) för varje art och detta gör vi genom att skapa ett medelvärde per art för de två undersökta variablerna. Vi skulle också kunna tänka oss att vi vill summera de olika arternas mått men i detta material är det nog lämpligare att titta på de genomsnittliga längderna som en egenskap av arten.

Nedanstående kod använder sig utav `dplyr`-paketets funktioner för databearbetning som kommer tas upp mycket mer i Programmering i R under vårterminen.


```r
iris_agg <- iris %>% group_by(Species) %>% summarise(sepal_mean = mean(Sepal.Length), 
                                                     petal_mean = mean(Petal.Length))

kable(iris_agg, format = "html", caption = tables("tab1")) %>%
  kable_styling(position = "center", full_width = FALSE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>1: Tabell  1: Aggregerad datamaterial för iris</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Species </th>
   <th style="text-align:right;"> sepal_mean </th>
   <th style="text-align:right;"> petal_mean </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> setosa </td>
   <td style="text-align:right;"> 5.006 </td>
   <td style="text-align:right;"> 1.462 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> versicolor </td>
   <td style="text-align:right;"> 5.936 </td>
   <td style="text-align:right;"> 4.260 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> virginica </td>
   <td style="text-align:right;"> 6.588 </td>
   <td style="text-align:right;"> 5.552 </td>
  </tr>
</tbody>
</table>

Nu har vi datamaterialet enligt det format som behövs för att skapa en tree map, vi har två kontinuerliga variabler samt en kategorisk variabel. Notera att vi i denna funktion måste ange *datamaterialet$variabelnamnet* för att lägga till variablerna som vi vill använda i funktionen, till skillnad från tidigare använda `ggplot2`-funktioner.


```r
treemap_brewer(id = iris_agg$Species, 
               group = iris_agg$Species, 
               area = iris_agg$sepal_mean,
               color = iris_agg$petal_mean,
               textcol = "black",
               linecol = "black",
               pal = "Oranges",
               main = "Tree map över olika arter av blommor")
```

<img src="/teaching/732g45/6-annorlunda-visualiseringar_files/figure-html/unnamed-chunk-3-1.png" width="576" style="display: block; margin: auto;" />

**Tänk på att i figurbeskrivningen ange vilka variabler som styr storleken och färgen i diagrammet!**

## Parallellkoordinatdiagram

Denna sorts diagram ämnar att identifiera *kluster* av observationer i ett datamaterial, samt att kunna se korrelationen mellan intilliggande variabler. För att skapa diagrammet används `ggparcoord()` ur paketet `GGally` som vi tittat på tidigare. 

Argumenten som vi är intresserade av är:

- `data` som anger vilket material som ska visualiseras,
- `col` som anger vilka kolumnindex som ska visualiseras,
- `scale` som **alltid** ska vara `"uniminmax"` för att standardisera y-axeln till samma skalor.

Till detta diagram kan vi använda andra `ggplot2`-funktionalitet för text och estetik.


```r
ggparcoord(data = iris, 
           col = 1:4,
           scale = "uniminmax") +
  # Lägger till annan estetik likt tidigare diagram
  theme_bw() + 
  theme(axis.title.y = 
          element_text(angle = 0, 
                       hjust = 1, 
                       vjust = 0.5), 
        plot.title = 
          element_text(hjust = 0.5),
        plot.subtitle = 
          element_text(hjust = 0.5),
        panel.grid.major.x = 
          element_line(color = "gray"),
        panel.grid.minor.x = 
          element_line(color = "light gray"),
        panel.grid.major.y = 
          element_line(color = "gray"),
        panel.grid.minor.y = 
          element_line(color = "light gray")) + 
  labs(title = "",
       x = "Variabel",
       y = "Värde",
       caption = "Källa: Anderson, E - The New S Language (1935)")
```

<img src="/teaching/732g45/6-annorlunda-visualiseringar_files/figure-html/unnamed-chunk-4-1.png" width="576" style="display: block; margin: auto;" />

Till hjälp med tolkningen av detta diagram rekommenderas att läsa följande [länk](http://www.jmp.com/support/help/The_Parallel_Plot.shtml). 
