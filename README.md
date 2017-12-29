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

 - Question 1: How have movie genres changed over time?
 - Question 2: How do the attributes differ between Universal Pictures and Paramount Pictures?
 - Question 3: How have movies based on novels performed relative to movies not based on novels?

On top of that, the client asked you to explore one other question that you find interesting based on the data provided.  
  









  


