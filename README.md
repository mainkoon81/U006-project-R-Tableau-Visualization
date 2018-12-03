# project-R-Tableau-Visualization

### [Contents] 

__Part-01.__ Exploring Weather Trends
  - language: R
  - func:

__Part-02.__ 
  - language: R
  - func:

__Part-03.__ 
  - language: Tableau
  - func: 
  - Tableau Public: https://public.tableau.com/profile/minkun.kim#!/ 

----------------------------------------------------------------------
#### >Part-01. Exploring Weather Trends

__Data:__ The Data were collected from (https://www.carbonbrief.org/explainer-how-do-scientists-measure-global-temperature)
There are three tables in the database:
 - city_list :  This contains a list of cities and countries in the database. 
 - city_data :  This contains the average temperatures for each city by year (ºC).
 - global_data :  This contains the average global temperatures by year (ºC).

__Story:__ Global temperature has been a hot topic in recent years as politicians argue over climate policy. Temperature data around the world is an important part of this conversation. To measure temperature data, scientists combine measurements from the air and ocean surface. This data is collected by weather stations on land and in the ocean. I want to analyze LOCAL and GLOBAL temperature data to compare 'the temperature trends where I live' TO 'overall global temperature trends'. This project requires the following steps:
  -	Extract data from a database using a SQL query
  -	Calculate a moving average in a spreadsheet
  -	Create a line chart in a spreadsheet
  > __“Moving averages”__ are used to smooth out data to make it easier to observe long term trends and not get lost in daily fluctuations. For example, let's say we wanted to visualize the sales trend at a clothing retail store. We start with daily data, and our chart looks too volatile to interpret because more people shop on the weekends, so sales spike on those days. We could sum up sales by week, but that may take out some of the detail we wanted to see. Using a “moving average”, we can both smooth out the daily volatility and observe the long term trend. So how to calculate a moving average? 
Let’s say the dataset contains ‘daily sales data’ from 01-01-2009 to 03-31-2009. To start, create a new column called “7-day MA”, which is where the moving average field will be stored. Then, calculate the average sales for the first 7 days of sales, then next 7 days, next 7 days, and so on. 7 days’ MA, 12 days’ MA, who cares? 

__Investigation:__ Is your city hotter or cooler on average compared to the global average? Has the difference been consistent over time? How do the changes in your city’s temperatures over time compare to the changes in the global average? What does the overall trend look like? Is the world getting hotter or cooler? Has the trend been consistent over the last few hundred years?

 - Step 01. Extract the data from the database.(global/local)
```
SELECT *
FROM global_data ;

SELECT *
FROM city_data
WHERE city IN ('Dublin','Seoul','Houston');
```
 - Step 02. Open up the CSV (via R).
```
global <- read.csv('C:/Users/Minkun/Desktop/classes_1/NanoDeg/1.Data_AN/L1/results_global.csv')
str(global)  #Dimension: 266x2, #factor: NA
sum(is.na(global))  #missing value check: no NA
head(global,10)

local_DSH <- read.csv('C:/Users/Minkun/Desktop/classes_1/NanoDeg/1.Data_AN/L1/results_DSH.csv')
str(local_DSH)  #Dimension: 640x4, #factor: city
table(local_DSH$city)  
sum(is.na(local_DSH))  #missing value check: 4 NA 
apply(apply(local_DSH,2,is.na), 2, sum)  #4 NA in 'avg_temp in Dublin'
head(local_DSH, 10)
```
We found factors. let's compare summary of data that the factor has. 
```
by(local_DSH$avg_temp, local_DSH$city, summary)
```
<img src="https://user-images.githubusercontent.com/31917400/35399901-521af376-01ed-11e8-96ea-3edab8ba62d2.jpg" width="450" height="450" />

Create a line chart that compares your **city’s temperatures** with the **global temperatures**.
 - To compare each line-chart within one single plot, we need a dataframe that contains all of them. 
```
city <- rep('Global', 266) 
global2 <- cbind(city, global); head(global2,10)
glo_cal <- merge(global2, local_DSH, by='year')
glo_cal <- glo_cal[-5]
str(glo_cal) 
sum(is.na(glo_cal))
head(glo_cal,10)
```
 - To find a way to combine two columns of factors into one column without changing the factor levels
```
df1 <- data.frame(year=glo_cal$year, city=glo_cal$city.x, avg_temp=glo_cal$avg_temp.x); df1
df2 <- data.frame(year=glo_cal$year, city=glo_cal$city.y, avg_temp=glo_cal$avg_temp.y); df2
df3 <- merge(df1, df2, by=c('year', 'city', 'avg_temp'), all.x = T, all.y = T); head(df3,10)
```
<img src="https://user-images.githubusercontent.com/31917400/35413929-df134bfe-0218-11e8-9732-77a67f7bd515.jpg" width="480" height="450" />

 - Plot I: We want to see `avg_temp`'s distribution in global - The average temp in global seems to be normally distributed. 
```
library(ggplot2)
library(gridExtra)

ggplot(aes(x=avg_temp), data = global) + geom_histogram(binwidth = 0.1, color=I('black'), fill=I('#F79420'))
```
<img src="https://user-images.githubusercontent.com/31917400/35414135-88a2c1cc-0219-11e8-8828-8413db1b1cd0.jpeg" />

 - Plot II: We want to see `avg_temp`'s distribution in local by city- Dublin / Seoul / Houston - The average temp in each city seem to be normally distributed. Interestingly, the avg_temp trend in Dublin shows much stronger consistency compared to the other two cities, which is underpinned by the heavy concentration around the mean of its avg_temp’s counts. 
```
ggplot(aes(x=avg_temp), data = local_DSH) + geom_histogram(binwidth = 0.1, color=I('black'), fill=I('#F79420')) + 
  facet_wrap(~city)
ggplot(aes(x=avg_temp), data=local_DSH) + geom_freqpoly(aes(color=city), binwidth =0.1)
ggplot(aes(x=avg_temp, y= ..count../sum(..count..)), data=local_DSH) + geom_freqpoly(aes(color=city), binwidth =0.1)
```
<img src="https://user-images.githubusercontent.com/31917400/35414406-48819766-021a-11e8-82cd-75e45f8beeaf.jpeg" />

 - We want to examine correlation between year and avg_temp. - Well…it’s 0.228 which is closer to 0. So we can Say that the relationship is not that significant, or the relationship is not linear or not monotonic. I mean not flat, but it can be a cyclical relationship.
```
cor.test(local_DSH$avg_temp, local_DSH$year, method = 'pearson')
cor.test(local_DSH$avg_temp, local_DSH$year, method = 'spearman')
```
/// 0.2286571, 0.3798407

 - So let's zoom in for a 20 year interval - We can check some cyclical relationships.
```
ggplot(aes(x=year, y=avg_temp), data = local_DSH) + geom_point(aes(color=city)) +
  coord_cartesian(xlim = c(1990, 2013)) 
```
<img src="https://user-images.githubusercontent.com/31917400/35415261-e754c0c8-021c-11e8-9dac-e64ce7cae448.jpeg" width="480" height="300" />

 - We want to see trends of global
```
ggplot(aes(x=year, y=avg_temp), data=global) + geom_line()
```
<img src="https://user-images.githubusercontent.com/31917400/35415374-43f629d4-021d-11e8-8f09-7bfce33186d5.jpeg" width="430" height="260" />

 - We want to see trends of Dublin/Seoul/Houston
```
ggplot(aes(x=year, y=avg_temp), data=local_DSH) + geom_line() + facet_wrap(~city)
```
<img src="https://user-images.githubusercontent.com/31917400/35415448-8af2754a-021d-11e8-80b0-ccd77e1c30b0.jpeg" width="430" height="260" />

well..in general, the global trends are highly variable for avg_temp. In 1700 to 1900, the avg_temp is hovering about over 8ºC but after 1900, the avg_temp soared up from 8ºC to 10ºC with reaching a plateau (temporary layoff) between 1950 to 1975 hovering around 8.7ºC, and this rise still continues these days. I believe the global, and major cities temperature underwent dramatic changes with the rise of industrial age around 1900. So we can break the whole time period into two - before 1900 and after 1900. AND Our focus is on after 2000! 
```
ggplot(aes(x=year, y=avg_temp), data=subset(global, year>=1900)) + geom_line() +  
scale_x_continuous(limits = c(2000,2013), breaks = seq(2000,2013, 2)) + geom_smooth()
```
<img src="https://user-images.githubusercontent.com/31917400/35415525-d16542c8-021d-11e8-9d0a-f1b766617d5a.jpeg" width="430" height="260" />

What we can see here is that first, the global trend shows more variability than those of other major cities selected. 
```
ggplot(aes(x=year, y=avg_temp), data=subset(local_DSH, year>=1900)) + geom_line() + facet_wrap(~city) +
  scale_x_continuous(limits = c(2000,2013), breaks = seq(2000,2013, 2)) + geom_smooth()
```
<img src="https://user-images.githubusercontent.com/31917400/35415590-0e5a3c60-021e-11e8-986a-773d67b83d73.jpeg" width="430" height="260" />

__[Smoothing out with moving averages]__

If increasing the size of bins, cutting our graph in pieces and averaging those mean-counts together, we can make them lumped into one points. We know that the year variable is very discreet. We'll have the months from January to December, but in reverse, we can lump 10 or more years into one point! and they'll repeat over and over again. Now I want to step every 15 years and every 5 years, then compare them. #why summary? coz we want not the collapsed avg_temp, but the means of each piece.
```
a= ggplot(aes(x=round(year/15)*15, y=avg_temp), data=subset(global, year>=1900)) + geom_line() +  
  scale_x_continuous(limits = c(1900,2013), breaks = seq(1905,2010, 15)) + geom_smooth();a

a2= ggplot(aes(x=round(year/5)*5, y=avg_temp), data=subset(global, year>=1900)) + geom_line(stat = 'summary', fun.y=mean) +  
  scale_x_continuous(limits = c(1900,2013), breaks = seq(1905,2010, 15)) + geom_smooth();a2 
  
grid.arrange(a, a2, ncol=1)
```
<img src="https://user-images.githubusercontent.com/31917400/35415735-911eb8ba-021e-11e8-832d-5982898545e1.jpeg" width="430" height="260" />

```
b= ggplot(aes(x=round(year/15)*15, y=avg_temp), data=subset(local_DSH, year>=1900)) + geom_line() + 
  facet_wrap(~city) + scale_x_continuous(limits = c(1900,2013), breaks = seq(1905,2010, 15)) + geom_smooth(); b

b2= ggplot(aes(x=round(year/5)*5, y=avg_temp), data=subset(local_DSH, year>=1900)) + geom_line(stat = 'summary', fun.y=mean) + 
  facet_wrap(~city) + scale_x_continuous(limits = c(1900,2013), breaks = seq(1905,2010, 15)) + geom_smooth(); b2

grid.arrange(b, b2, ncol=1)
```
<img src="https://user-images.githubusercontent.com/31917400/35415827-e81f053e-021e-11e8-8bf2-7e3500195949.jpeg" width="430" height="260" />

### PUT THEM TOGETHER
```
c= ggplot(aes(x=year, y=avg_temp), data=df3) + 
  geom_line(aes(color=city)); c

c2= ggplot(aes(x=round(year/5)*5, y=avg_temp), data=subset(df3, year>=1900)) + 
  geom_line(aes(color=city), stat = 'summary', fun.y=mean); c2

grid.arrange(c, c2, ncol=1)
```
<img src="https://user-images.githubusercontent.com/31917400/35415908-261753a0-021f-11e8-8170-64c1cce01150.jpeg" width="430" height="260" />

----------------------------------------------------------------------
#### >Part-02. Investigating Wine Quality

__Data:__ 




----------------------------------------------------------------------
#### >Part-03. Airline On-Time Statistics and Delay Causes_2008

__Data:__ The Data were collected from(http://stat-computing.org/dataexpo/2009/the-data.html)

There are 29 fileds in the dataset:
 - 1	Year:	2008
 - 2	Month: 1-12
 - 3	DayofMonth:	1-31
 - 4	DayOfWeek:	1 (Monday) - 7 (Sunday)
 - 5	DepTime	actual departure time: (local, hhmm)
 - 6	CRSDepTime	scheduled departure time: (local, hhmm)
 - 7	ArrTime	actual arrival time: (local, hhmm)
 - 8	CRSArrTime	scheduled arrival time: (local, hhmm)
 - 9	UniqueCarrier:	unique carrier code(http://stat-computing.org/dataexpo/2009/supplemental-data.html)
 - 10	FlightNum:	flight number
 - 11	TailNum:	plane tail number
 - 12	ActualElapsedTime:	in minutes
 - 13	CRSElapsedTime:	in minutes
 - 14	AirTime:	in minutes
 - 15	ArrDelay:	arrival delay, in minutes
 - 16	DepDelay:	departure delay, in minutes
 - 17	Origin:	origin IATA airport code(http://stat-computing.org/dataexpo/2009/supplemental-data.html)
 - 18	Dest:	destination IATA airport code(http://stat-computing.org/dataexpo/2009/supplemental-data.html)
 - 19	Distance:	in miles
 - 20	TaxiIn:	taxi in time, in minutes
 - 21	TaxiOut:	taxi out time in minutes
 - 22	Cancelled:	was the flight cancelled?
 - 23	CancellationCode:	reason for cancellation (A = carrier, B = weather, C = NAS, D = security)
 - 24	Diverted:	1 = yes, 0 = no
 - 25	CarrierDelay:	in minutes
 - 26	WeatherDelay:	in minutes
 - 27	NASDelay:	in minutes
 - 28	SecurityDelay:	in minutes
 - 29	LateAircraftDelay:	in minutes
 
The data comes originally from RITA where it is described in detail(https://www.transtats.bts.gov/Fields.asp?Table_ID=236)

__Story:__ The U.S. Department of Transportation's (DOT) Bureau of Transportation Statistics (BTS) tracks the on-time performance of domestic flights operated by large air carriers. Summary information on the number of on-time, delayed, canceled and diverted flights appears in DOT's monthly Air Travel Consumer Report(https://www.transportation.gov/airconsumer/air-travel-consumer-reports), published about 30 days after the month's end, as well as in summary tables posted on this website. BTS began collecting details on the causes of flight delays in June 2003. Summary statistics and raw data are made available to the public at the time the Air Travel Consumer Report is released(https://www.transtats.bts.gov/OT_Delay/OT_DelayCause1.asp)
 - Delay Cause Definition(https://www.bts.dot.gov/explore-topics-and-geography/topics/airline-time-performance-and-causes-flight-delays)
 - Understanding Delay Data(https://www.bts.gov/topics/airlines-and-airports/understanding-reporting-causes-flight-delays-and-cancellations)
 - Flight Delays at a Glance(https://www.transtats.bts.gov/HomeDrillChart.asp)

## Investigate the performance of flights over time or simply look at data for a given year and create a graphic that showcases your finding(s).


----------------------------------------------------------------------
#### >Part-04. The Lahman Baseball Database

__Data:__ The Data were collected from(http://www.seanlahman.com/baseball-archive/statistics/)
 - The Lahman Baseball Database 2017 Version
 - Release Date: March 31, 2018
Copyright Notice & Limited Use License
 - This database is copyright 1996-2018 by Sean Lahman. This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License. For details see: http://creativecommons.org/licenses/by-sa/3.0/
 - For licensing information or further information, contact Sean Lahman at: seanlahman@gmail.com

----------------------------------------------------------------------
1.1 Introduction

This database contains pitching, hitting, and fielding statistics for Major League Baseball from 1871 through 2017.  It includes data from the two current leagues (American and National), the four other "major" leagues (American Association, Union Association, Players League, and Federal League), and the National Association of 1871-1875. This database was created by Sean Lahman, who pioneered the effort to make baseball statistics freely available to the general public. What started as a one man effort in 1994 has grown tremendously, and now a team of researchers have collected their efforts to make this the largest and most accurate source for baseball statistics available anywhere. 

----------------------------------------------------------------------
> What's New in 2017

Player stats have been updated through 2017 season, and many of the other tables 
have been updated based on new research into the historical record. 
 - One notable change: The name of the table that contains biographical information
for players has been changed from "Master" to "People" top better reflect its 
contents.

---------------------------------------------------------------------

> Data Tables

The design follows these general principles.  Each player is assigned a
unique number (playerID).  All of the information relating to that player
is tagged with his playerID.  The playerIDs are linked to names and 
birthdates in the MASTER table.

The database is comprised of the following main tables:
 - People - Player names, DOB, and biographical info
 - Batting - batting statistics
 - Pitching - pitching statistics
 - Fielding - fielding statistics

It is supplemented by these tables:
 - AllStarFull - All-Star appearances
  HallofFame - Hall of Fame voting data
  Managers - managerial statistics
  Teams - yearly stats and standings 
  BattingPost - post-season batting statistics
  PitchingPost - post-season pitching statistics
  TeamFranchises - franchise information
  FieldingOF - outfield position data  
  FieldingPost- post-season fielding data
  FieldingOFsplit - LF/CF/RF splits
  ManagersHalf - split season data for managers
  TeamsHalf - split season data for teams
  Salaries - player salary data
  SeriesPost - post-season series information
  AwardsManagers - awards won by managers 
  AwardsPlayers - awards won by players
  AwardsShareManagers - award voting for manager awards
  AwardsSharePlayers - award voting for player awards
  Appearances - details on the positions a player appeared at
  Schools - list of colleges that players attended
  CollegePlaying - list of players and the colleges they attended
  Parks - list of major league ballparls
  HomeGames - Number of homegames played by each team in each ballpark

--------------------------------------------------------------------------
2.1 People table

 - playerID:       A unique code asssigned to each player.  The playerID links
                 the data in this file with records in the other files.
 - birthYear:      Year player was born
 - birthMonth:     Month player was born
 - birthDay:       Day player was born
 - birthCountry:   Country where player was born
 - birthState:     State where player was born
 - birthCity:      City where player was born
 - deathYear:      Year player died
 - deathMonth:     Month player died
 - deathDay:       Day player died
 - deathCountry:   Country where player died
 - deathState:     State where player died
 - deathCity:      City where player died
 - nameFirst:      Player's first name
 - nameLast:       Player's last name
 - nameGiven:      Player's given name (typically first and middle)
 - weight:         Player's weight in pounds
 - height:         Player's height in inches
 - bats:           Player's batting hand (left, right, or both)         
 - throws:         Player's throwing hand (left or right)
 - debut:          Date that player made first major league appearance
 - finalGame:      Date that player made first major league appearance (blank if still active)
 - retroID:        ID used by retrosheet
 - bbrefID:        ID used by Baseball Reference website

------------------------------------------------------------------------------
2.2 Batting Table
 - playerID:       Player ID code
 - yearID:         Year
 - stint:          player's stint (order of appearances within a season)
 - teamID:         Team
 - lgID:           League
 - G:              Games
 - AB:             At Bats
 - R:              Runs
 - H:              Hits
 - 2B:             Doubles
 - 3B:             Triples
 - HR:             Homeruns
 - RBI:            Runs Batted In
 - SB:             Stolen Bases
 - CS:             Caught Stealing
 - BB:             Base on Balls
 - SO:             Strikeouts
 - IBB:            Intentional walks
 - HBP:            Hit by pitch
 - SH:             Sacrifice hits
 - SF:             Sacrifice flies
 - GIDP:           Grounded into double plays

------------------------------------------------------------------------------


