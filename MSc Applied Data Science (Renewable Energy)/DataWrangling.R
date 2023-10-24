# Install the tidyverse package
install.packages("tidyverse")

# Call upon the tidyverse library
library(tidyverse)

# Return the first 5 rows of the data set "iris"
head(iris)

# Returns the last 5 rows of the data set "iris"
tail(iris)

# Filter the entries containing versicolor
# within the Species column and returns the first 5 rows.
filter(head(iris), Species == "versicolor")

# Sorts the rows of Sepal.Length and returns the first 5 rows.
arrange(head(iris), Species, Sepal.Length)

# Only returns the selected columns.
select(iris, Species, Sepal.Length, Sepal.Width)

# Selects the columns starting with a specified value.
select(iris, Species, starts_with("Sepal"))

# These commands can be used to remove columns.
# In this case the Petal column is removed.
select(iris, -starts_with("Petal"))
# or 
select(iris, -Petal.Length, -Petal.Width)

# Adds a column names Sepal.Length^2 and returns the first 5 rows.
mutate(head(iris), Sepal.Length2 = Sepal.Length^2)

# Pipes "%>%" can be used to perform one operator after another.
# in the case the data set iris was called then filtered then
# the first 5 rows were returned.
iris %>% filter(Species == "versicolor") %>% head

# More indepth examples of pipes
iris %>%
  filter(Species == "versicolor") %>%
  select(Species, starts_with("Sepal")) %>%
  mutate(Sepal.Length2 = Sepal.Length^2) %>%
  arrange(Sepal.Length) %>%
  head

# Grouping and summarising, the data can be summarised using these
# functions to provide an overview of the data.

# Here the data was grouped by Species and summarised by taking the
# average of the Sepal.Length.
iris %>% 
  group_by(Species) %>%
  summarise(mnL = mean(Sepal.Length), varL = var(Sepal.Length),
            mnW = mean(Sepal.Width), varW = var(Sepal.Width))

# Call forth data using read_csv. Reads csv data within the current
# working folder. The data was set to a variable called gp_income
# and gp_income was called forth to view the data.
gp_income <- read_csv("indicator gapminder gdp_per_capita_ppp.csv")
gp_income

# Renaming the first column from "GDP per capita" to "Country".
# The rename function can be used to rename a field by name.
gp_income <- gp_income %>%
  rename(country = "GDP per capita")
gp_income

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

# Changes a character field to a numeric field
gp_income <- gp_income %>%
  mutate(year = as.numeric(year))
gp_income

# Filtering the data to provide a summary on the empty cells
# within the data set "na"
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

