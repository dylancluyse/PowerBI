# Association Rule Mining

Apriori --> wat is er relevant om naar te kijken? Welke itemsets hebben een hoge support?

## Excercises:

1. EX1


| Functie | Verhouding | Uitleg |
| -- | -- | -- |
| supp(trousers ==> belt): | 4/7 | Het aantal wagentjes met trousers & belts vergeleken met het totaal. |
| conf(trousers ==> belt): | 4/5 | Het aantal wagentjes waar trousers eerst voor belts komen. |
| conf(belts ==> trousers): | 4/4 | Het aantal wagentjes waar belts voor trousers komen. |
| lift(trousers ==> belts): | 7/5 | Support(trousers==>belts) / support (trousers) * support(belts). Als je een broek koopt, dan is de kans groter dat je een riem koopt dan dat statistisch is waargenomen. |

1. EX2

| Item Set | Support |
| -- | -- |
| i1 | 4 | 
| i2 | 5 | 
| i3 | 4 | 
| i4 | 4 | 
| i5 | 2 | 

| Item Set | Support |
| -- | -- |
| i1, i2 | 4 | 
| i1, i3 | 5 | 
| i3 | 4 | 
| i4 | 4 | 
| i5 | 2 | 