---
# Course title, summary, and position.
weight: 4

# Page metadata.
title: Visualisering av beskrivande statistik
linktitle: Beskrivande statistik
date: "2020-08-05"
lastmod: "2020-08-05"
draft: false  # Is this a draft? true/false
toc: true  # Show table of contents? true/false
type: docs  # Do not modify.

tags:
- Swedish
- Programming
- R
- Visualization
- Descriptive statistics

output: 
  language:
    label:
      fig: "Figur "
      tab: "Tabell "

# Add menu entry to sidebar.
# - name: Declare this menu item as a parent with ID `name`.
# - weight: Position of link in menu.
menu:
  732G45:
    name: Beskrivande statistik
    parent: 732G45
    weight: 4
---



## Stapeldiagram
Den absolut enklaste formen av visualisering är stapeldiagram. Denna diagramtyp består utav staplar vars höjd kommer från ett värde i datamaterialet, vanligtvis då man har en kvalitativ variabel och dess frekvenser (antalet av de olika arterna i diagrammen från tidigare kapitel), men diagramtypen kan också användas då man har en kvantitativ variabel uppdelad på en eller flera kvalitativa variabler (medellönen uppdelat på olika sektorer). Följande exempel kommer utgå från det första fallet.

Olika programvaror kräver olika mycket bearbetning av datamaterialet innan diagrammet kan skapas. Vissa kräver att du själv skapar en frekvenstabell och anger att höjden av respektive stapel ska bestämmas av den tillhörande frekvensen, medan andra kan göra dessa beräkningar direkt på rådata.

### R 
Som tidigare nämnt om R använder sig programmet av diverse paket som innehåller redan skapade funktioner för att lösa diverse arbetsuppgifter. För visualisering kommer vi använda oss främst av paketet `ggplot2` som bygger på vad som kallas för [*grammar of graphics*](https://www.researchgate.net/publication/5142951_The_Grammar_of_Graphics). Detta är ett försök till att formalisera ett språk för hur man enhetligt bör "skriva" visualiseringar och även SPSS använder sig av grunderna till detta språk. Det första steget för att få ta del av funktionerna är att ladda paketet till din R-session genom:


```r
require(ggplot2)
```

Paketets visualiseringar utgår ifrån en `data.frame` vilket innebär att vi behöver ladda in ett datamaterial innan vi kan påbörja visualiseringarna. Detta kan göras med någon utav funktionerna `read.csv()`, `read.csv2()` osv. **Se till att datamaterialet som laddats in ser ut som vi förväntar att det ska göra**, exempelvis att decimalerna är korrekt angivna, att vi har lika många variabler i R som i Excel, och liknande. Med koden nedan kan datamaterialet som används som exempel genom hela denna text laddas in i R till objektet som kallas `exempeldata`. Vi kan även se hur materialet ser ut genom att använda `head()` som skriver ut ett antal observationer. Materialet ser ut att innehålla fem variabler, varav två är kvalitativa.


```r
exempeldata <- read.csv2(file = "data_sets/732G45_exempeldata.csv")

head(exempeldata, n = 5)
```

```
##   civilstand alder   bil syskon   lon
## 1        Par    26  Opel      0 26793
## 2        Par    44  Ford      2 49588
## 3        Par    34 Volvo      3 40461
## 4        Par    33 Ingen      4 40299
## 5        Par    32  Audi      3 36942
```


#### Grundkomponenter 
Vi kan nu börja med att skapa stapeldiagrammet. Vi börjar med de tre grundkomponenterna av ett `ggplot`-diagram; `ggplot()`, `aes()` och `geom()`. Alla diagram måste innehålla dessa tre komponenter i någon form för att vi ska kunna producera något överhuvudtaget, sen kan vi lägga till andra instruktioner för att ändra diagrammets utseende.



Med `ggplot()` anges vilket datamaterial vi vill använda för visualiseringen:


```r
ggplot(exempeldata)
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-4-1.png" width="576" style="display: block; margin: auto;" />

Som vi ser skapas inget utifrån detta kommando, vi har bara sagt åt R att använda datamaterialet men inte vad den ska göra med det. Nästa steg är att ange vilka variabler vi vill använda för axlarna i diagrammet. När det kommer till stapeldiagram finns två olika sätt att göra; antingen har vi rådata och låter R räkna ut frekvensen av de olika kategorierna själv eller så skapar vi en egen frekvenstabell och anger `y = frekvens`. Vi kommer först börja med exemplet utifrån rådata:


```r
ggplot(exempeldata) + aes(x = bil)
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-5-1.png" width="576" style="display: block; margin: auto;" />

Nu ser vi att R ritat ut de olika bilarna som finns i materialet på x-axeln, men vi har fortfarande inte sagt åt R vad vi vill att den ska göra med informationen som ska visualiseras. Den sista grundkomponenten är den som styr vilken diagramtyp vi skapar och i `ggplot2` finns många olika som vi kommer stöta på i detta material. För ett stapeldiagram anger vi `geom_bar()` från engelska termen *bar chart*. 


```r
ggplot(exempeldata) + aes(x = bil) + geom_bar()
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-6-1.png" width="576" style="display: block; margin: auto;" />

För att y-axeln ska visa relativa frekvenser istället för absoluta, kan vi i `geom_bar()` lägga till koden `aes(y = stat(count/sum(count)))` som beräknar värden utifrån antalet (count) dividerat med summan av alla antal. Diagrammet ändrar sig inte i sin form, staplarna är fortfarande lika höga i relation till varandra, men tolkningar av detta diagram kan nu göras i andelar (procent) istället för antal.


```r
ggplot(exempeldata) + aes(x = bil) + geom_bar(aes(y = stat(count/sum(count))))
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-7-1.png" width="576" style="display: block; margin: auto;" />

Med dessa grundkomponenter får vi fram ett diagram, men vi kan väl alla hålla med om att det i detta läge inte ser särskilt snyggt och tydligt ut. Ett snabbt och enkelt sätt att få till lite snyggare diagram är att använda någon utav `ggplot2`s teman som finns tillgängliga genom olika `theme_x()`. Exempelvis är ett stilrent tema att utgå ifrån `theme_bw()` likt:


```r
ggplot(exempeldata) + aes(x = bil) + geom_bar(aes(y = stat(count/sum(count)))) + theme_bw()
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-8-1.png" width="576" style="display: block; margin: auto;" />

Det är nu den största funktionaliteten med `ggplot2` kommer in. Vi kan spara instruktionerna vi gett åt R för att skapa diagrammet ovan och senare lägga till fler instruktioner med andra funktioner genom att använda `+`, på samma sätt som koderna ovan är skrivna. Vi sparar därför de nuvarande instruktionerna i ett objekt som vi kallar för `p` (vi kan döpa denna till vad som helst) likt:


```r
p <- ggplot(exempeldata) + aes(x = bil) + geom_bar(aes(y = stat(count/sum(count)))) + theme_bw()
```

Nu ligger alla instruktioner för **hur** R ska rita upp diagrammet sparat i `p` men för att R också ska producera diagrammet måste vi också ange det för programmet likt:


```r
p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-10-1.png" width="576" style="display: block; margin: auto;" />

Vi kan nu lägga till ytterligare funktioner exempelvis:


```r
p + coord_flip()
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-11-1.png" width="576" style="display: block; margin: auto;" />

eller:


```r
p + scale_y_continuous(labels = scales::percent)
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-12-1.png" width="576" style="display: block; margin: auto;" />

Notera att diagrammet inte roterades i det andra diagrammet när vi ändrade hur skalvärdena på y-axeln ser ut. Eftersom att vi inte sparar de tillagda instruktionerna någonstans kommer endast föregående diagram 

Detta är för att vi endast sagt åt R att rita diagrammet med vardera tillagda instruktion vid två olika tillfällen utan att ha sparat de någonstans. För att R ska spara dessa instruktioner tillsammans med grundkomponenterna vi angivit innan måste vi spara ovanstående kod till ett objekt:


```r
p <- p + scale_y_continuous(labels = scales::percent)

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-13-1.png" width="576" style="display: block; margin: auto;" />

#### Sammanställd data 
Om vi istället för rådata har sammanställd data exempelvis i form utav en frekvenstabell kan vi ändå skapa samma ovanstående diagram. Vi tänker oss att data om bilarna istället för de 64 observationerna är presenterad i följande tabell:

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Table 1: Fördelning av bilmärken i urvalet</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Märke </th>
   <th style="text-align:right;"> Frekvens </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Audi </td>
   <td style="text-align:right;"> 11 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ford </td>
   <td style="text-align:right;"> 9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ingen </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nissan </td>
   <td style="text-align:right;"> 10 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Opel </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Toyota </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Volkswagen </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Volvo </td>
   <td style="text-align:right;"> 14 </td>
  </tr>
</tbody>
</table>

Det som är viktigt är att vi fortfarande i R hanterar denna frekvenstabell som en `data.frame`, då `ggplot` kräver formatet för sina visualiseringar. Datamaterialet ser då istället ut som:


```r
head(exempeltabell)
```

```
##    Märke Frekvens
## 1   Audi       11
## 2   Ford        9
## 3  Ingen        5
## 4 Nissan       10
## 5   Opel        4
## 6 Toyota        5
```

För att skapa diagrammet som vi sett tidigare måste vi lägga till några argument i `aes()` och `geom_bar()` likt koden nedan. Argumentet `stat = "identity"` i `geom_bar()` krävs för att R ska räkna värdet på den angivna y-variabeln som höjden på stapeln.


```r
ggplot(exempeltabell) + aes(x = Märke, y = Frekvens) + geom_bar(stat = "identity") + theme_bw()
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-16-1.png" width="576" style="display: block; margin: auto;" />




#### Färger 
Om vi vill ändra färgen på olika delar av diagrammet exempelvis staplarna kan vi göra detta inuti `geom_bar()` med argumenten `color` för kantlinjerna och `fill` för fyllnadsfärgen. För att se vilka färger som går att ange kan man köra funktionen `colors()` för deras namn eller hämta hem följande [PDF](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf) som har färgerna utskrivna. Vi kommer senare titta närmare på färger och dess funktion i visualiseringar.


```r
p <- ggplot(exempeldata) + aes(x = bil) + 
  geom_bar(fill = "dark orange",
           color = "black",
           aes(y = stat(count/sum(count)))) +
  theme_bw()

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-17-1.png" width="576" style="display: block; margin: auto;" />


#### Stödlinjer 
Nu vill vi ändra lite stödlinjer så att de syns och hjälper till att förtydliga informationen vi vill visa. När det kommer till stapeldiagram behövs inte stödlinjer på x-axeln då staplarna sträcker sig hela vägen ner till dess skalvärden. Däremot behöver vi förtydliga skalvärdena på y-axeln. För att ändra utseendet på olika delar i ett diagram används `theme()` och diverse olika argument däri. Titta i dokumentationen för funktionen för att få en inblick i vad som kan ändras i diagrammet. Oftast ska dessa delar anges med en utav `element`-funktioner, beroende på typen som ska ändras. Text ändras med `element_text()`, linjer med `element_line()` och delar kan helt och hållet tas bort genom `element_blank()`. Nedanstående kod ändrar stödlinjerna på y-axelns färg till lite mörkare grå än standardvärdet (`panel.grid.major` för stödlinjerna som följer skalvärdena, `panel.grid.minor` för stödlinjer emellan skalvärdena) och tar bort stödlinjerna från x-axeln.


```r
p <- p + theme(panel.grid.major.x = element_blank(),
               panel.grid.minor.x = element_blank(),
               panel.grid.major.y = element_line(color = "gray70"),
               panel.grid.minor.y = element_line(color = "gray80"))

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-18-1.png" width="576" style="display: block; margin: auto;" />

#### Text 
Det som saknas just nu i diagrammet är tydligare (och större) text som förklarar de olika delarna av diagrammet för läsaren. De olika etiketterna kan alla anges i samma funktion genom olika argument likt:


```r
p <- p + labs(x = "Bilmärke", y = "Andel", caption = "Källa: Hietala (2019)")

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-19-1.png" width="576" style="display: block; margin: auto;" />

Det vi kan förhålla oss till när vi anger titeln för y-axeln är att den beskriver enheten som används för att mäta axelns skalvärden. Då vi i detta fall har värden mellan `\(0\)` och `\(1\)` bör vi ange *Andel* som titel. Om vi skulle haft absoulta frekvenser skulle en lämplig titel varit *Antal*. Om vi istället för andelar anger skalan i procent likt tidigare diagram kan det diskuteras huruvida det behövs en y-axeltitel eftersom enheten redan är angiven på skalan. Diagrammet skulle då kunna se ut som:


```r
p + scale_y_continuous(labels = scales::percent) + labs(y = "")
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-20-1.png" width="576" style="display: block; margin: auto;" />

Vi kan även ändra andra aspekter av textens **utseende** i diagrammet, exempelvis hur stor den är, dess rotation eller position. Detta görs med olika argument i `theme()`. Vi kan ändra utseendet på axeltexter med `axis.title`, skalvärden med `axis.text` och källhänvisningen med `plot.caption`. Alla dessa delar kräver instruktioner från `element_text()`-funktionen och där kan argument som:

- `angle` styra rotationen, 
- `hjust` och `vjust` styra placeringen horisontellt respektive vertikalt, 
- `size` styra textstorleken,
- `font` styra typsnittet,
- `face` ange en eventuell fet- eller kursivmarkering av texten


```r
p <- p + theme(plot.caption = element_text(face = "italic"),
               axis.title.y = element_text(angle = 0, vjust = 0.5, size = 11),
               axis.title.x = element_text(size = 11),
               axis.text = element_text(size = 10, color = "black"))

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-21-1.png" width="576" style="display: block; margin: auto;" />

#### Skalvärden 
Ibland kan de automatiskt genererade axelskalorna medföra svårigheter att utläsa informationen som vi ska presentera. Därför är det sista vi kommer titta på funktioner för att ändra dessa skalor. Vilken funktion vi vill använda och hur man kan ändra utseendet påverkas av vilken sorts variabel som anges på den specifika axeln. Exempelvis kanske vi vill i diagrammet ändra så att den **kontinuerliga** y-axeln endast visar skalvärden var 10:e procent istället för var 5:e som nu sker. Detta gör vi då via:


```r
p + scale_y_continuous(breaks = seq(from = 0, to = 1, by = .10))
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-22-1.png" width="576" style="display: block; margin: auto;" />

Argumentet `breaks = seq(from = 0, to = 1, by = .10)` anger att vi vill att värden (breaks) ska visas på specifika ställen på axeln. `seq()`-funktionen är ett snabbare sätt att skapa en vektor med lika steglängd mellan värden som vi använder för att skapa `c(0, 0.1, 0.2, 0.3, ..., 1)`. Notera att trots att vi anger värden som går hela vägen upp till 1, kommer inte diagrammet visa detta. 

Om vi skulle vilja visa en större del av axeln kan vi ange skalans gränser med `limits` likt koden nedan. Risken med detta är att vi skapar för mycket onödig tom rityta som minskar utrymmet för den information som vi vill presentera.


```r
p + scale_y_continuous(breaks = seq(from = 0, to = 1, by = .10), 
                       limits = c(0, 0.35))
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-23-1.png" width="576" style="display: block; margin: auto;" />

Något som dock är snyggt att göra med specifikt stapeldiagram är att ta bort den lilla yta som finns under alla staplar och låta y-axeln möta x-axeln vid `y = 0`. Detta kan vi göra med argumentet `expand = c(0,0)`, men då **måste** vi ange gränserna på skalan. 


```r
p <- p + scale_y_continuous(breaks = seq(from = 0, to = 1, by = .10), 
                            limits = c(0, 0.25),
                            expand = c(0,0))
p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-24-1.png" width="576" style="display: block; margin: auto;" />

### SAS EG 

### SPSS 




## Grupperat stapeldiagram {.tabset}
Om vi har ett datamaterial bestående av flera kvalitativa variabler kan vi ibland vilja visualisera fördelningen av en variabel **grupperat** på en annan, exempelvis "Hur ser fördelningen av bilmärken ut, uppdelat på civilstånd?". Det kanske finns några intressanta relationer mellan dessa två variabler som vi skulle vilja undersöka vidare, men som tidigare sagt är visualisering alltid det första steget för att lära känna sitt datamaterial.

I vårt exempeldata har vi två kvalitativa variabler, `civilstand` och `bil`. För att visualisera ett grupperat stapeldiagram behöver vi välja en grupperings- och en fördelningsvariabel. Fördelninsgsvariabeln kommer grupperas över varje enskilda kategori från grupperingsvariabeln. 

### R
I R måste vi ange grupperingsvariabeln likt det vi gjort tidigare som `x` och fördelningsvariabeln som `fill` inuti `aes()`. Detta kommer säga åt R att vardera värde på `bil` ska ha olika fyllnadsfärger. `position = "dodge"` bestämmer att staplarna ska ligga bredvid varandra och `position = "stack"` staplar de ovanpå varandra för ett s.k. stackat stapeldiagram. 


```r
p <- ggplot(exempeldata) + 
  aes(x = civilstand, fill = bil) + 
  geom_bar(position = "dodge") + 
  theme_bw()

p 
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-25-1.png" width="576" style="display: block; margin: auto;" />

För relativa frekvenser i ett grupperat stapeldiagram kan vi summera de visualiserade staplarna på två olika sätt. 

1. Antingen visar vi relativa frekvenser utifrån hela datamaterialet. Detta diagram kommer se exakt likadan ut som den med absoluta frekvenser men med andelar istället för antal. Vi använder samma kod som för det enkla stapeldiagrammet: `aes(y = stat(count/sum(count)))`.


```r
ggplot(exempeldata) + aes(x = civilstand, fill = bil) + 
  geom_bar(aes(y = stat(count/sum(count))), 
           position = "dodge") + 
  theme_bw()
```

2. Alternativet är att visa den relativa fördelningen grupperat på grupperingsvariabeln, alltså att vardera kategoris staplar summerar var för sig till 100 procent. Vi behöver då revidera koden som anger beräkningen till relativa frekvenser till: `aes(y = stat(count/tapply(count, x, sum)[x]))`.


```r
ggplot(exempeldata) + aes(x = civilstand, fill = bil) + 
  geom_bar(aes(y = stat(count/tapply(count, x, sum)[x])), 
           position = "dodge") + 
  theme_bw()
```

<div class="figure" style="text-align: center">
<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-28-1.png" alt="Grupperat stapeldiagram med enkel summering (t.vä.) och gruppvis summering (t.hö.) till 100 procent" width="768" />
<p class="caption">Figure 1: Grupperat stapeldiagram med enkel summering (t.vä.) och gruppvis summering (t.hö.) till 100 procent</p>
</div>

Tolkningarna på vardera av dessa diagram skiljer sig åt och valet styrs av vilken sorts frågeställning som vi vill besvara med visualiseringen. En jämförelse av gruppernas fördelning skulle bli tydlig med en gruppvis summering, medan presentation av fördelningen i materialet kan visualiseras med den enkla summeringen.

#### Förtydliga diagrammet
Oavsett vilket sätt att summera staplarna som används ser de inte alls tydliga ut. Vi förtydligar till diagrammet med liknande hjälpfunktioner som tidigare stapeldiagram. Vi lägger till tydligare kantlinjer på staplarna, lägger till stödlinjer och etiketter, samt justerar utseendet på diverse texter samt ändrar skalan för y-axeln.


```r
p <- ggplot(exempeldata) + 
  aes(x = civilstand, 
      fill = bil) + 
  geom_bar(aes(y = stat(count/sum(count))), 
           position = "dodge",
           color = "black") + 
  theme_bw() + 
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "gray70"),
        panel.grid.minor.y = element_line(color = "gray80"),
        plot.caption = element_text(face = "italic"),
        axis.title.y = element_text(angle = 0, vjust = 0.5, size = 11),
        axis.title.x = element_text(size = 11),
        axis.text = element_text(size = 10, color = "black")) +
  labs(x = "Civilstånd", 
       y = "Andel", 
       caption = "Källa: Hietala (2019)") +
  scale_y_continuous(expand = c(0,0),
                     breaks = seq(0, 0.20, by = 0.05),
                     limits = c(0, 0.16))

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-29-1.png" width="576" style="display: block; margin: auto;" />

#### Färger
Det som också urskiljer ett grupperat stapeldiagram med det skapades tidigare är att vi nu har en legend till höger av diagramytan som innehåller ytterligare information som krävs för att läsa av diagrammet. Vi har fått olika färger på den valda fördelningsvariabeln som kopplas samman till de olika kategorierna. Dessa vill vi nu ändra tillsammans med att ändra lite information i legenden för att göra den tydligare.

För att skapa ett diagram som har en enhetlig och tydlig färgpalett kommer paketet `RColorBrewer` till användning. Ladda paketet med `require(RColorBrewer)` och titta på de olika färgkategorierna som finns att använda genom `display.brewer.all()`. Det rekommenderas att välja någon av de monokromatiska färgskalorna likt `"Oranges"` eller `"Purples"`.

För att revidera utseendet på legenden och de använda färgerna används funktionen `scale_X_manual()` där `X` ersätts med den sorts gruppering som har gjorts för att skapa legenden, i detta fall `fill`. I `values` anges vilka färger som ska användas i diagrammet och där vill vi då använda någon palett från `RColorBrewer` genom `brewer.pal()`-funktionen. Argumentet `n` anger hur många färger vi vill ha och `name` anger vilker palett vi vill ta färgerna från.


```r
p <- p + scale_fill_manual(name = "Bilmärke",
                           values = brewer.pal(n = 8,
                                               name = "Oranges"))

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-30-1.png" width="576" style="display: block; margin: auto;" />

### SAS EG

### SPSS

## Histogram {.tabset}
Om variabeln istället är kvantitativ och vi vill presentera fördelningen av denna variabel, är histogram (eller lådagram) lämpligt att använda.

### R
Likt tidigare diagram i R behöver vi först ange vilket datamaterial samt vilken variabel som vi ska visualisera. 


```r
p <- ggplot(exempeldata) + aes(alder)
```

När väl det är gjort måste vi på samma sätt som tidigare ange vilken form av visualisering som ska göras. För histogram använder vi `geom_histogram()`, med argumentet `bin` som styr hur många klassintervall vi vill ha. Om vi istället vill ange hur breda intervallen ska vara kan vi använda argumentet `binwidth`.


```r
p <- p + geom_histogram(fill = "orange", 
                        color = "black",
                        bins = 10)

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-32-1.png" width="576" style="display: block; margin: auto;" />

Vi kan också snygga till diagrammet med alla funktioner som vi tidigare använt för stapeldiagram.


```r
p <- p + scale_y_continuous(expand = c(0,0), limits = c(0, 20)) +
  theme_bw() + theme(axis.title.y = 
                       element_text(angle = 0, 
                                    hjust = 1, 
                                    vjust = 0.5), 
                     plot.title = 
                       element_text(hjust = 0.5),
                     panel.grid.major.x = 
                       element_blank(),
                     panel.grid.minor.x = 
                       element_blank(),
                     panel.grid.major.y = 
                       element_line(color = "dark gray")) + 
  labs(y = "Antal", 
       x = "Ålder", 
       title = "Fördelning av ålder", 
       caption = "Källa: Hietala (2019)")

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-33-1.png" width="576" style="display: block; margin: auto;" />

### SAS EG

### SPSS

## Lådagram {.tabset}
Ett alternativ att presentera fördelningen för en kvantitativ variabel är lådagram. Denna visualiseringstyp lämpar sig bättre om det finns extremvärden i materialet då diagrammet utgår ifrån kvartiler.


### R
Vi börjar strukturera ett lådagram på samma sätt som vi gjorde med histogrammet, dock behöver vi använda ett knep för att R ska skapa ett snyggt diagram. I `aes()` måste `x = factor(0)` som är ett sätt för R att skapa en tom kategorisk variabel. Lådagrammet skapas med `geom_boxplot()`.

För att ta bort onödiga skalvärden och axelförklaring för den tomma variabeln som vi skapat används värdet `NULL` på de argument som vi vill ta bort, exempelvis `breaks` i `scale_x_discrete()`.


```r
p <- ggplot(exempeldata) + aes(x = factor(0), y = alder) +
  geom_boxplot(fill = "orange") +
  scale_x_discrete(breaks = NULL)

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-34-1.png" width="576" style="display: block; margin: auto;" />

Snyggar till diagrammet som tidigare.


```r
p <- p + theme_bw() + theme(axis.title.y = 
                              element_text(angle = 0, 
                                           hjust = 1, 
                                           vjust = 0.5), 
                            plot.title = 
                              element_text(hjust = 0.5),
                            panel.grid.major.x = 
                              element_blank(),
                            panel.grid.minor.x = 
                              element_blank(),
                            panel.grid.major.y = 
                              element_line(color = "dark gray")) + 
  labs(y = "Ålder", 
       x = NULL, 
       title = "Fördelning av ålder", 
       caption = "Källa: Hietala (2019)")

p
```

<img src="/teaching/732g45/3-beskrivande-statistik_files/figure-html/unnamed-chunk-35-1.png" width="576" style="display: block; margin: auto;" />


