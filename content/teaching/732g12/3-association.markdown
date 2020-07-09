---
# Course title, summary, and position.
weight: 4

# Page metadata.
title: Associations- och sekvensanalys
linktitle: Associations- och sekvensanalys
date: "2020-07-08"
lastmod: "2020-07-08"
draft: false  # Is this a draft? true/false
toc: true  # Show table of contents? true/false
type: docs  # Do not modify.

tags:
- Machine Learning
- Swedish
- Association analysis
- Sequence analysis
- R

output: 
  language:
    label:
      fig: "Figur "
      tab: "Tabell "

# Add menu entry to sidebar.
# - name: Declare this menu item as a parent with ID `name`.
# - weight: Position of link in menu.
menu:
  732G12:
    name: Associations- och sekvensanalys
    parent: 732G12
    weight: 4
---



Det finns flertalet källor som samlar in data för andra ändamål än analys såsom olika register, kundkort vid företag, osv. Dessa datamängder brukar ofta vara väldigt stora och innehålla mycket information som är omöjlig för en vanlig människa att gå igenom. Algoritmer som kan söka ut samband och relationer bland dessa register eller transaktioner kan då vara till hjälp.

## Associationsanalys
För att kunna genomföra associationsanalys med `arules`-paketet måste datamaterialet vara av klasstyp `transactions`. Nedan är ett **förslag** på hur en `data.frame` kan konverteras till `transactions` men fler varianter finns att hitta i klassens dokumentation.


```r
#### Associationsanalys ####
## Konverterar data.frame till transactions-typ som arules kräver. 
trans <- as(split(data_assoc[,"PRODUCT"], data_assoc[,"TRANS_ID"]), "transactions")

# Kan titta i materialet med inspect()
inspect(head(trans, n = 10))

## Kör apriori-algoritmen
rules <- apriori(data = trans, 
                 parameter = list(
                   # Definierar supporttröskeln
                   supp = 0.05, 
                   # Definierar konfidenströskeln
                   conf = 0.5, 
                   # Definierar minsta antalet enheter i sökta enhetsmängder
                   minlen = 1, 
                   # Definierar största antalet enheter i sökta enhetsmängder
                   maxlen = 5)
                 ) 
```

Resultatet från `apriori()` skapas ett objekt av typen `rules` som hanteras lite annorlunda gentemot vad vi kanske är vana vid. För det första används `@` till skillnad från `$` för att plocka ut enskilda delar av objektet och likt `transactions` behöver vi använda funktionen `inspect()` för att kunna se mycket av informationen som finns i dessa delar.

`rules` har också en specifik funktion för `subset()` som kommer från `arules`-paketet. Denna funktion kräver dels objektet som innehåller alla regler samt ett logiskt argument som beskriver vilka regler som ska plockas ut. Här kan argument som `lhs` (vänstersidan av regeln), `rhs` (högersidan av regeln) och olika intressemått användas som urvalsvariabler. Det rekommenderas att också läsa på om hur matchningsfunktionen `%in%` och dess liknande funktioner hanteras.

`as()` kan också användas på detta objekt för att konvertera tillbaka resultatet till en `data.frame` för enklare utforskning och eventuell presentation av tabeller.


```r
## subset-funktionen är väldigt användbar för att vidare plocka ut intressanta regler
inspect(
  subset(
    # Anger vilket objekt som innehåller alla regler
    rules, 
    # Urvalet nedan plockar ut alla regler som har bicuits i högerledet
    subset = rhs %in% "biscuits")) 

## inspect för att plocka ut en tabell över resultatet
inspect(head(rules, n = 5))

## sort används för att sortera utefter någon utav måtten i tabellen
inspect(head(sort(rules, by = "confidence", decreasing = FALSE), n = 5))

## as kan konvertera detta objekt till en data.frame för enklare utforskning av alla reglerna
rules_dat <- as(rules, "data.frame")

head(rules_dat, n = 5)
```

## Sekvensanalys
Sekvensanalys är ett specialfall av associationsanalys där man vill ta hänsyn till tidsaspekten i en databas. 

Den största skillnaden jämfört med associationsanalys är att intressemåtten *konfidens* och *lift* begränsas. För att skapa sekvensregler likt associationsanalysen kan vi använda funktionen `ruleInduction()` med tillhörande konfidenströskel. Problemet här är att vi kommer få ofantligt många fler möjliga regler än i associationsanalysen, p.g.a. den tidsaspekt som finns med. 

### Inläsning av datamaterial
För att konvertera ett datamaterial från rådata-format till det `sequence`-format som paketet `arulesSequences` kräver, behöver vi göra rätt så mycket bearbetning. Koden nedan ger ett exempel på hur vi måste skapa ett material innehållande fyra variabler: 

- en `sekvensID` som beskriver vilken objektsekvens som raden tillhör, 
- en `eventID` som beskriver vilket element i sekvensen som raden tillhör, 
- en `SIZE`-variabel som beskriver hur många händelser som sker i det nuvarande elementet, 
- en `items`-variabel innehållande de händelser som sker i det nuvarande elementet

Vi läser in det bearbetade (och exporterade) materialet från en text-fil med hjälp av `read_baskets()`, men det ska gå att använda `as()` likt konverteringen som gjordes vid associationsanalysen. Dock medför detta **ofta** felmeddelanden som inte alltid går att lösa ut... Rekommenderar att ni läser igenom dokumentationen för `sequences`-klassen för ytterligare exempel på hur man kan läsa in data.


```r
#### Sekvensanalys ####
## För att få till data på rätt sätt måste viss bearbetning av data genomföras
data_seq_reduced <- data_seq[, c("COOKIE", "Click_order", "Webpage")]

## Konverterar sekvensID till numeriska värden
data_seq_reduced$COOKIE <- as.numeric(factor(data_seq_reduced$COOKIE))
data_seq_reduced$Click_order <- as.numeric(data_seq_reduced$Click_order)
data_seq_reduced$SIZE <- rep(1, nrow(data_seq_reduced))
data_seq_reduced <- data_seq_reduced[, c("COOKIE", "Click_order", "SIZE", "Webpage")]

data_seq_reduced <- data_seq_reduced %>% arrange(COOKIE, Click_order)

## För att kunna läsa in materialet med read_baskets() måste alla eventID vara positiva, vi kan inte börja på 0
data_seq_reduced$Click_order <- data_seq_reduced$Click_order + 1

## eventID måste vara strikt ökande med steglängd 1 vilket inte detta datamaterial har
split_data <- split(x = data_seq_reduced$Click_order, f = data_seq_reduced$COOKIE)

data_seq_reduced$Click_order <- unlist(lapply(split_data, FUN = function(x){1:length(x)}))

## Sparar ner materialet utan rad och kolumnnamn eftersom read_baskets() vill endast ha informationen
write.table(data_seq_reduced, "temp.txt", 
            row.names = FALSE, col.names = FALSE)


## Importerar materialet med samma funktion som tidigare, men har nu tagit hänsyn till att tiden finns angiven också
sequences <- read_baskets("temp.txt", sep = " ", 
                          info = c("sequenceID", "eventID", "SIZE"))

inspect(head(sequences, n = 5))

save(sequences, file = "sequences.RData")
```

### cSPADE

cSPADE (`cspade()`) kan endast köras i vanliga `Rgui.exe` inte i RStudio. Jag har försökt leta efter en lösning men det verkar vara problem med RStudios behörigheter att skriva i temporära mappar. Rekommendationen för att lösa detta är att genomföra konverteringen till `sequences` i koden ovan och sedan spara ner en `.RData`-fil genom `save()` som sedan kan importeras i `Rgui.exe` med `load()`. När materialet finns där kan koden nedan köras och `frequent_sequences` kan exporteras via `save()` och importeras via `load()` till RStudio igen för vidare analys.

Nedan följer ett exempel på `cspade()` och dess argument.


```r
## parameter kan användast för att ange tidsbegränsingar och supporttröskeln
frequent_sequences <- 
  cspade(
    # Materialet innehållande alla objektsekvenser
    sequences, 
    # En lista med begränsningar som sätts på algoritmen, här anges både trösklar och tidsbegränsingar
    parameter = list(
      # Supporttröskeln som används
      support = 0.2,
      # Maximala antalet händelser (enheter) som tillåts ske i ett element
      maxsize = 2, 
      # Maximala antalet element som tillåts ske i en sekvens
      maxlen = 4,
      # Minsta tid som krävs mellan intilliggande element i en sekvens
      mingap = NULL,
      # Maximala tid som tillåts mellan intilliggande element i en sekvens
      maxgap = NULL,
      # Maximala tid som tillåts mellan några element i en sekvens
      maxwin = NULL), 
    # Styrinställningar för hur mycket information som visas i console
    control = list(
      verbose = TRUE, 
      tidLists = TRUE)
    )
```

Resultatet från `cspade()` skapas ett objekt av typen `sequences` som återigen ser lite annorlunda ut än vad vi är vana vid. Likt `rules`  används `@` till skillnad från `$` för att plocka ut enskilda delar av objektet. `summary()` ger oss sammanfattande information om enskilda händelser och lite beskrivande statistik över alla sekvenser.


```r
## Laddar en data-fil innehållande de frekventa sekvenserna från cspade()
load("frequent_sequences.RData")

## Ger sammanfattande information om de frekventa sekvenserna
summary(frequent_sequences)

## Konverterar objektet till en data.frame 
as(frequent_sequences, "data.frame")
```

För att plocka ut vissa specifika sekvenser finns även här en specifik version av `subset()` från `arulesSequences`-paketet. Likt tidigare behöver vi ange dels objektet innehållande alla sekvenser vi vill plocka ut, och det logiska argument som styr vilka sekvenser vi är intresserad av. Här kan vi ange argument som:

- `size(x)` som plockar ut sekvenser av angiven storlek,
- `support` som plockar ut sekvenser av angiven support,
- `x %in%` som plockar ut sekvenser som innehåller angivna händelser (enheter)

För att veta vad de olika händelserna heter för att kunna plocka ut de, rekommenderas att titta på `most frequent items:` ur `summary()`.


```r
## Plockar ut sekvenserna som innehåller 2 händelser och specifikt händelsen "product"
inspect(
  subset(
    # Objektet innehållande alla sekvenser
    frequent_sequences, 
    # Urvalet som ska tas ut
    subset = size(x) == 2 & x %in% "\"product\""
    )
  )
```
