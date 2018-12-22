library(tidyverse)
library(readr)
library(stringr)

data = read.delim("/Users/Raviky/OneDrive - hu-berlin.de/Programming/Python/WebScaping/MYhome/myHome.txt", 
                  sep="~", header = F, na.strings = "NA",strip.white = T, stringsAsFactors = F,
                  quote = "")


data = as.tibble(data)
names(data) = c("type", "price", "area", "floor","rooms","bedRooms","address","date")
head(data)
 
data$area = gsub(pattern =" m²",replacement = "",x = data$area)
data$floor = gsub(pattern ="Floor ",replacement = "",x = data$floor)
data$rooms = gsub(pattern ="Room ",replacement = "",x = data$rooms)
data$bedRooms = gsub(pattern ="Br ",replacement = "",x = data$bedRooms)
data$price = gsub(pattern = ",", replacement = "", x = data$price)

data$area = as.integer(data$area)
data$floor = as.integer(data$floor)
data$rooms = as.integer(data$rooms)
data$bedRooms = as.integer(data$bedRooms)
data$price = as.integer(data$price)

word(data$address, -1)
data = mutate(data, city = word(address, -1))
data = mutate(data, subCity = word(address, -2))

# data %>% group_by(type) %>% summarise(avgPrice = mean(price), total = n()) %>% 
#   arrange(desc(total))
# 
# data %>%
#   ggplot(aes(y=price)) + geom_boxplot() + 
#   facet_wrap(~ type)+ scale_y_log10() 

count(data, city) %>% arrange(desc(n))
count(data, type) %>% arrange(n)
count(data, type) %>% arrange(desc(n))

