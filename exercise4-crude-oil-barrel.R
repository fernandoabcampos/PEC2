barrel_labels <- c("NAME", "CRUDE_OIL_BAR_DAY")
barrels <- countries[barrel_labels]

barrels <- barrels[rowSums(is.na(barrels)) == 0,]
head(barrels)
barrels$CRUDE_OIL_BAR_DAY <- barrels$CRUDE_OIL_BAR_DAY / 10e2
head(barrels)


par(las=2) # make label text perpendicular to axis
par(mar=c(5,8,4,2)) # increase y-axis margin.

barplot(barrels$CRUDE_OIL_BAR_DAY
        , main="Oil barrels per country"
        , horiz=TRUE
        , ylab = "Countries"
        , names.arg=barrels$NAME
        , xlab = "valores x 1000"
        , cex.names=0.8
        , col = rainbow(length(unique(barrels$NAME))))
