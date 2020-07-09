---
# Course title, summary, and position.
weight: 2

# Page metadata.
title: Klassificering
linktitle: Klassificering
date: "2020-07-07"
lastmod: "2020-07-07"
draft: false  # Is this a draft? true/false
toc: true  # Show table of contents? true/false
type: docs  # Do not modify.

tags:
- Machine Learning
- Swedish
- Classification
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
    name: Klassificering
    parent: 732G12
    weight: 2
---



Följande delkapitel exemplifierar hur övervakad inlärning, där vetskap om de sanna utfallen finns, fungerar i R med de tidigare presenterade paketen.

## Uppdelning av datamaterial
För att motverka överanpassning vid övervakad inlärning används en datauppdelning som delar upp det insamlade materialet till en tränings-, validerings- och/eller testmängd. Om tre datamängder ska skapas kan ytterligare en uppdelning av någon av de första skapade mängderna göras.


```r
# Laddar ett datamaterial som ska delas upp
data(iris)

# Uppdelningen sker slumpmässigt vilket innebär att set.seed() bör användas för att få samma observationer i materialen om koden körs igen
set.seed(100)

train_index <- createDataPartition(
  # Ange en vektor av samma längd som antalet observationer i datamaterialet som ska delas upp
  y = iris$Species, 
  # Antalet uppdelningar som ska ske. Måste vara 1!
  times = 1, 
  # Anger andelen observationer som ska väljas ut
  p = 0.80, 
  # Anger att de resulterande observationsindex ska vara en vektor
  list = F)

# Lägger in de p valda observationerna till ett material och 1-p till det andra 
train_data <- iris[train_index,]
other_data <- iris[-train_index,]
```


## Beslutsträd
För att anpassa ett beslutsträd i R används `rpart()`. I koden nedan anges ett urval av de viktigaste inställningarna som styr hur detta träd skapas som bör användas som mall för era modeller. Med `summary()` skrivs trädet ut i text och innehåller **mycket** information. 


```r
tree <- rpart(
  formula = y ~ .,
  data = data_class_train,
  method = "class",
  # Anger föroreningsmått
  parms = list(split = "gini"), 
  
  control = list(
    ## Stopkriterier
    # Anger att antalet observationer som krävs för att en förgrening ska ske
    minsplit = 10,
    # Anger maxdjupet av träder, där 0 är rotnoden
    maxdepth = 30, 
    # Anger den minsta tillåtna förbättringen som måste ske för att en förgrening ska ske
    cp = 0,
    # Två inställningar som inte används mer i detalj
    maxcompete = 0,
    maxsurrogate = 0,
    
    ## Trädanpassning
    # Anger antalet korsvalideringar som ska ske medan modellens tränas, intern validering
    xval = 0, 
    # Tillåter att förgreningar har surrogatregler som kan användas vid saknade värden
    # Ska vara 2 om saknade värden finns i datamaterialet
    usesurrogate = 0
  )
)

## Sammanfattar alla noder, deras klassindelningar och fel
summary(tree, digits = 3) 
```

För att undersöka ifall efterbeskärning ska göras av trädet kan följande kod användas.


```r
### Beskärning av trädet
## Visar komplexiteten vid varje split (C_alpha(T)), ger indikation på huruvida cp argument i rpart bör användas för att reducera komplexitet
printcp(tree, digits = 3)
# Söker ut det cp-värde med minsta validerings-felet för beskärning av trädet
cp <- tree$cptable[which.min(tree$cptable[, "xerror"]), "CP"]

# Beskär trädet
tree_pruned <- prune(tree, cp = cp)
```

För att göra resultatet av beslutsträdet mer visuellt tilltalande kan `plot.tree()` användas. Det finns även andra paket som kan producera ännu snyggare diagram som kanske är lättare att läsa ut, bl.a. `rpart.plot`. 



```r
## Visualiserar trädet
plot(tree, 
     # Justerar placeringen av noder
     uniform = TRUE,
     # Lägger till vita kanter för att inte texten ska försvinna utanför diagrammet
     margin = 0.05) 

## Lägger till information vid varje split i trädet
text(tree, 
     # Lägger till all information i förgreningen
     all = TRUE,
     # Styr storleken av texten som läggs till
     cex = 0.6) 
```

Genom att använda den egenskapade funktionen för modellutvärdering enligt nedan fås en sammanställd utskrift med all information. 


```r
## Utvärdera modellen på träning och validering
class_evaluation(new_data = data_class_train, 
                 model = tree, 
                 true_y = data_class_train$y, 
                 digits = 3)

class_evaluation(new_data = data_class_test, 
                 model = tree, 
                 true_y = data_class_test$y, 
                 digits = 3)
```

## K-närmaste-grannar

```r
#### K närmaste grannar ####
## Skapar datamaterial
data("iris")
set.seed(100)
old_index <- createDataPartition(y = iris$Species, times = 1, p = 0.80, list = F)
old_data <- iris[old_index,]
new_data <- iris[-old_index,]

## Tränar modellen
knn_model <- train(form = Species ~ ., 
                   data = old_data, 
                   method = "knn", 
                   # Standardiserar förklarande variabler
                   preProcess = c("center", "scale"), 
                   trControl = trainControl(
                     # Anger att korsvalidering ska köras
                     method = "repeatedcv", 
                     # Anger antalet k i k-fold korsvalidering, alltså inte k för KNN
                     number = 10, 
                     # Repeterar valideringen tre gånger
                     repeats = 3, 
                     # Anger att manuell val av utforskade k kommer ges, anges i tuneGrid
                     search = "grid"), 
                   # Anger vilka k som ska letas igenom i valideringen
                   tuneGrid = expand.grid(k = c(5, 7, 9, 11, 15, 21, 23)) 
                   ) 

## Predikterar ny data på skattad modell
new_pred <- predict(knn_model, 
                    newdata = new_data, 
                    # "raw" ger majoritetsklassen, 
                    # "prob" ger sannolikheterna (andelen) av grannar
                    type = "raw") 


## Utvärderar modellen
classevaluation(new_data = new_data, model = knn_model, true_y = new_data$Species, type = "raw")

## K-närmaste grannar med viktad avstånd (UNDER UPPBYGGNAD)
wknn_model <- train(form = Species ~ ., # Anger responsvariabeln
                   data = old_data, 
                   method = "kknn",
                   preProcess = c("center", "scale"), 
                   trControl = trainControl(
                     # Anger att korsvalidering ska köras
                     method = "repeatedcv", 
                     # Anger antalet k i k-fold korsvalidering, alltså inte k för KNN
                     number = 10, 
                     # Repeterar valideringen tre gånger
                     repeats = 3)
                   ) 
new_pred <- predict(wknn_model, 
                    newdata = new_data, 
                    # "raw" ger majoritetsklassen, 
                    # "prob" ger sannolikheterna (andelen) av grannar
                    type = "raw") 

class_evaluation(new_data = new_data, model = wknn_model, true_y = new_data$Species, type = "raw")
```

## Neurala nätverk
Genom att använda `keras`-paketet möjliggörs större och mer flexibla nätverk, men paketet har vissa krav som ställs på data och sättet som modellen kodas. Först måste data vara angivet som en matris och responsvariabeln för klassificering behöver transformeras till binär form genom `to_categorical()`.

När nätverket sedan skapas bygger vi först upp en arkitektur med olika lager, ex. `layer_dense()`, och sedan anger vi hur modellen ska anpassas m.h.a. `compile()`. Själva anpassningen startas sedan med `fit()`. 



```r
#### Neurala Nätverk ####

# Laddar data likt Keras vill ha det strukturerat, måste vara matriser!
x_train <- as.matrix(data_class_train[, -which(colnames(data_class_train) == "y")])
x_test <- as.matrix(data_class_test[, -which(colnames(data_class_test) == "y")])

# Omstrukturerar kategorsk variabel till binär form
y_train <- to_categorical(data_class_train[, which(colnames(data_class_train) == "y")], num_classes = 10)
y_test <- to_categorical(data_class_test[, which(colnames(data_class_test) == "y")], num_classes = 10)


## Modell
# Skapar grundmodell
nn_model <- keras_model_sequential()

# Skapar arkitekturen
nn_model %>%
  ## Definierar första lagret, input_shape ska anges för att definiera hur många förklarande variabler som finns i data
  layer_dense(
    # Anger antal gömda noder i det GÖMDA lagret
    units = 256, 
    # Anger aktiveringsfunktionen i lagret
    activation = "relu", 
    # Det första gömda lagret anger hur många förklarande variabler som ska kopplas till lagret
    # Notera att input_shape styr input-lagret, units styr det gömda lagret
    input_shape = c(ncol(x_train)),
    # Anger att vi vill ha med en bias-term i lagret
    use_bias = TRUE, 
    name = "First"
    ) %>%
  ## Definierar andra lagret
  layer_dense(
    units = 128,
    activation = "relu",
    use_bias = TRUE,
    name = "Second"
    ) %>%
  ## Anger det sista lagret där antalet units är antalet kategorier
  layer_dense(
    units = 10, 
    activation = "softmax", 
    name = "Final/Output"
    )

## Anger en översiktsbild av den angivna arkitekturen
summary(nn_model)

## Definierar vilken anpassningsalgoritm som modellen ska skattas med
nn_model %>% compile(
  # Anger förlustfunktionen som vi vill använda. Denna styrs direkt av vilken typ av y-variabel som finns i data
  loss = 'categorical_crossentropy', 
  # Inlärningstakt av inkrementell inlärning
  optimizer = optimizer_sgd(lr = 0.01), 
  # Anger att träffsäkerheten ska användas som mått för utvärdering
  metrics = c('accuracy') 
)

## Anpassar modellen
history <- nn_model %>% fit(
  # Anger data
  x = x_train, y = y_train, 
  
  # Maximala antalet gånger alla observationer i träningsmängden ska gås igenom innan anpassningen avslutas
  epochs = 30, 
  
  # Anger hur många observationer som ska gås igenom innan vikterna uppdateras, här kan man ändra till batch-learning genom att ange nrow(x_train)
  batch_size = 128, 
  
  # Anger hur mycket av träningsdatat som ska användas som valideringsmängd. 
  # Plockar ur data indexerat från slutet, så var vaksam på att data måste vara slumpat innan
  # Om man har en separat valideringsmängd används validation_data = data
  validation_split = 0.25 
)

plot(history)

# Notera att för denna funktion måste y vara i klass-form, inte binärt som används i keras-funktionerna ovan
class_evaluation(new_data = x_train, 
                 model = nn_model, 
                 true_y = data_class_train$y)

class_evaluation(new_data = x_test, 
                 model = nn_model, 
                 true_y = data_class_test$y)
```


