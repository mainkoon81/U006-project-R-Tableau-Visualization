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

The Lahman Baseball Database

2017 Version
Release Date: March 31, 2018

----------------------------------------------------------------------

README CONTENTS
0.1 Copyright Notice
0.2 Contact Information

1.0 Release Contents
1.1 Introduction
1.2 What's New
1.3 Acknowledgements
1.4 Using this Database
1.5 Revision History

2.0 Data Tables

----------------------------------------------------------------------

0.1 Copyright Notice & Limited Use License

This database is copyright 1996-2018 by Sean Lahman. 

This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License. For details see: http://creativecommons.org/licenses/by-sa/3.0/


For licensing information or further information, contact Sean Lahman
at: seanlahman@gmail.com

----------------------------------------------------------------------

0.2 Contact Information

Web site: http://www.baseball1.com
E-Mail : seanlahman@gmail.com

If you're interested in contributing to the maintenance of this 
database or making suggestions for improvement, please consider
joining our mailinglist at http://groups.yahoo.com/group/baseball-databank/

If you are interested in similar databases for other sports, please
vist the Open Source Sports website at http://OpenSourceSports.com

----------------------------------------------------------------------
1.0  Release Contents

This release of the database can be downloaded in several formats. The
contents of each version are listed below.

MS Access Versions:
      lahman2017.mdb 
      2017readme.txt 

SQL version
      lahman2017.sql
      2017readme.txt 
	  
Comma Delimited Version:
      2017readme.txt     
      AllStarFull.csv
      Appearances.csv
      AwardsManagers.csv
      AwardsPlayers.csv
      AwardsShareManagers.csv
      AwardsSharePlayers.csv
      Batting.csv
      BattingPost.csv
      CollegePlaying.csv
      Fielding.csv
      FieldingOF.csv
      FieldingPost.csv
	  FieldingOFsplit
      HallOfFame.csv
	  HomeGames.csv
      Managers.csv
      ManagersHalf.csv
	  Parks.csv
      People.csv
      Pitching.csv
      PitchingPost.csv
	  README.txt
      Salaries.csv
      Schools.csv
      SeriesPost.csv
      Teams.csv
      TeamsFranchises.csv
      TeamsHalf.csv

----------------------------------------------------------------------
1.1 Introduction

This database contains pitching, hitting, and fielding statistics for
Major League Baseball from 1871 through 2017.  It includes data from
the two current leagues (American and National), the four other "major" 
leagues (American Association, Union Association, Players League, and
Federal League), and the National Association of 1871-1875. 

This database was created by Sean Lahman, who pioneered the effort to
make baseball statistics freely available to the general public. What
started as a one man effort in 1994 has grown tremendously, and now a
team of researchers have collected their efforts to make this the
largest and most accurate source for baseball statistics available
anywhere. (See Acknowledgements below for a list of the key
contributors to this project.)

None of what we have done would have been possible without the
pioneering work of Hy Turkin, S.C. Thompson, David Neft, and Pete
Palmer (among others).  All baseball fans owe a debt of gratitude
to the people who have worked so hard to build the tremendous set
of data that we have today.  Our thanks also to the many members of
the Society for American Baseball Research who have helped us over
the years.  We strongly urge you to support and join their efforts.
Please vist their website (www.sabr.org).

If you have any problems or find any errors, please let us know.  Any 
feedback is appreciated

----------------------------------------------------------------------
1.2 What's New in 2017

Player stats have been updated through 2017 season, and many of the other tables 
have been updated based on new research into the historical record.

One notable change: The name of the table that contains biographical information
for players has been changed from "Master" to "People" top better reflect its 
contents.

----------------------------------------------------------------------
1.3 Acknowledgements

Much of the raw data contained in this database comes from the work of
Pete Palmer, the legendary statistician, who has had a hand in most 
of the baseball encylopedias published since 1974. He is largely 
responsible for bringing the batting, pitching, and fielding data out
of the dark ages and into the computer era.  Without him, none of this
would be possible.  For more on Pete's work, please read his own 
account at: http://sabr.org/cmsfiles/PalmerDatabaseHistory.pdf

Three people have been key contributors to the work that followed, first 
by taking the raw data and creating a relational database, and later 
by extending the database to make it more accesible to researchers.

Sean Lahman launched the Baseball Archive's website back before 
most people had heard of the world wide web.  Frustrated by the
lack of sports data available, he led the effort to build a 
baseball database that everyone could use. He created the first version
of the database and began to make it available for free download from
his website in 1995.  

The work of Sean Forman to create and maintain an online encyclopedia
at Baseball-Reference.com was a quantum leap for both fans and researchers. 
The website launched in 2000, provding a user-friendly interface to the Lahman
Baseball Database.  Forman and Lahman launched the Baseball Databank in 2001,
a group of researchers whose goal was to update and maintain the database
as an open source collection available to all.
  
Ted Turocy has done the lion's share of the work to updating the main
data tables since 2012, automating the work of annual updates and linking
historical data to play-by-play accounts compiled by Retrosheet.

A handful of researchers have made substantial contributions to 
maintain this database over years. Listed alphabetically, they 
are: Derek Adair, Mike Crain, Kevin Johnson, Rod Nelson, Tom Tango,
and Paul Wendt. These folks did much of the heavy lifting, and are 
largely responsible for the improvements made since 2000.

Others who made important contributions include: Dvd Avins, 
Clifford Blau, Bill Burgess, Clem Comly, Jeff Burk, Randy Cox, 
Mitch Dickerman, Paul DuBois, Mike Emeigh, F.X. Flinn, Bill Hickman,
Jerry Hoffman, Dan Holmes, Micke Hovmoller, Peter Kreutzer, 
Danile Levine, Bruce Macleod, Ken Matinale, Michael Mavrogiannis,
Cliff Otto, Alberto Perdomo, Dave Quinn, John Rickert, Tom Ruane,
Theron Skyles, Hans Van Slooten, Michael Westbay, and Rob Wood.

Many other people have made significant contributions to the database
over the years.  The contribution of Tom Ruane's effort to the overall
quality of the underlying data has been tremendous. His work at
retrosheet.org integrates the yearly data with the day-by-day data,
creating a reference source of startling depth. 

Sean Holtz helped with a major overhaul and redesign before the
2000 season. Keith Woolner was instrumental in helping turn
a huge collection of stats into a relational database in the mid-1990s.
Clifford Otto & Ted Nye also helped provide guidance to the early 
versions. Lee Sinnis, John Northey & Erik Greenwood helped supply key
pieces of data. Many others have written in with corrections and 
suggestions that made each subsequent version even better than what
preceded it. 

The work of the SABR Baseball Records Committee, led by Lyle Spatz
has been invaluable.  So has the work of Bill Carle and the SABR 
Biographical Committee. David Vincent, keeper of the Home Run Log and
other bits of hard to find info, has always been helpful. The recent
addition of colleges to player bios is the result of much research by
members of SABR's Collegiate Baseball committee.

Salary data was first supplied by Doug Pappas, who passed away during
the summer of 2004. He was the leading authority on many subjects, 
most significantly the financial history of Major League Baseball. 
We are grateful that he allowed us to include some of the data he 
compiled.  His work has been continued by the SABR Business of 
Baseball committee.  

Thanks is also due to the staff at the National Baseball Library
in Cooperstown who have been so helpful over the years, including
Tim Wiles, Jim Gates, Bruce Markusen, and the rest of the staff.  

A special debt of gratitude is owed to Dave Smith and the folks at
Retrosheet. There is no other group working so hard to compile and
share baseball data.  Their website (www.retrosheet.org) will give
you a taste of the wealth of information Dave and the gang have collected.

Thanks to all contributors great and small. What you have created is
a wonderful thing.

----------------------------------------------------------------------
1.4 Using this Database

This version of the database is available in Microsoft Access
format, SQL files or in a generic, comma delimited format. Because this is a
relational database, you will not be able to use the data in a
flat-database application. 

Please note that this is not a stand alone application.  It requires
a database application or some other application designed specifically
to interact with the database.

If you are unable to import the data directly, you should download the
database in the delimted text format.  Then use the documentation
in section 2.0 of this document to import the data into
your database application. 

----------------------------------------------------------------------
1.5 Revision History

     Version      Date            Comments
       1.0      December 1992     Database ported from dBase
       1.1      May 1993          Becomes fully relational
       1.2      July 1993         Corrections made to full database
       1.21     December 1993     1993 statistics added            
       1.3      July 1994         Pre-1900 data added 
       1.31     February 1995     1994 Statistics added
       1.32     August 1995       Statistics added for other leagues
       1.4      September 1995    Fielding Data added 
       1.41     November 1995     1995 statistics added
       1.42     March 1996        HOF/All-Star tables added
       1.5-MS   October 1996      1st public release - MS Access format
       1.5-GV   October 1996      Released generic comma-delimted files
       1.6-MS   December 1996     Updated with 1996 stats, some corrections
       1.61-MS  December 1996     Corrected error in MASTER table
       1.62     February 1997     Corrected 1914-1915 batters data and updated
       2.0      February 1998     Major Revisions-added teams & managers
       2.1      October 1998      Interim release w/1998 stats
       2.2      January 1999      New release w/post-season stats & awards added
       3.0      November 1999	  Major release - fixed errors and 1999 statistics added
       4.0      May 2001	  Major release - proofed & redesigned tables
       4.5      March 2002        Updated with 2001 stats and added new biographical data
       5.0      December 2002     Major revision - new tables and data
       5.1      January 2004      Updated with 2003 data, and new pitching categories
       5.2      November 2004     Updated with 2004 season statistics.
       5.3      December 2005     Updated with 2005 season statistics.
       5.4      December 2006     Updated with 2006 season statistics.
       5.5      December 2007     Updated with 2007 season statistics.
       5.6      December 2008     Updated with 2008 season statistics.
       5.7      December 2009     Updated for 2009 and added several tables.
       5.8      December 2010     Updated with 2010 season statistics.
       5.9      December 2011     Updated for 2011 and removed obsolete tables.
       2012     December 2012     Updated with 2012 season statistics
       2013     December 2013     Updated with 2013 season statistics
       2014     December 2014     Updated with 2014 season statistics
       2015     December 2015     Updated with 2015 season statistics  
       2016     February 2017     Updated for 2016 and added several tables
       2017     March 2018        Updated for 2017

------------------------------------------------------------------------------
2.0 Data Tables

The design follows these general principles.  Each player is assigned a
unique number (playerID).  All of the information relating to that player
is tagged with his playerID.  The playerIDs are linked to names and 
birthdates in the MASTER table.

The database is comprised of the following main tables:

  People - Player names, DOB, and biographical info
  Batting - batting statistics
  Pitching - pitching statistics
  Fielding - fielding statistics

It is supplemented by these tables:

  AllStarFull - All-Star appearances
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


playerID       A unique code asssigned to each player.  The playerID links
                 the data in this file with records in the other files.
birthYear      Year player was born
birthMonth     Month player was born
birthDay       Day player was born
birthCountry   Country where player was born
birthState     State where player was born
birthCity      City where player was born
deathYear      Year player died
deathMonth     Month player died
deathDay       Day player died
deathCountry   Country where player died
deathState     State where player died
deathCity      City where player died
nameFirst      Player's first name
nameLast       Player's last name
nameGiven      Player's given name (typically first and middle)
weight         Player's weight in pounds
height         Player's height in inches
bats           Player's batting hand (left, right, or both)         
throws         Player's throwing hand (left or right)
debut          Date that player made first major league appearance
finalGame      Date that player made first major league appearance (blank if still active)
retroID        ID used by retrosheet
bbrefID        ID used by Baseball Reference website


------------------------------------------------------------------------------
2.2 Batting Table
playerID       Player ID code
yearID         Year
stint          player's stint (order of appearances within a season)
teamID         Team
lgID           League
G              Games
AB             At Bats
R              Runs
H              Hits
2B             Doubles
3B             Triples
HR             Homeruns
RBI            Runs Batted In
SB             Stolen Bases
CS             Caught Stealing
BB             Base on Balls
SO             Strikeouts
IBB            Intentional walks
HBP            Hit by pitch
SH             Sacrifice hits
SF             Sacrifice flies
GIDP           Grounded into double plays

------------------------------------------------------------------------------
2.3 Pitching table

playerID       Player ID code
yearID         Year
stint          player's stint (order of appearances within a season)
teamID         Team
lgID           League
W              Wins
L              Losses
G              Games
GS             Games Started
CG             Complete Games 
SHO            Shutouts
SV             Saves
IPOuts         Outs Pitched (innings pitched x 3)
H              Hits
ER             Earned Runs
HR             Homeruns
BB             Walks
SO             Strikeouts
BAOpp          Opponent's Batting Average
ERA            Earned Run Average
IBB            Intentional Walks
WP             Wild Pitches
HBP            Batters Hit By Pitch
BK             Balks
BFP            Batters faced by Pitcher
GF             Games Finished
R              Runs Allowed
SH             Sacrifices by opposing batters
SF             Sacrifice flies by opposing batters
GIDP           Grounded into double plays by opposing batter
------------------------------------------------------------------------------
2.4 Fielding Table

playerID       Player ID code
yearID         Year
stint          player's stint (order of appearances within a season)
teamID         Team
lgID           League
Pos            Position
G              Games 
GS             Games Started
InnOuts        Time played in the field expressed as outs 
PO             Putouts
A              Assists
E              Errors
DP             Double Plays
PB             Passed Balls (by catchers)
WP             Wild Pitches (by catchers)
SB             Opponent Stolen Bases (by catchers)
CS             Opponents Caught Stealing (by catchers)
ZR             Zone Rating

------------------------------------------------------------------------------
2.5  AllstarFull table

playerID       Player ID code
YearID         Year
gameNum        Game number (zero if only one All-Star game played that season)
gameID         Retrosheet ID for the game idea
teamID         Team
lgID           League
GP             1 if Played in the game
startingPos    If player was game starter, the position played
------------------------------------------------------------------------------
2.6  HallOfFame table

playerID       Player ID code
yearID         Year of ballot
votedBy        Method by which player was voted upon
ballots        Total ballots cast in that year
needed         Number of votes needed for selection in that year
votes          Total votes received
inducted       Whether player was inducted by that vote or not (Y or N)
category       Category in which candidate was honored
needed_note    Explanation of qualifiers for special elections
------------------------------------------------------------------------------
2.7  Managers table
 
playerID       Player ID Number
yearID         Year
teamID         Team
lgID           League
inseason       Managerial order.  Zero if the individual managed the team
                 the entire year.  Otherwise denotes where the manager appeared
                 in the managerial order (1 for first manager, 2 for second, etc.)
G              Games managed
W              Wins
L              Losses
rank           Team's final position in standings that year
plyrMgr        Player Manager (denoted by 'Y')

------------------------------------------------------------------------------
2.8  Teams table

yearID         Year
lgID           League
teamID         Team
franchID       Franchise (links to TeamsFranchise table)
divID          Team's division
Rank           Position in final standings
G              Games played
GHome          Games played at home
W              Wins
L              Losses
DivWin         Division Winner (Y or N)
WCWin          Wild Card Winner (Y or N)
LgWin          League Champion(Y or N)
WSWin          World Series Winner (Y or N)
R              Runs scored
AB             At bats
H              Hits by batters
2B             Doubles
3B             Triples
HR             Homeruns by batters
BB             Walks by batters
SO             Strikeouts by batters
SB             Stolen bases
CS             Caught stealing
HBP            Batters hit by pitch
SF             Sacrifice flies
RA             Opponents runs scored
ER             Earned runs allowed
ERA            Earned run average
CG             Complete games
SHO            Shutouts
SV             Saves
IPOuts         Outs Pitched (innings pitched x 3)
HA             Hits allowed
HRA            Homeruns allowed
BBA            Walks allowed
SOA            Strikeouts by pitchers
E              Errors
DP             Double Plays
FP             Fielding  percentage
name           Team's full name
park           Name of team's home ballpark
attendance     Home attendance total
BPF            Three-year park factor for batters
PPF            Three-year park factor for pitchers
teamIDBR       Team ID used by Baseball Reference website
teamIDlahman45 Team ID used in Lahman database version 4.5
teamIDretro    Team ID used by Retrosheet

------------------------------------------------------------------------------
2.9  BattingPost table

yearID         Year
round          Level of playoffs 
playerID       Player ID code
teamID         Team
lgID           League
G              Games
AB             At Bats
R              Runs
H              Hits
2B             Doubles
3B             Triples
HR             Homeruns
RBI            Runs Batted In
SB             Stolen Bases
CS             Caught stealing
BB             Base on Balls
SO             Strikeouts
IBB            Intentional walks
HBP            Hit by pitch
SH             Sacrifices
SF             Sacrifice flies
GIDP           Grounded into double plays

------------------------------------------------------------------------------
2.10  PitchingPost table

playerID       Player ID code
yearID         Year
round          Level of playoffs 
teamID         Team
lgID           League
W              Wins
L              Losses
G              Games
GS             Games Started
CG             Complete Games
SHO             Shutouts 
SV             Saves
IPOuts         Outs Pitched (innings pitched x 3)
H              Hits
ER             Earned Runs
HR             Homeruns
BB             Walks
SO             Strikeouts
BAOpp          Opponents' batting average
ERA            Earned Run Average
IBB            Intentional Walks
WP             Wild Pitches
HBP            Batters Hit By Pitch
BK             Balks
BFP            Batters faced by Pitcher
GF             Games Finished
R              Runs Allowed
SH             Sacrifice Hits allowed
SF             Sacrifice Flies allowed
GIDP           Grounded into Double Plays

------------------------------------------------------------------------------
2.11 TeamFranchises table

franchID       Franchise ID
franchName     Franchise name
active         Whetehr team is currently active (Y or N)
NAassoc        ID of National Association team franchise played as

------------------------------------------------------------------------------
2.12 FieldingOF table

playerID       Player ID code
yearID         Year
stint          player's stint (order of appearances within a season)
Glf            Games played in left field
Gcf            Games played in center field
Grf            Games played in right field

------------------------------------------------------------------------------
2.13 ManagersHalf table

playerID       Manager ID code
yearID         Year
teamID         Team
lgID           League
inseason       Managerial order.  One if the individual managed the team
                 the entire year.  Otherwise denotes where the manager appeared
                 in the managerial order (1 for first manager, 2 for second, etc.)
half           First or second half of season
G              Games managed
W              Wins
L              Losses
rank           Team's position in standings for the half

------------------------------------------------------------------------------
2.14 TeamsHalf table

yearID         Year
lgID           League
teamID         Team
half           First or second half of season
divID          Division
DivWin         Won Division (Y or N)
rank           Team's position in standings for the half
G              Games played
W              Wins
L              Losses

------------------------------------------------------------------------------
2.15 Salaries table

yearID         Year
teamID         Team
lgID           League
playerID       Player ID code
salary         Salary

------------------------------------------------------------------------------
2.16 SeriesPost table

yearID         Year
round          Level of playoffs 
teamIDwinner   Team ID of the team that won the series
lgIDwinner     League ID of the team that won the series
teamIDloser    Team ID of the team that lost the series
lgIDloser      League ID of the team that lost the series 
wins           Wins by team that won the series
losses         Losses by team that won the series
ties           Tie games
------------------------------------------------------------------------------
2.17 AwardsManagers table

playerID       Manager ID code
awardID        Name of award won
yearID         Year
lgID           League
tie            Award was a tie (Y or N)
notes          Notes about the award

------------------------------------------------------------------------------
2.18 AwardsPlayers table

playerID       Player ID code
awardID        Name of award won
yearID         Year
lgID           League
tie            Award was a tie (Y or N)
notes          Notes about the award

------------------------------------------------------------------------------
2.19 AwardsShareManagers table

awardID        name of award votes were received for
yearID         Year
lgID           League
playerID       Manager ID code
pointsWon      Number of points received
pointsMax      Maximum numner of points possible
votesFirst     Number of first place votes

------------------------------------------------------------------------------
2.20 AwardsSharePlayers table

awardID        name of award votes were received for
yearID         Year
lgID           League
playerID       Player ID code
pointsWon      Number of points received
pointsMax      Maximum numner of points possible
votesFirst     Number of first place votes

------------------------------------------------------------------------------
2.21 FieldingPost table

playerID       Player ID code
yearID         Year
teamID         Team
lgID           League
round          Level of playoffs 
Pos            Position
G              Games 
GS             Games Started
InnOuts        Time played in the field expressed as outs 
PO             Putouts
A              Assists
E              Errors
DP             Double Plays
TP             Triple Plays
PB             Passed Balls
SB             Stolen Bases allowed (by catcher)
CS             Caught Stealing (by catcher)

------------------------------------------------------------------------------
2.22 Appearances table

yearID         Year
teamID         Team
lgID           League
playerID       Player ID code
G_all          Total games played
GS             Games started
G_batting      Games in which player batted
G_defense      Games in which player appeared on defense
G_p            Games as pitcher
G_c            Games as catcher
G_1b           Games as firstbaseman
G_2b           Games as secondbaseman
G_3b           Games as thirdbaseman
G_ss           Games as shortstop
G_lf           Games as leftfielder
G_cf           Games as centerfielder
G_rf           Games as right fielder
G_of           Games as outfielder
G_dh           Games as designated hitter
G_ph           Games as pinch hitter
G_pr           Games as pinch runner


------------------------------------------------------------------------------
2.23 Schools table
schoolID       school ID code
schoolName     school name
schoolCity     city where school is located
schoolState    state where school's city is located
schoolNick     nickname for school's baseball team


------------------------------------------------------------------------------
2.24 CollegePlaying table
playerid       Player ID code
schoolID       school ID code
year           year



------------------------------------------------------------------------------
2.25 FieldingOFsplit table
playerID       Player ID code
yearID         Year
stint          player's stint (order of appearances within a season)
teamID         Team
lgID           League
Pos            Position
G              Games 
GS             Games Started
InnOuts        Time played in the field expressed as outs 
PO             Putouts
A              Assists
E              Errors
DP             Double Plays


------------------------------------------------------------------------------
2.26 Parks table
park.key		ballpark ID code
park.name       name of ballpark
park.alias      alternate names of ballpark
city            city
state           state 
country			country

------------------------------------------------------------------------------
2.27 HomeGames table
year.key		year
league.key		league
team.key		team ID
park.key		ballpark ID
span.first      date of first game played
span.last		date of last game played
games			total number of games
openings		total number of dates played
attendance		total attendaance



<end of file>
	

