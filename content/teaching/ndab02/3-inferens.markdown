---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Statistisk inferens"
linktitle: "Statistisk inferens"
summary:
date: 2020-07-06T23:44:57+02:00
lastmod: 2020-07-06T23:44:57+02:00
draft: true  # Is this a draft? true/false
toc: true  # Show table of contents? true/false
type: docs  # Do not modify.
weight: 4

# Add menu entry to sidebar.
# - Substitute `example` with the name of your course/documentation folder.
# - name: Declare this menu item as a parent with ID `name`.
# - parent: Reference a parent ID if this page is a child.
# - weight: Position of link in menu.
menu:
  ndab02:
    name: Statistisk inferens
    parent: NDAB02
    weight: 3
---



För att kunna dra slutsatser om den målpopulation som vi önskar att undersöka utifrån den mindre grupp enheter som vi samlat in information om, måste vi utföra någon form av inferens. Detta kapitel kommer innehålla många olika metoder och är främst strukturerad kring hur många populationer vi vill utföra inferensen på och sedan med avseende på vilken parameter.

## Inferens i en population
När vi endast är intresserade av att undersöka en population (eller grupp).

### Medelvärden, `\(\mu\)`
För inferens över medelvärden har vi följande krav som måste uppfyllas:

- Oberoende stickprov
  - Kan uppfyllas genom att ett Obundet Slumpmässigt Urval (OSU) har skett 
- Stickprovsmedelvärdet, `\(\bar{X}\)`, måste kunna anses vara normalfördelad
  - Kan uppfyllas med hjälp av Centrala Gränsvärdessatsen (CGS) om stickprovet är *nog stort*, där tumregeln är `\(n > 30\)`. CGS säger att ett medelvärde (eller summa) av lika fördelade variabler kommer vara approximativt normalfördelad i detta fall.
  - Om stickprovet är litet måste istället mätvariabeln, `\(X\)`, som är av intresse anses vara normalfördelad. Detta innebär att den transformation som sker till medelvärdet också kommer vara normalfördelad.


#### Hypotesprövningar
Vid en hypotesprövning av ett medelvärde utgår vi från den femstegsprocess som diskuterats under föreläsningarna. I följande exempel kommer vi titta på variabeln `Sepal.Length` från Iris-datat.

När vi formulerar våra hypoteser gäller det att transformera vad det är vi vill undersöka till matematiska uttryck. Vi behöver också se till att vi använder rätt matematisk symbol i mothypotesen för att testet ska genomföras på rätt sätt. Till skillnad från i SPSS kan vi i R styra vilken sorts mothypotes som vi vill undersöka. 

Vi använder oss utav funktionen `t.test()` som har följande argument som är av intresse:

- `x` - anger vilken variabel som vi vill undersöka,
- `alternative` - anger vilken sorts mothypotes som ska testas där värdena `"two.sided"`, `"less"` eller `"greater"`,
- `mu` - anger det värde som vi vill testa, motsvarande `\(\mu_0\)` i föreläsningarna,
- `conf.level` - anger konfidensgraden för testet, angivet i decimalform.

Exempelvis skulle vi vara intresserade av att undersöka ifall genomsnittslängden av blommornas foderblad (`Sepal.Length` från iris-data)  överstiger 5 cm. Vi ställer då upp hypoteser enligt:

`\begin{align}
H_0: \mu \le 5 \\
H_a: \mu > 5
\end{align}`

Med en signifikansnivå på 5 procent blir funktionen som vi skriver i R som följer:


```r
t.test(x = iris$Sepal.Length, 
       alternative = "greater",
       mu = 5,
       conf.level = 0.95)
```

```
## 
## 	One Sample t-test
## 
## data:  iris$Sepal.Length
## t = 12.473, df = 149, p-value < 2.2e-16
## alternative hypothesis: true mean is greater than 5
## 95 percent confidence interval:
##  5.731427      Inf
## sample estimates:
## mean of x 
##  5.843333
```

I utskriften ser vi väldigt mycket information och, här ser vi en nackdel med R, att utskrifterna inte är tydligt strukturerade likt andra programvaror.

Följande information kan utläsas ur de olika raderna:

- På första raden får vi information om vilken variabel som testet är gjort på. 
- På andra raden får vi information från testet där `t` är den beräknade testvariabeln, `df` är frihetsgraderna i t-fördelningen, och `p-value` är p-värdet av testet. 
- På tredje raden får vi information om vilken sorts mothypotes som har undersökts. 
- På fjärde och femte raden fås ett beräknat konfidensintervall som skulle kunna användas för att besvara mothypotesen. I detta fall då vi har en mothypotes som är angiven som `\(>\)`, beräknas ett nedåt begränsat intervall. 
- De sista raderna i utskriften anger beskrivande mått från stickprovet.

För att kunna ta ett beslut från detta test kan vi direkt jämföra det beräknade p-värdet från utskriften med den angivna signifikansnivån. Om p-värdet är lägre kan vi förkasta `\(H_0\)`, annars kan vi inte förkasta den.

#### Konfidensintervall
För intervallskattningar för ett medelvärde kan samma funktion som för hypotesprövningar, `t.test()`, användas där argumentet `alternative` anger vilken sorts intervall som beräknas. Notera att vi för enkelsidiga intervall måste ange den mothypotes som stämmer överens med begränsningen. 

Ett tips för att bedöma detta är att titta på formuleringen som används i `\(H_a\)` och byta ut värdet som testas med den gräns som vi beräknar. Exempelvis skulle mothypotesen, "mindre än 5" ($H_a: \mu < 5$), resultera i ett uppåt begränsat intervall enligt:

$$ 
\mu < \bar{x} + t_{\alpha(1); n-1} \cdot \frac{s}{\sqrt{n}}
$$
som med R-kod beräknas med:


```r
t.test(x = iris$Sepal.Length, 
       alternative = "less",
       conf.level = 0.95)
```

```
## 
## 	One Sample t-test
## 
## data:  iris$Sepal.Length
## t = 86.425, df = 149, p-value = 1
## alternative hypothesis: true mean is less than 0
## 95 percent confidence interval:
##     -Inf 5.95524
## sample estimates:
## mean of x 
##  5.843333
```
I utskriften är vi endast intresserade av det beräknade konfidensintervallet vilket innebär att vi inte behöver ange något värde på `mu` eftersom det endast påverkar beräkningen av `\(t_{test}\)`.

## Inferens i två populationer

För detta kapitel kommer exemplen använda sig av det inbyggda materialet `PlantGrowth`. Materialet innehåller information om skörden, mätt i den torkade vikten av växten, uppdelad på tre olika grupper, en kontroll och två olika behandlingar. Vi kommer i detta kapitel endast fokusera på de observationer som hör till de olika behandlingarna men kommer titta närmare på alla tre grupper senare. Ett nytt datamaterial innehållande bara de två behandlingarna skapas och döps till `TreatmentPlantGrowth`

Datamaterialet ser ut som följer:

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Table 1: Observerade skördar från växter med olika behandling</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> weight </th>
   <th style="text-align:left;"> group </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 4.81 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.17 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.41 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.59 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.87 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3.83 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6.03 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.89 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.32 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.69 </td>
   <td style="text-align:left;"> trt1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6.31 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.12 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.54 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.50 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.37 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.29 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4.92 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6.15 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.80 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5.26 </td>
   <td style="text-align:left;"> trt2 </td>
  </tr>
</tbody>
</table>


### Medelvärden, `\(\mu\)`
När vi vill jämföra medelvärden i **två** grupper behöver vi utöka de krav som gäller för metoderna:

- Oberoende *inom* vardera stickprov
  - Kan uppfyllas genom att OSU har skett
- Oberoende *mellan* stickproven
  - Om det har genomförts två separata OSU uppfylls detta
  - Om grupperna inte anses påverka varandras mätvärden kan detta antas
- Stickprovsmedelvärdet, `\(\bar{X}\)`, måste kunna anses vara normalfördelad **för båda grupperna**
  - Kan uppfyllas med hjälp av Centrala Gränsvärdessatsen (CGS) om stickprovet är *nog stort*, där tumregeln är `\(n > 30\)`. CGS säger att ett medelvärde (eller summa) av lika fördelade variabler kommer vara approximativt normalfördelad i detta fall.
  - Om antalet i en grupp är litet måste istället mätvariabeln, `\(X\)`, som är av intresse anses vara normalfördelad. Detta innebär att den transformation som sker till medelvärdet också kommer vara normalfördelad.
  
#### t.test()
Likt för en population kommer funktionen `t.test()` användas för hypotesprövningar och konfidensintervall för jämförelser av två gruppers medelvärden. Vi lägger då till två ytterligare argument till dem som vi tidigare använt:

- `y` - anger den andra variabeln som vi vill jämföra med `x`,
- `var.equal` - anger om vi antar att variansen i de två grupperna anses lika (`TRUE`) eller ej (`FALSE`).

I vårt exempeldata i <a href="#tab:plant">1</a> ser vi dock att vi har alla mätvärden i samma variabel, `weight`, och grupptillhörigheten i den andra variabeln, `group`. Detta innebär att vi måste ange variablerna på ett annat sätt i funktionen än `x` och `y`. Detta görs med två andra argument:

- `formula` - anger med formen `mätvariabel ~ gruppvariabel` hur mätvärden ska grupperas och testas,
- `data` - anger datamaterialet där variablerna finns.

I följande kod testar vi huruvida medelvikten på skörden från de två behandlingarna skiljer sig åt. 

Notera att vi här gör ett antagande att vikten av en skörd antas vara normalfördelad då vi endast har 10 observationer från varje grupp och CGS kan inte tillämpas. Om vikten av en skörd är normalfördelad kommer också medelvärdet vara det.

Vi gör också ett antagande om att variansen i mätvariabeln (vikt) hos de båda behandlingarna anses vara lika genom `var.equal = TRUE`. Detta antagande måste dock kunna motiveras.


```r
t.test(formula = weight ~ group,
       data = TreatmentPlantGrowth,
       alternative = "two.sided",
       mu = 0,
       var.equal = TRUE,
       conf.level = 0.95)
```

```
## 
## 	Two Sample t-test
## 
## data:  weight by group
## t = -3.0101, df = 18, p-value = 0.007518
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -1.4687336 -0.2612664
## sample estimates:
## mean in group trt1 mean in group trt2 
##              4.661              5.526
```

När två grupper jämförs liknar utskriften mycket det som kom från ett enkelt t-test. Vi får samma information om testvariabel, frihetsgrader och p-värde, en indikation på vilket test det är som har utförts, och ett tillhörande konfidensintervall för skillnaden.

#### Parvisa observationer
Om vi har samma enhet som mäts under två tidpunkter, eller om enheterna i de olika grupperna påverkar varandra på något sätt kommer inte kravet på oberoende **mellan** grupperna uppfyllas.

I ett exempel (taget från http://www.sthda.com/english/wiki/paired-samples-t-test-in-r) mäts vikten av möss före och efter en okänd behandling. Materialet ser ut som följer:

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Table 2: Observerade vikter av möss före och efter en okänd behandling</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> before </th>
   <th style="text-align:right;"> after </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 200.1 </td>
   <td style="text-align:right;"> 392.9 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 190.9 </td>
   <td style="text-align:right;"> 393.2 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 192.7 </td>
   <td style="text-align:right;"> 345.1 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 213.0 </td>
   <td style="text-align:right;"> 393.0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 241.4 </td>
   <td style="text-align:right;"> 434.0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 196.9 </td>
   <td style="text-align:right;"> 427.9 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 172.2 </td>
   <td style="text-align:right;"> 422.0 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 185.5 </td>
   <td style="text-align:right;"> 383.9 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 205.2 </td>
   <td style="text-align:right;"> 392.3 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 193.7 </td>
   <td style="text-align:right;"> 352.2 </td>
  </tr>
</tbody>
</table>

För att kunna utföra en jämförelse av dessa två gruppernas medelvärden måste vi först beräkna en differens mellan varje parvisa observation och sedan genomföra inferens för en population med hypoteser som ändå stämmer överens med undersökningen eller frågeställningen som man vill besvara. Som tur är kan `t.test()` beräkna detta automatiskt genom att ange ett nytt argument `paired = TRUE` i funktionen.


```r
t.test(x = mice_data$before,
       y = mice_data$after,
       paired = TRUE)
```

```
## 
## 	Paired t-test
## 
## data:  mice_data$before and mice_data$after
## t = -20.883, df = 9, p-value = 6.2e-09
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -215.5581 -173.4219
## sample estimates:
## mean of the differences 
##                 -194.49
```


I utskriften ändras egentligen bara titeln av utskriften gentemot utskriften från det föregående testet av oberoende grupper. Det är dock värt att notera att frihetsgraderna för testet beräknas korrekt utifrån att endast en grupp med differenser testas. Konfidensintervall finns också med i utskriften likt tidigare.

### Icke-parametriska test
Med biologiska data är det vanligt att endast ett fåtal observationer kan samlas in som innebär att inte Centrala Gränsvärdessatsen kan tillämpas för att uppfylla antagandet om en normalfördelad stickprovsstatistika. Vi kan i vissa fall inte heller motivera ett antagande om att mätvariabeln är normalfördelad och måste då frångå metoder som baserar sig på denna fördelning. 

#### Mann-Whitney test
Om vi vill jämföra två stycken **oberoende** grupper kan ett Mann-Whitney-test användas där det enda kravet som måste uppfyllas är just dem om oberoende stickprov. Notera att de kontrolleras på samma sätt som för tidigare tester. 

Lite missledande i R är att detta test kallas för `wilcox.test()`. Argumenten som används i denna funktion är:

- `x` - anger första variabeln,
- `y` - anger andra variabeln,
- `alternative` - anger vilken sorts mothypotes som ska undersökas,
- `conf.level` - anger konfidensgraden för testet
- `exact` - om ett exakt p-värde ska beräknas (det vill vi inte)
- `correct` - om kontinuitetskorrektion ska användas vid normalapproximeringen av p-värdet

Vi kan också ange grupperna som ska jämföras med `formula = mätvariabel ~ gruppvariabel` och `data = datamaterial` likt exemplet nedan.


```r
wilcox.test(formula = weight ~ group,
            data = TreatmentPlantGrowth,
            alternative = "two.sided",
            conf.level = 0.95,
            exact = FALSE,
            correct = FALSE)
```

```
## 
## 	Wilcoxon rank sum test
## 
## data:  weight by group
## W = 16, p-value = 0.01017
## alternative hypothesis: true location shift is not equal to 0
```

Utskriften för detta test är inte lika informationsrik som dem som vi sett tidigare, men det är fortfarande p-värdet som vi är intresserade för beslutsfattande. 

#### Wilcoxon test
Vid parvisa tester av två **beroende** grupper där kravet om en normalfördelad statistika inte uppfylls kan ett Wilcoxon test beräknas istället. I R använder vi samma funktion som innan men måste här ange argumentet `paired = TRUE` för att funktionen ska utföra korrekt test.


```r
wilcox.test(x = mice_data$before,
            y = mice_data$after,
            paired = TRUE,
            alternative = "two.sided",
            conf.level = 0.95,
            exact = FALSE,
            correct = FALSE)
```

```
## 
## 	Wilcoxon signed rank test
## 
## data:  mice_data$before and mice_data$after
## V = 0, p-value = 0.005062
## alternative hypothesis: true location shift is not equal to 0
```

## Jämförelse mellan fler än två grupper
När vi vill jämföra fler än två grupper behöver vi använda oss utav andra metoder för att detta ska ske korrekt. Dessa metoder kallas för ANOVA som betyder ANalysis Of VAriance och tittar specifikt på skillnader i varianserna inom och mellan grupperna. Om en sådan jämförelse visar på att skillnader finns är det av intresse att identifiera mellan vilka specifika grupper som skillnader råder. Då fler än två grupper ska jämföras fungerar inte de tidigare metoderna utan vi måste nu titta på *multipla jämförelser* för att undersöka detta. Vi kommer även titta på fall där kravet om normalfördelning inte uppfylls och frågan måste besvaras med icke-parametriska metoder.

Vi kan även tillämpa ANOVA vid tillfällen då vi har flera faktorer som vi anser påverka mätvariabeln. Vi behöver endast använda *ett* test som samtidigt kan testa för skillnader mellan olika nivåer av respektive faktor samt ifall faktorerna verkar interagera med varandra.

### Envägs-ANOVA
När vi vid tidigare metoder kontrollerade kraven som metoderna har var riskerna vid ett antagande om uppfyllda krav inte så stora. När vi ska använda oss av ANOVA-metoder **måste** följande krav vara uppfyllda, annars kommer slutsatserna som tas inte alls överensstämma med sanningen.

1. Oberoende måste råda **både** *inom* gruppernas observationer och *mellan* grupperna.

2. Mätvariabeln för alla grupper måste verka vara normalfördelad *med lika varians*.

Dessa krav är dock svårt att bedöma och inom denna kurs avgränsar vi oss endast till att veta att dessa krav finns, men kontrollerar dem inte.

Notera att det finns metoder som inte antar lika varians men dessa tas inte upp i denna kurs.

#### F-test
Ett F-test är en form av hypotesprövning där fler än två medelvärden jämförs. Detta betyder att samma fem*stegsprocess som presenterats tidigare i kursen kan användas. Notera att steg 1 om antaganden inte kommer fokuseras på.

Hypoteserna som testas måste här visa att vi dels undersöker medelvärden, samt att vi undersöker ifall det råder en skillnad mellan dessa `\(k\)` grupper. 

`\begin{align*}

H_0 &: \mu_1 = \mu_2 = ... = \mu_k \\
H_a &: \text{Minst två av } \mu_i \text{ i } H_0 \text{ är olika}

\end{align*}`

Alla värden som vi behöver för att kunna ta ett beslut om att förkasta eller inte förkasta den angivna `\(H_0\)` tar vi från en ANOVA-tabell. Funktionen som används i R för att skapa denna tabell är `aov()`.

##### Datastruktur
Innan vi kan gå in på funktionen måste vi strukturera data på ett sätt som möjliggör analys. Vi kommer nu använda den struktur som vi har sett tidigare med en kolumn som indikerar på mätvariabelns värde för varje observation och en grupperingskolumn som anger vilken faktornivå som varje observation tillhör. 

Exempelvis kan data se ut som följer:

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Table 3: Urval av observerade antalet insekter som hittas på områden som behandlas med olika bekämpningsmedel (spray)</caption>
 <thead>
  <tr>
   <th style="text-align:right;"> count </th>
   <th style="text-align:left;"> spray </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> A </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:left;"> B </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 17 </td>
   <td style="text-align:left;"> B </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:left;"> B </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> C </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> C </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> E </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> E </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:left;"> F </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 24 </td>
   <td style="text-align:left;"> F </td>
  </tr>
</tbody>
</table>

#### `aov()`

Funktionen har följande argument:

- `formula` - anger strukturen av modellen med strukturen `mätvariabel ~ grupperingsvariabel`,
- `data` - anger vilket datamaterial som ska analyseras.

Om vi bara skulle köra funktionen likt vi har gjort vid tidigare metoder, kommer vi få en väldigt begränsad utskrift. Istället bör vi spara objektet som funktionen skapar till en ny variabel och använda andra funktioner för att hitta mer detaljerad information. I exemplet nedan sparas ANOVA-analysen i objektet `anova_insect`.


```r
anova_insect <- aov(formula = count ~ spray, data = InsectSprays)
```

För att få ut en ANOVA-tabell används funktionen `summary()`. Det är en funktion som sammanfattar olika objekt på olika sätt, och från `aov()` resulterar det i en ANOVA-tabell likt nedan.


```r
summary(anova_insect)
```

```
##             Df Sum Sq Mean Sq F value Pr(>F)    
## spray        5   2669   533.8    34.7 <2e-16 ***
## Residuals   66   1015    15.4                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Tabellen ser annorlunda ut jämfört med det som vi sett tidigare i SPSS, där den största skillnaden är att en rad för TOTAL saknas i R. Den är egentligen inte viktig då all information som behöver användas för F-testet finns ändå.

I utskriften har vi frihetsgraderna (`Df`), kvadratsummorna SS (`Sum Sq`), medelkvadratsummorna MS (`Mean Sq`), F-testvariabeln (`F-value`) och p-värdet (`Pr(>F)`). 

Notera att R använder sig av vetenskaplig notation vilket innebär att `e` motsvarar den matematiska beräkningen `10 upphöjt till`. I tabellen ovan anges p-värdet som <2e-16 vilket egentligen blir `\(2\cdot 10^{\text{-}16} = 0.0000000000000002\)`.

#### Multipla jämförelser
Om vi i F-testet kan förkasta `\(H_0\)` till förmån för mothypotesen vet vi att det finns en skillnad mellan minst två medelvärden, men inte vilka. Det är nu intressant att göra jämförelser för att bedöma mellan vilka av de `\(k\)` grupper, medelvärdena skiljer sig åt. Denna bedömning görs med metoder som kallas multipla jämförelser som parvist jämför alla grupper med en sammanlagd konfidensgrad.

Dessa jämförelser beräknas i R med ett nytt paket, nämligen `multcomp`. Glöm inte att installera paketet genom `install.packages("multcomp")` och ladda in paketet genom `require(multcomp)`.

#### Tukey-test
Om vi är intresserade av att jämföra alla grupper i vår faktor (även kallad alla faktornivåer) bör vi beräkna **Tukey**-test. Funktionen för dessa beräkningar i R är `TukeyHSD()`. 

Det enda argument som behöver anges är `x` där vi anger det ANOVA-objekt som skapades innan. Vi kan också ändra familje-konfidensen (alltså den konfidensgrad som sammanlagt gäller) med argumentet `conf.level`.


```r
TukeyHSD(x = anova_insect)
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = count ~ spray, data = InsectSprays)
## 
## $spray
##            diff        lwr       upr     p adj
## B-A   0.8333333  -3.866075  5.532742 0.9951810
## C-A -12.4166667 -17.116075 -7.717258 0.0000000
## D-A  -9.5833333 -14.282742 -4.883925 0.0000014
## E-A -11.0000000 -15.699409 -6.300591 0.0000000
## F-A   2.1666667  -2.532742  6.866075 0.7542147
## C-B -13.2500000 -17.949409 -8.550591 0.0000000
## D-B -10.4166667 -15.116075 -5.717258 0.0000002
## E-B -11.8333333 -16.532742 -7.133925 0.0000000
## F-B   1.3333333  -3.366075  6.032742 0.9603075
## D-C   2.8333333  -1.866075  7.532742 0.4920707
## E-C   1.4166667  -3.282742  6.116075 0.9488669
## F-C  14.5833333   9.883925 19.282742 0.0000000
## E-D  -1.4166667  -6.116075  3.282742 0.9488669
## F-D  11.7500000   7.050591 16.449409 0.0000000
## F-E  13.1666667   8.467258 17.866075 0.0000000
```

Utskriften visar alla jämförelser i kolumnen längst till vänster och de efterföljande kolumnerna innehåller differensen i stickprovet, beräknade konfidensintervall, samt p-värdet för testet.

#### Dunnett-test
Om vi har en kontrollgrupp som en av grupperna och vi har ett intresse av att *endast* jämföra alla andra grupper med denna kontrollgrupp bör vi beräkna **Dunnett**-test. Funktionen för detta test, `glht()`, är lite rörig så vi delar upp den i två steg.

Funktionen kräver två argument:

- `model` - anger det ANOVA-objekt som beräknats sedan tidigare,
- `linfct` - anger vilken typ utav funktion (jämförelse) som ska beräknas.

I `linfct` behöver vi ange `mcp(grupperingsvariabeln = "Dunnett")` där `mcp` står för *m*ultiple *c*om*p*arison. 

För att få information som kan användas för att bedöma ifall jämförelsen är signifikant måste vi använda `summary()` på objektet som skapas från denna funktion och det kan göras med hjälp av `%>%` (som ett alternativ till det vi gjorde med `aov()`).

Notera att kontrollgruppen antas vara den första gruppen som finns i materialet. För att ändra denna ordning kan funktionen `relevel(x = grupperingsvariabel, ref = "kontrollgrupp")` användas.


```r
glht(model = anova_insect, linfct = mcp(spray = "Dunnett")) %>%
  summary()
```

```
## 
## 	 Simultaneous Tests for General Linear Hypotheses
## 
## Multiple Comparisons of Means: Dunnett Contrasts
## 
## 
## Fit: aov(formula = count ~ spray, data = InsectSprays)
## 
## Linear Hypotheses:
##            Estimate Std. Error t value Pr(>|t|)    
## B - A == 0   0.8333     1.6011   0.520    0.979    
## C - A == 0 -12.4167     1.6011  -7.755   <1e-04 ***
## D - A == 0  -9.5833     1.6011  -5.985   <1e-04 ***
## E - A == 0 -11.0000     1.6011  -6.870   <1e-04 ***
## F - A == 0   2.1667     1.6011   1.353    0.526    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## (Adjusted p values reported -- single-step method)
```

Utkskriften innehåller i kolumnerna (från vänster till höger) vilka grupper som jämförs, skillnaden i mätvärden, medelfelet, testvariabeln, och till sist p-värdet.

### Icke-parametrisk metod
Om vi inte kan anta att materialet är normalfördelad kan vi istället för ett F-test beräkna ett icke-parametriskt test, som vi kallar för **Kruskal-Wallis**-test.

Hypoteserna benämner vi med ord, inte någon parameter, och de kan se ut som följer:

`\begin{align*}

H_0 &: \text{Det finns inga skillnader mellan grupperna} \\
H_a &: \text{Det finns skillnader mellan grupperna}

\end{align*}`

Funktionen som används för detta test är `kruskal.test()` och argumenten är samma som vi använde för F-testet tidigare, `formula` och `data`.


```r
kruskal.test(formula = count ~ spray, data = InsectSprays)
```

```
## 
## 	Kruskal-Wallis rank sum test
## 
## data:  count by spray
## Kruskal-Wallis chi-squared = 54.691, df = 5, p-value = 1.511e-10
```

Från utskriften kan vi läsa ut ett p-värde (`p-value`) som sedan kan jämföras med signifikansnivån och ta ett beslut.

### Tvåvägs-ANOVA


```r
anova_model <- aov(formula = len ~ supp * dose, data = ToothGrowth)

summary(anova_model)
```

```
##             Df Sum Sq Mean Sq F value   Pr(>F)    
## supp         1  205.4   205.4  12.317 0.000894 ***
## dose         1 2224.3  2224.3 133.415  < 2e-16 ***
## supp:dose    1   88.9    88.9   5.333 0.024631 *  
## Residuals   56  933.6    16.7                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

