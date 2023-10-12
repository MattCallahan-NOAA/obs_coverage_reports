# Load the lattice package if it's not already loaded
if (!require(lattice)) {
  install.packages("lattice")
  library(lattice)
}

if (!require(latticeExtra)) {
  install.packages("latticeExtra")
  library(latticeExtra)
}

# two y axis plot
doubleYScale(p1, p2, use.style = TRUE,
             style1 =  1, style2 =  2,
             add.axis = TRUE, add.ylab2 = FALSE,
             text = NULL, auto.key = if (!is.null(text))
               list(text, points = points, lines = lines, ...),
             points = FALSE, lines = TRUE, under = FALSE)

# remind myself of data str
head(fig10propEM)
head(fig10lnmt)

#filter to one region for test
BSEM<-fig10propEM%>%
  filter(mgmt_area=="BS")

BSLMT<-fig10lnmt%>%
  filter(mgmt_area=="BS")

#create initial plot
p1<-xyplot(lratio ~ year, data = BSLMT, type = 'l',  lwd = 2,
           col = 'blue',
           xlab = 'Year', ylab = 'Ln/mt',
           main = 'BS',
)
p1

#create secondary plot
p2<-xyplot(prop_em ~ year, data = BSEM, type = 'l', col = 'red', lwd = 2,
               ylab = 'Prop EM',

)

p2

#combine
doubleYScale(p1, p2, add.ylab2 = TRUE, col.y.axis="blue", col.y2.axis="red")


p1<-xyplot(lratio ~ year | mgmt_area, data = fig10lnmt, type = 'l',  lwd = 2,
       #col = 'blue',
       xlab = 'Year', ylab = 'Ln/mt',
       #scales="free",
       scales=list(y=list(relation="free"), tck=c(1,0)),
       layout = c(1, 6)

)
p1

p2<-xyplot(prop_em ~ year | mgmt_area, data = fig10propEM, type = 'l', lwd = 2,
           ylab = 'Prop EM',
           scales="free",
           layout = c(1, 6)

)
p2

doubleYScale(p1, p2, add.ylab2 = TRUE, style1=1, style2=4)

# Sample data
data <- data.frame(
  x = 1:10,
  y = c(2, 4, 6, 8, 10, 12, 14, 16, 18, 20)
)

# Create an xyplot with no tickmarks on the x-axis
xyplot(
  y ~ x, data = data, type = 'l', col = 'blue', lwd = 2,
  xlab = 'X-Axis', ylab = 'Y-Axis',
  scales = list(
    x = list(
      at = numeric(0)  # Empty vector to remove tickmarks
    )
  )
)

