## Jenny Norton
## Project 1
## Due Friday, October 2, 2020

## https://www.kaggle.com/camnugent/ufo-sightings-around-the-world

## Load library tidyverse and here

library(tidyverse)
library(here)

## Loading and Cleaning Data

ufo_data_path <- here("ufodata.csv")
ufo_data <- read_csv(ufo_data_path)

## Fix the columns: changed the "date_documented" field from col_character to col_date with the
## formatting to remove a weird character at the end

ufo_data <- read_csv(ufo_data_path,
                     col_types = 
                       cols(
                         Date_time = col_character(),
                         city = col_character(),
                         `state/province` = col_character(),
                         country = col_character(),
                         UFO_shape = col_character(),
                         length_of_encounter_seconds = col_double(),
                         described_duration_of_encounter = col_character(),
                         description = col_character(),
                         date_documented = col_date (format = "%m/%d/%Y %*"),
                         latitude = col_double(),
                         longitude = col_double()
                       )
)

## Had 4 parsing failures in the length_of_encounter_seconds and latitude but not necessary to fix
## at this time.

## Tried parsing Date_time to a date and time format but I had 698 parsing failures. I used this format
## but it didn't seem to like the entries that had 24:00 as the time (ex. line 389 and 694)
## Example:
## Warning: 698 parsing failures.
## row       col   expected           actual                                                                           file
## 389 Date_time valid date 10/11/2006 24:00 'C:/Users/Jenny/Documents/DSCI301/repository/DSCI301-F20-Project1/ufodata.csv'
## 694 Date_time valid date 10/1/2001 24:00  'C:/Users/Jenny/Documents/DSCI301/repository/DSCI301-F20-Project1/ufodata.csv'

## Replaced the hour "24:00" with "00:00" and parsed it into the correct format.  Mutated this
## into a new column called Date_time2 and loaded it back into the ufo_data set.

ufo_data <- mutate(ufo_data,
       Date_time2 = str_replace(ufo_data$Date_time, "24:00", "00:00") %>%
parse_datetime(format = "%m/%d/%Y %H:%M"))

## Change the name of state/province to state_province

ufo_data <- ufo_data %>%
  rename(
    state_province = `state/province`
  )

## I wanted to filter incidents that happened in the 1970s by shape so I created a new data set
## called ufo_data1970

ufo_data1970 <- ufo_data %>%
  filter(Date_time2 > "1969-12-31" & Date_time2 < "1980-01-01") %>%
  arrange(UFO_shape) 




