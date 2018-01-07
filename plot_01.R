
global <- read.csv('C:/Users/Minkun/Desktop/classes_1/NanoDeg/1.Data_AN/L1/results_global.csv')
str(global) #Dim: 266x2, #factor: NA
sum(is.na(global)) #no NA
head(global,10)

local_DSH <- read.csv('C:/Users/Minkun/Desktop/classes_1/NanoDeg/1.Data_AN/L1/results_DSH.csv')
str(local_DSH) #Dimension: 640x4, #factor : city
table(local_DSH$city) 
head(local_DSH, 10)
sum(is.na(local_DSH)) ##missing value check: 4 NA
apply(apply(local_DSH,2,is.na), 2, sum) #4 NA in 'avg_temp'

# we found factors. let's compare summary of data that the factor has. 
by(local_DSH$avg_temp, local_DSH$city, summary)

# to compare each line-chart within one single plot, we need a dataframe that contains all of them. 
city <- rep('Global', 266) 
global2 <- cbind(city, global); head(global2,10)
glo_cal <- merge(global2, local_DSH, by='year')
glo_cal <- glo_cal[-5]
str(glo_cal) 
sum(is.na(glo_cal))
head(glo_cal,10)

# we Want to find a way to combine two columns of factors into one column without changing the factor levels.
df1 <- data.frame(year=glo_cal$year, city=glo_cal$city.x, avg_temp=glo_cal$avg_temp.x); df1
df2 <- data.frame(year=glo_cal$year, city=glo_cal$city.y, avg_temp=glo_cal$avg_temp.y); df2
df3 <- merge(df1, df2, by=c('year', 'city', 'avg_temp'), all.x = T, all.y = T); head(df3,10)

#before plotting we can check the range of x axis..
range(local_DSH$year) #1743 to 2013


library(ggplot2)
library(gridExtra)
#want to see avg_temp's distribution..in global 
ggplot(aes(x=avg_temp), data = global) + geom_histogram(binwidth = 0.1, color=I('black'), fill=I('#F79420'))
ggplot(aes(x=year, y=avg_temp), data=global) + geom_point()

#want to see avg_temp's distribution..in local by city 
ggplot(aes(x=avg_temp), data = local_DSH) + geom_histogram(binwidth = 0.1, color=I('black'), fill=I('#F79420')) + 
  facet_wrap(~city)
ggplot(aes(x=year, y=avg_temp), data=local_DSH) + geom_point(aes(color=city), alpha=1/5)
ggplot(aes(x=avg_temp), data=local_DSH) + geom_freqpoly(aes(color=city), binwidth =0.1)
ggplot(aes(x=avg_temp, y= ..count../sum(..count..)), data=local_DSH) + geom_freqpoly(aes(color=city), binwidth =0.1)

#want to see summary of those distributions..
ggplot(aes(x=city, y=avg_temp), data=local_DSH) +geom_boxplot() + coord_cartesian(ylim=c(7,22.5))

#correlation b/w year and avg_temp?....well 0.22 ..so not significant...? 
cor.test(local_DSH$avg_temp, local_DSH$year, method = 'pearson')
cor.test(local_DSH$avg_temp, local_DSH$year, method = 'spearman') 

# the relationship is not linear or not monotonic...i mean...not flat..but it must be a cyclical relationship..

#let's zoom in..for a 20 year..
ggplot(aes(x=year, y=avg_temp), data = local_DSH) + geom_point(aes(color=city)) +
  coord_cartesian(xlim = c(1990, 2013)) 




#want to see trends of global
ggplot(aes(x=year, y=avg_temp), data=global) + geom_line()

#want to see trends of D/S/H
ggplot(aes(x=year, y=avg_temp), data=local_DSH) + geom_line() + facet_wrap(~city)

#interpret: well..in general, the trends are highly variable for avg_temp. In 1700 to 1900, the avg_temp is hovering about over
#8ºC but after 1900, the avg_temp soared up from 8ºC to 10ºC with reaching a plateau (temporary layoff) between 1950 to 1975 
#hovering around 8.7ºC, and this rise still continues thesedays. 
#I believe the global temperature underwent dramatic changes with the rise of industrial age around 1900. So we can break the 
#the whole time period into two - before 1900 and after 1900. Our focus is on after 2000!

ggplot(aes(x=year, y=avg_temp), data=subset(global, year<=1900)) + geom_line() + geom_smooth()

ggplot(aes(x=year, y=avg_temp), data=subset(global, year>=1900)) + geom_line() +  
  scale_x_continuous(limits = c(2000,2013), breaks = seq(2000,2013, 2)) + geom_smooth()

  

ggplot(aes(x=year, y=avg_temp), data=subset(local_DSH, year<=1900)) + geom_line() + facet_wrap(~city) + geom_smooth()

ggplot(aes(x=year, y=avg_temp), data=subset(local_DSH, year>=1900)) + geom_line() + facet_wrap(~city) +
  scale_x_continuous(limits = c(2000,2013), breaks = seq(2000,2013, 2)) + geom_smooth()






#smoothing out...with moving averages..
# increasing the size of bins...cutting our graph in pieces and average those mean-counts together. 
# That is, they are lumped into one point.  
# we know that the year variable is very discreet. We'll have the months from January to December, but in reverse,
# we can lump 10 or more years into one point! and they'll repeat over and over again.
# Now I'm going to step every 5 years.

a= ggplot(aes(x=round(year/15)*15, y=avg_temp), data=subset(global, year>=1900)) + geom_line() +  
  scale_x_continuous(limits = c(1900,2013), breaks = seq(1905,2010, 15)) + geom_smooth();a

a2= ggplot(aes(x=round(year/5)*5, y=avg_temp), data=subset(global, year>=1900)) + geom_line(stat = 'summary', fun.y=mean) +  
  scale_x_continuous(limits = c(1900,2013), breaks = seq(1905,2010, 15)) + geom_smooth();a2 
#why summary? coz we want not the collapsed avg_temp, but the means of each piece.
grid.arrange(a, a2, ncol=1)



b= ggplot(aes(x=round(year/15)*15, y=avg_temp), data=subset(local_DSH, year>=1900)) + geom_line() + 
  facet_wrap(~city) + scale_x_continuous(limits = c(1900,2013), breaks = seq(1905,2010, 15)) + geom_smooth(); b

b2= ggplot(aes(x=round(year/5)*5, y=avg_temp), data=subset(local_DSH, year>=1900)) + geom_line(stat = 'summary', fun.y=mean) + 
  facet_wrap(~city) + scale_x_continuous(limits = c(1900,2013), breaks = seq(1905,2010, 15)) + geom_smooth(); b2
#why summary? coz we want not the collapsed avg_temp, but the means of each piece.
grid.arrange(b, b2, ncol=1)




#they are examples of the bias variance tradeoff, and it's similar to the tradeoff we make when choosing the bin width in 
#histograms. One way that analysts can better make this trade off is by using a flexible statistical model to smooth our 
#estimates of conditional means.
c= ggplot(aes(x=year, y=avg_temp), data=df3) + 
  geom_line(aes(color=city)); c

c2= ggplot(aes(x=round(year/5)*5, y=avg_temp), data=subset(df3, year>=1900)) + 
  geom_line(aes(color=city), stat = 'summary', fun.y=mean); c2

grid.arrange(c, c2, ncol=1)






















