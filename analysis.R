setwd("C:/Users/Erasmo/OneDrive/Projects/customer-churn-analytics")
getwd()

library(readr)
library(dplyr)

dataset <- read_csv(file="Telco-Customer-Churn.csv")
View(dataset)

na_values <- apply(is.na(dataset), 2, which)
View(na_values)

na_clean <- na_values$TotalCharges
dataset <- dataset[-c(na_clean), ]
View(dataset)

categorical_data <- dataset[-c(1, 6, 19, 20)]
View(categorical_data)

ggplot(dataset, aes(x=factor(Contract), y=MonthlyCharges, fill=Churn)) +
  geom_bar(stat="identity", position = "dodge") +
  facet_wrap(~ PaymentMethod)

count(categorical_data, gender)

?geom_bar
?aes

hist(dataset$MonthlyCharges, prob=TRUE)
plot(density(dataset$MonthlyCharges))

boxplot(dataset$MonthlyCharges)

summary(dataset$MonthlyCharges)
