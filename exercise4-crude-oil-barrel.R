barrel_labels <- c("NAME", "CRUDE_OIL_BAR_DAY")
barrels <- countries[barrel_labels]

barrels <- barrels[rowSums(is.na(barrels)) == 0,]
head(barrels)
barrels$CRUDE_OIL_BAR_DAY <- barrels$CRUDE_OIL_BAR_DAY / 10e2
head(barrels)


barplot(barrels$CRUDE_OIL_BAR_DAY
        , main="Oil barrels per country"
        , horiz=TRUE
        , ylab = "Countries"
        , names.arg=barrels$NAME
        , xlab = "valores x 1000"
        , cex.names=0.6
        , col = rainbow(length(unique(barrels$NAME))))
