# Load required libraries
library(dplyr)
library(lubridate)

df <- read.csv("target-data/locations.csv")
loc_df <- filter(df, location < 60)

# Set seed for reproducibility
set.seed(123)

# Generate synthetic data
unique_dates <- seq(as.Date("2024-01-06"), as.Date("2024-10-30"), by = "week")

# Create a unique combination of date and location
fake_data <- expand.grid(
  date = unique_dates,
  location = loc_df$location
) %>%
  mutate(
    location_name = loc_df$location_name[match(location, loc_df$location)],
    value = sample(1:100, nrow(.), replace = TRUE)
  )


# Display the generated data
write.csv(
  fake_data, file.path("target-data", "test-hospital-admissions.csv")
)
