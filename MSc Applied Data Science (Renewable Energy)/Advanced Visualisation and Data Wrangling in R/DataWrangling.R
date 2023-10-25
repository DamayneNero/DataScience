#####----- INSTALLING PACKAGES -----#####
# Install the tidyverse package
install.packages("tidyverse")

#####----- CALLING UPON A LIBRARY -----#####
# Call upon the tidyverse library
library(tidyverse)

#####----- HEAD AND TAIL DF -----#####
# Return the first 5 rows of the data set "iris"
# Iris data set is built into R
head(iris)

# Returns the last 5 rows of the data set "iris"
tail(iris)

#####----- FILTERING DF -----#####
# Filter the entries containing versicolor
# within the Species column and returns the first 5 rows.
filter(head(iris), Species == "versicolor")

#####----- ARRANGING OR SORTING DF -----#####
# Sorts the rows of Sepal.Length and returns the first 5 rows.
# A minus sign can be used to sort in descending order. 
arrange(head(iris), Species, Sepal.Length)

#####----- RETURNING SPECIFIC COLUMNS -----#####
# Only returns the selected columns.
select(iris, Species, Sepal.Length, Sepal.Width)

# Selects the columns starting with a specified value.
select(iris, Species, starts_with("Sepal"))

# These commands can be used to remove columns.
# In this case the Petal column is removed.
select(iris, -starts_with("Petal"))
# or 
select(iris, -Petal.Length, -Petal.Width)

#####----- TRANSFORMING COLUMNS -----#####
# Adds a column names Sepal.Length^2 and returns the first 5 rows.
mutate(head(iris), Sepal.Length2 = Sepal.Length^2)

#####----- PIPES -----#####
# Pipes "%>%" can be used to perform one operator after another.
# in the case the data set iris was called then filtered then
# the first 5 rows were returned.
iris %>% filter(Species == "versicolor") %>% head

# More in depth examples of pipes
iris %>%
  filter(Species == "versicolor") %>%
  select(Species, starts_with("Sepal")) %>%
  mutate(Sepal.Length2 = Sepal.Length^2) %>%
  arrange(Sepal.Length) %>%
  head

#####----- GROUPING -----#####
# Grouping and summarising, the data can be summarised using these
# functions to provide an overview of the data.

# Here the data was grouped by Species and summarised by taking the
# average of the Sepal.Length.
iris %>% 
  group_by(Species) %>%
  summarise(mnL = mean(Sepal.Length), varL = var(Sepal.Length),
            mnW = mean(Sepal.Width), varW = var(Sepal.Width))

# There is also a count function to return the amount of times an entry
# has been made.
iris %>%
  group_by(Species) %>%
  count()

#####----- READING CSV -----#####
# Call forth data using read_csv. Reads csv data within the current
# working folder. The data was set to a variable called gp_income
# and gp_income was called forth to view the data.
gp_income <- read_csv("indicator gapminder gdp_per_capita_ppp.csv")
gp_income

#####----- RENAMING COLUMNS -----#####
# Renaming the first column from "GDP per capita" to "Country".
# The rename function can be used to rename a field by name.
gp_income <- gp_income %>%
  rename(country = "GDP per capita")
gp_income

#####----- GATHERING (TIDYING DATA) -----######
# The gather function allows for the data to be converted to a tidy
# format. It can be used to align the years GDP to its corresponding 
# country.
# gather takes the arguments key and value followed by the column
# that you wan to exclude from being collapse. Key is the column
# that contains the collapsed column names and values is the 
# name of the columns that will contain the values in each of 
# the cells of the collapsed column
gp_income <- gp_income %>%
  gather(key = year, value = gdp, -country)
gp_income

#####----- CHANGING FIELD DATA TYPE -----#####
# Changes a character field to a numeric field
gp_income <- gp_income %>%
  mutate(year = as.numeric(year))
gp_income

#####----- TIDYING DATA -----#####
# Filtering the data to provide a summary on the empty cells
# within the data set "NA"
gp_income %>% filter(is.na(country)) %>% summary()

# Removing rows with no Country information
gp_income <- gp_income %>% filter(!is.na(country))
gp_income
# Removing rows with no GDP information
gp_income <- gp_income %>% filter(!is.na(gdp))
gp_income

# Filtering to only look at years past 1990
gp_income <- gp_income %>% filter(year > 1990)
head(gp_income)

summary(gp_income)

# All the above data filtering/cleaning operations can be done
# using pipes.
gp_income <- read_csv("indicator gapminder gdp_per_capita_ppp.csv") %>%
  rename(country = `GDP per capita`) %>%
  gather(year, gdp, -country) %>%
  mutate(year = as.numeric(year)) %>%
  filter(!is.na(country)) %>%
  filter(!is.na(gdp)) %>%
  filter(year > 1990)

# Provides the mean GDP over all the years
gp_income %>% 
  group_by(country) %>%
  summarise(mn = mean(gdp))

# Task HVI data set
gp_hiv <- read_csv("indicator hiv estimated prevalence% 15-49.csv") %>%
  rename(country = `Estimated HIV Prevalence% - (Ages 15-49)`) %>%
  gather(year, prevalence, -country) %>%
  mutate(year = as.numeric(year)) %>%
  filter(!is.na(country)) %>%
  filter(!is.na(prevalence)) %>%
  filter(year > 1990) %>%
  mutate(prevalence = as.numeric(prevalence))
gp_hiv

gp_hiv %>%
  filter(country == "Barbados" | country == "Uganda") %>%
  ggplot(aes(x = year, y = prevalence, colour = country)) +
  geom_line() + xlab("Year") + ylab("Prevalence") +
  labs(colour = "Country")

body(gp_hiv)

#####----- Joins -----#####
# The goal now is to merge both data sets. To see if they are compatible
# we can summaries both using the field or fields that the join would
# be performed on.
gp_income %>% count(country, year) %>% summary()
gp_income %>% count(country, year) %>% summary()

# Joins can be performed by running the following function. Inner joins
# can be used to return a join of both data sets removing any data
# that cannot be matched.
gp <- inner_join(gp_income, gp_hiv, by = c("year", "country"))
gp

# anti_join can be used to return all rows o the data frame that cannot
# be matched to another.
# Here we can see that they are 20009 variables that cannot be matched
# with gp_hiv.
anti_join(gp_income, gp_hiv, by = c("year", "country"))
# Here we can see that hey are 0 variables that cannot be matched with
# gp_income.
anti_join(gp_hiv, gp_income, by = c("year", "country"))

# Outer joins can be used to return either all the data from the left or
# right regardless of if they match or not, replacing the empty fields
# with a NA
left_join(gp_income, gp_hiv, by = c("year", "country"))
right_join(gp_income, gp_hiv, by = c("year", "country"))
# Full outer joins returns all fields whether they match or not.
full_join(gp_income, gp_hiv, by = c("year", "country"))

#####----- TASK -----#####
# Here is an example of everything learnt placed together and displayed
# using ggplot. Ggplot is a visualisation function that provided graphs
# of tidyverse data.
gp %>%
  filter(year == 1991 | year == 1997 | year == 2005 | year == 2011) %>%
  ggplot(aes(x = gdp, y = prevalence)) +
  geom_point() + 
  scale_x_log10() +
  xlab("log10(GDP per capita)") +
  ylab("HIV prevalence in 15-49 year olds") + 
  facet_wrap(~year)

# Importing population data, tidying it and joining it to the gp data set
## read in data
gp_pop <- read_csv("indicator gapminder population.csv") %>%
  gather(year, pop, -`Total population`) %>%
  rename(country = `Total population`) %>%
  mutate(year = as.numeric(year)) %>%
  filter(!is.na(country)) %>%
  filter(!is.na(pop)) %>%
  filter(year > 1990)

## check no population data are missing
## hence all rows of gp can be matched
anti_join(gp, gp_pop, by = c("year", "country"))

## join to gp table
gp <- inner_join(gp, gp_pop, by = c("year", "country"))
gp

# Plotting the data to display HIV prevalence against GDP per capita
# for 1991, 1997, 2005 and 2011 where each point represents a country
# and where the point sizes are scaled by population size.

## here is one solution using filtering, piping and faceting
gp %>%
  mutate(year = as.numeric(year)) %>%
  filter(year == 1991 | year == 1997 | year == 2005 | year == 2011) %>%
  ggplot(aes(x = gdp, y = prevalence, size = pop)) +
  geom_point() + 
  scale_x_log10() +
  labs(size = "Population size") +
  xlab("log10(GDP per capita)") +
  ylab("HIV prevalence in 15-49 year olds") +
  facet_wrap(~year)
