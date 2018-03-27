#install.packages("discretization")
#library(discretization)
library(infotheo)

library(infotheo)

nat <- countries$NATURAL_GROWTH

is.factor(nat) # false / possible continuos
is.numeric(nat) # true

summary(nat)
hist(nat)
nat_grow_cat=cut(nat, br=c(-1.9, 15, 25, 30), labels = c("crec_bajo", "crec_moderado", "crec_alto"))
table(nat_grow_cat)

nat_grow_cat2=cut(nat, 3)
table(nat_grow_cat2)



data(syn.data)
disc <- "equalwidth"
nbins <- sqrt(nrow(syn.data))
ew.data <- discretize(syn.data, disc, nbins)

table(discretize(countries, "cluster", categories=3))
help.search("discretize")

