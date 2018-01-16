# project-R-Tableau-Visualization

### [Contents] 

__Part-01.__ Exploring Weather Trends
  - language: R
  - func:

__Part-02.__ Visualizing Movie Data
  - language: Tableau
  - func: 

----------------------------------------------------------------------
#### >Part-01. Exploring Weather Trends

__Data:__ The Data were collected recording votes in the Irish parliament (D´ailEireann), prior to the general election, in early 2016. Extra details of the votes can be found at (http://www.oireachtas.ie/parliament/) and the data are for the votes on January 14th-28th.
There are three tables in the database:
	city_list :  This contains a list of cities and countries in the database. 
	city_data :  This contains the average temperatures for each city by year (ºC).
	global_data :  This contains the average global temperatures by year (ºC).

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
<img src="https://user-images.githubusercontent.com/31917400/34846115-0bcca222-f70f-11e7-9d4b-528bf54fabe7.jpg" width="400" height="150" />

Create a line chart that compares your city’s temperatures with the global temperatures.
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
 - Plot: We want to see `avg_temp`'s distribution in global - The average temp in global seems to be normally distributed. 
```
ggplot(aes(x=avg_temp), data = global) + geom_histogram(binwidth = 0.1, color=I('black'), fill=I('#F79420'))
```








----------------------------------------------------------------------
#### >Part-02. Visualizing Movie Data

__Data:__ The Movie Database data can be found in (https://www.themoviedb.org/?language=en) - 'movies.csv', and a breakdown of what every field (column) means:
 - **id:** Identification number
 - **imdb_id:** IMDB identification number
 - **popularity:** Relative number of page views on The Movie Database
 - **budget:** Budget in USD
 - **revenue:** Revenue in USD
 - **original_title:** Movie title
 - **cast:** list of cast members separated by |, max five actors
 - **homepage:** URL for the movie homepage
 - **director:** list of directors separated by |, max five directors
 - **tagline:** Tagline for the movie
 - **keywords:** list of keywords associated with the movie, separated by |, max five keywords
 - **overview:** Summary of the plot
 - **runtime:** Movie runtime in minutes
 - **genres:** list of genres separated by |, max five genres
 - **production_companies:** list of production companies separated by |, max five companies
 - **release_date:** Original release date
 - **vote_count:** Number of votes
 - **vote_average:** Average of votes
 - **release_year:** Release year
 - **budget_adj:** Budget adjusted for inflation, in 2010 US dollars
 - **revenue_adj:** Revenue adjusted for inflation, in 2010 US dollars
  
__Story:__ Our client is a new movie production company looking to make a new movie. The client wants to make sure it’s successful to help make a name for the new company. They are relying on you to help understand movie trends to help inform their decision making. They’ve given you guidance to look into three specific areas:

 - Question 1: **How have movie genres changed over time?**
 - Question 2: **How do the attributes differ between Universal Pictures and Paramount Pictures?**
 - Question 3: **How have movies based on novels performed relative to movies not based on novels?**

On top of that, the client asked you to explore one other question that you find interesting based on the data provided.  
  









  


