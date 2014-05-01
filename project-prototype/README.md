Project: Prototype
==============================

| **Name**  | Jeffrey Flint |
|----------:|:-------------|
| **Email** | jeffrey.flint@gmail.com |

## Discussion ##

I created a simulation to compare three bus scheduling algorithms.  I want the visualizations presented here to be able to convince the viewer which algorithm is best.

The data consists of 30 iterations for each algorithm.  Each iteration is a random sample of passenger demand based upon passengers "going home" from work. For each iteration, each algorithm is applied to the same sample so that the comparison is fair. 

###  Raw Data for One Iteration ###

The idea of this visualization is to show service times for one iteration.  Because each algorithm is evaluated under indentical circumstances (the passenger demand is identical), the comparison is "fair".   The hope is to induce a raw feel for the differences between the effects of each algorithm.  It would be possible to to show different iterations in an interactive setting, but this would probably be overwhelming.

![IMAGE](raw.png)


###  Raw Data for One Iteration, By Length of Trip ###

An extension of the above idea, but instead organizing the data by the distance travelled.

![IMAGE](raw2.png)

###  Aggregate Data for all 30 Iterations, By Length of Trip ###

Statistically summarized version over all 30 iterations.  Previous graphics were of only a single iteration.

![IMAGE](range.png)


###  ###

Statistically summarized version over all 30 iterations.  Previous graphics were of only a single iteration.

![IMAGE](gross.png)

