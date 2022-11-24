# Hoofdstuk 2: Intro PowerBI


Als we **één kolom** hebben: 

```
Sales = SUM(Sales[Amount])
```

Als we een bewerking willen uitvoeren met **meerdere kolommen**:

```
Revenue = SUMX(Sales, Sales[Amount] * Sales[UnitPrice])
```

Voeg een nieuwe 
```
Sales Price = [UnitPrice] - [Discount]
```

# Hoofdstuk 3: Cardinaliteit


## Columns

Toon de current stock. Er is maar voor iedere lijn één product.
```
Current Stock = RELATED('Product'[UnitsInStock])
```

Voeg een extra kolom toe. Van iedere ordernummer gaat er gekeken worden hoeveel orderlines er zijn. Een bestelling met vijf orderlines zal '5' hebben. Zonder de **RELATEDTABLE** zal je het volledige totaal krijgen.

```
Number Of Orders = COUNTROWS(RELATEDTABLE(OrderLine)) 
```

Bereken de totale sales per klant:

```
Total Sales = SUMX(RELATEDTABLE(OrderLine), OrderLine[Amount] * OrderLine[Price])
```


## Measures

Toon het aantal unieke employees.

```
Number of Employees = COUNTROWS(Employee)
```

Toon het aantal uur dat gespendeerd werd aan een project.

```
Number of Hours = SUM(ProjectHours[Hours])
```

Toon het aantal projecten waar iedere werknemer aan werkt. Hou rekening dat een werknemer soms aan meerdere projecten kan meewerken.

```
Number of Projects = DISTINCTCOUNT(ProjectHours[ProjectNumber])
```

Toon het aantal prioriteiten voor iedere werknemer. Gelijk als een Inner Join.

```
Number of Priorities = 
CALCULATE(
    DISTINCTCOUNT(Project[Priority]), 
    CROSSFILTER(ProjectHours[ProjectNumber], Project[ProjectNumber], Both
)
```

# Hoofdstuk 4: DAX functies

Gebruik de relatie tussen de twee tabellen. 

```
Revenue Checkout = 
CALCULATE(
    COUNTROWS(Reservation),
    USERELATIONSHIP(DateTable[Date], Reservation[Checkout])
)
```

## SUMX

* Enkel één filter

Zoek naar alle sales waar er minstens drie artikelen verkocht werden.

```
Revenue > 3 = SUMX(FILTER(Sales, Sales[Amount] > 3), [Revenue])
```

Geen rekening houden met de filter-context.

```
Revenue ALL table = SUMX(ALL(Sales), [Revenue])
```

Bereken de totale revenue opgesplitst per gegeven kolom:

```
Revenue ALL Column = SUMX(All(Sales[Gender]), [Revenue])
```

Bereken de totale revenue. 'All(Sales)' cancelled de filter-context.

```
Revenue ALL > 3 = SUMX(
    FILTER(
        ALL(Sales), Sales[Amount] > 3
    ), [Revenue]
)
```

...

```
Tonnage with SUMX = SUMX(
    RELATEDTABLE(Peppers), Peppers[NumberOfTons]
)
```

## Calculate

* Meerdere filters mogelijk

```
Total tonnage = CALCULATE( 
    [Tonnage], All(Country[CountryName])
)
```

Divide --> percentage berekenen met de waarde per eenheid / de totale waarde.

```
%Country = DIVIDE(
    [Tonnage], [Total Tonnage countries]
)
```

Enkel de Duitse pepers:

```
Tonnage Germany = CALCULATE(
    [Tonnage], FILTER(
        ALL(Country[CountryName]), Country[CountryName] = "Duitsland"
    )
)
```

Enkel de rode Duitse pepers:

```
Tonnage Germany = CALCULATE(
    [Tonnage], 
    FILTER(ALL(Country[CountryName]), Country[CountryName] = "Duitsland",
    FILTER(ALL(Peppers[Color]), Peppers[Color]="Rood")
    )
)
```

Enkel de Scandinavische landen:

```
Scan only = CALCULATE(
    [Tonnage],
    FILTER(VALUES(Country[CountryName]), Country[CountryName] IN {
        "Noorwegen", "Zweden", "Finland"
    })
)
```

# Hoofdstuk X: Dimensionality Reduction

Veel features:
* MNIST: 748 features (pixel-waarden)
* Aantal verminderen en nog steeds een gelijk resultaat behouden.


Aanpak bij MNIST
* Aantal pixels verminderen --> Twee pixels naast elkaar in één kolom.
* De witte pixels op de image borders verwijderen.


Swiss Roll
* Unroll
* Manifold learning

PCA:
* Meerdere projecties: 
  * Het aantal lijnen hangt af van het aantal features.
  * De lijn/projectie kiezen met de maximumvariantie.
  * SVD gebruiken --> V bevat alle PC's


# Hoofdstuk X: Clustering

*Unsupervised learning*
* Data gaan groeperen waarvan we zelf geen groepering kennen.
* Een zicht krijgen op de data. 
* Groeperingen ontdekken.

Manieren:
* K-mean
  * Kortste afstand tussen het centrum van een cluster en de node.
  * k = 5 --> 5 centrale punten plaatsen
  * optimale 'k' achterhalen? 
    * **Inertia**: hoe goed is de clustering: de afstand tussen het centrale punt en de datapunten
    * **Silhouette score**: coëfficient tussen -1 en 1:
      * dicht bij 1 = goed / dicht bij -1 = niet goed en mogelijks deel uit van de verkeerde cluster

| Manier | Uitleg |
| -- | -- |
| K-mean | De kortste afstand tussen het centrale punt (centroid) en het datapunt. Als k = 5, dan wordt er bij de start vijf centrale punten geplaatst. |
| DBSCAN | Hoeveel instanties per epsilon (e). Alle instanties in de nabijheid. Het aantal instanties in de buurt (epsilon neighbours). |
| Gaussian | Ellipsen herkennen. Het algoritme gaat er van uit dat alle clusters in de vorm van een Gaussiaanse distributie is gemaakt. Iedere cluster kan een eigen vorm aannemen. |
| Hierarchical clustering | Vaak bij weinig invoer data. Niet zo druk (density). We hebben een distance-functie. We rangschikken de afstand tussen twee punten van klein naar groot. |

* Gaussian
  * Ellipsen
* Hierarchical
  * ...
* DBSCAN
  * ...



