library(tidyverse)
library(readr)
library(stringr)
rm(list= ls())
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

data$subCity = gsub(pattern = ",", replacement = "", x = data$subCity)
data$subCity = tolower(data$subCity)
data$subCity  = trimws(data$subCity, "both")
data$subCity = ifelse(data$subCity == "(თემქა)", "temka", data$subCity)

# data %>% group_by(type) %>% summarise(avgPrice = mean(price), total = n()) %>% 
#   arrange(desc(total))
# 
# data %>%
#   ggplot(aes(y=price)) + geom_boxplot() + 
#   facet_wrap(~ type)+ scale_y_log10() 

count(data, city, subCity) %>% arrange(desc(n))
count(data, type) %>% arrange(n)
count(data, type) %>% arrange(desc(n))

#take a look at tbilisi
head(data)

filter(data, city == "Tbilisi") %>% count(subCity, type) %>% arrange((n)) %>% 
  filter(n > 100) %>% ggplot(aes(x= subCity, y = n)) + geom_col() + coord_flip() +
  facet_wrap(~ type)

filter(data, city == "Tbilisi") %>% count(type)%>% arrange(desc(n)) %>% filter(n > 100)
# my scope
list = c("Newly finished apartment for sale",
         "Older finished apartment for sale")

list2RentData = c("Newly finished apartment for rent",
                  "Older finished apartment for rent")

# TbilisiSale
dataAboutApartmentsForSale = filter(data, type %in% list, city =="Tbilisi")

dataAboutApartmentsForSale %>% filter(price > 10000, price < 3000000) %>%
  ggplot(aes(x= type, y = price))  + geom_boxplot() + scale_y_log10() + facet_wrap(~subCity)

dataAboutApartmentsForSale[is.na(dataAboutApartmentsForSale)] = 0
dataAboutApartmentsForSale = dataAboutApartmentsForSale %>% filter(price > 10000, price < 3000000, area < 900, rooms < 20, rooms >0,
                                                                   floor < 30, bedRooms < 15)
output1 = select(dataAboutApartmentsForSale, type, subCity,price,bedRooms,rooms,floor,area) %>%
  mutate(stype = "sale",type =ifelse(type =="Newly finished apartment for sale","New","Old"))

# TbilisiRent
dataAboutApartmentsForRent = filter(data, type %in% list2RentData, city =="Tbilisi")
dataAboutApartmentsForRent$price = ifelse(is.na(dataAboutApartmentsForRent$price),0,dataAboutApartmentsForRent$price)

dataAboutApartmentsForRent[is.na(dataAboutApartmentsForRent)] = 0

dataAboutApartmentsForRent %>% filter(price > 200, price < 20000) %>%
  ggplot(aes(x= type, y = price))  + geom_boxplot() + scale_y_log10() + facet_wrap(~subCity)

dataAboutApartmentsForRent = dataAboutApartmentsForRent %>% filter(price > 200, price < 20000, area < 500, rooms < 10, rooms >0,
                                      floor < 30, bedRooms < 10)

output2 = select(dataAboutApartmentsForRent, type, subCity,price,bedRooms,rooms,floor,area) %>%
  mutate(stype = "rent",type =ifelse(type =="Newly finished apartment for rent","New","Old"))


write.csv(union_all(output1,output2), "~/Desktop/myData.csv",quote = F,row.names = F)
