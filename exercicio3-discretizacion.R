
nat <- countries$NATURAL_GROWTH

is.factor(nat) # false / possible continuos
is.numeric(nat) # true

summary(nat)
hist(nat)
nat_grow_cat=cut(nat, br=c(-1.9, 15, 25, 30), labels = c("crec_bajo", "crec_moderado", "crec_alto"))
table(nat_grow_cat)

nat_grow_cat2=cut(nat, 3)
table(nat_grow_cat2)

barplot(table(nat_grow_cat))
