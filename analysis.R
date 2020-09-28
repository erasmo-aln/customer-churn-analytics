setwd("C:/Users/Erasmo/OneDrive/Projects/customer-churn-analytics")
getwd()

library(readr)
library(dplyr)
library(ggplot2)
library(plyr)
library(tidyr)
library(caret)
library(party)
library(randomForest)
library(MASS)
library(corrplot)
library(gridExtra)

# Import dataset
dataset <- read_csv(file="Telco-Customer-Churn.csv")
str(dataset)

# Check NA values
na_values <- apply(is.na(dataset), 2, which)
na_values

# Delete NA values
na_clean <- na_values$TotalCharges
dataset <- dataset[-c(na_clean), ]

# Dataset without NA values
View(dataset)

# Remove CustomerID column
dataset <- dataset[-1]

# Check Unique values in columns (excluding numerical columns (5, 18, 19))
View(apply(dataset[, c(-5, -18, -19)], 2, unique))

# Change values of SeniorCitizen to the pattern
dataset$SeniorCitizen <- as.factor(mapvalues(dataset$SeniorCitizen,
                                             from=c(0, 1),
                                             to=c("No", "Yes")))

# Change tenure values to categorical
tvalues <- dataset$tenure
tvalues[tvalues < 12] <- "< 1 year"
tvalues[tvalues >= 12 & tvalues < 24] <- "1-2 years"
tvalues[tvalues >= 24 & tvalues < 36] <- "2-3 years"
tvalues[tvalues >= 36 & tvalues < 48] <- "3-4 years"
tvalues[tvalues >= 48 & tvalues < 60] <- "4-5 years"
tvalues[tvalues >= 60] <- "> 5 years"
dataset$tenure <- tvalues

# Tenure categories
tenure_levels <- c("< 1 year", "1-2 years", "2-3 years", "3-4 years",
                  "4-5 years", "> 5 years")
tenure_factor <- ordered(as.factor(dataset$tenure), 
                         levels=tenure_levels)

ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  xlab("") +
  ylab("Total")

# Analyze gender
ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~gender) +
  labs(fill="Time of Service")

# Analyze SeniorCitizen
count(dataset$SeniorCitizen)
ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~SeniorCitizen) +
  labs(fill="Time of Service")

# Analyze Family (Partner and Dependents)
count(dataset$Partner)
ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~Partner) +
  labs(fill="Time of Service")

count(dataset$Dependents)
ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~Dependents) +
  labs(fill="Time of Service")

# Analyze PhoneService and MultipleLines
count(dataset, "PhoneService")
count(dataset, "MultipleLines")

dataset$PhoneService <- NULL

# Analyze InternetService
ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position="dodge", col="black") +
  facet_wrap(~InternetService)

InternetAnalysis <- table(dataset$InternetService, dataset$Churn)
ChurnInternet <- c(
  InternetAnalysis[4]/(InternetAnalysis[1] + InternetAnalysis[4]),
  InternetAnalysis[5]/(InternetAnalysis[2] + InternetAnalysis[5]),
  InternetAnalysis[6]/(InternetAnalysis[3] + InternetAnalysis[6]))
ChurnInternet

# Analyze columns related to Internet Services
cols <- seq(8, 13)
for (i in cols){
  print(table(dataset[, c(i, 19)]))
}

new_dataset <- as.data.frame(dataset[, c(-17, -18)])
data_long <- tidyr::gather(new_dataset, key = type_col, value = categories, -Churn)

ggplot(data_long, aes(x = categories, fill = Churn)) +
  geom_bar(position='dodge', col='black') + 
  facet_wrap(~ type_col, scales = "free_x")

# Analyzing Contract
ggplot(dataset, aes(x=Churn, fill=tenure_factor)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~Contract) +
  labs(fill="Time of Service")

ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~Contract) +
  labs(fill="Time of Service")

# Analyze Paperless Billing
ggplot(dataset, aes(x=Churn, fill=tenure_factor)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~PaperlessBilling) +
  labs(title='Paperless Billing', fill="Time of Service")

ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~PaperlessBilling) +
  labs(title='Paperless Billing', fill="Time of Service")

# Analyze Payment Method
ggplot(dataset, aes(x=Churn, fill=tenure_factor)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~PaymentMethod) +
  labs(fill="Time of Service")

ggplot(dataset, aes(x=tenure_factor, y=fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  facet_wrap(~PaymentMethod) +
  labs(fill="Time of Service")

# Analyze Charges
ggplot(dataset, aes(x=MonthlyCharges, fill=Churn)) +
  geom_histogram(bins=20, col='black') +
  facet_wrap(~ordered(as.factor(tenure),
            levels=tenure_levels), scales="free_x") +
  labs(fill="Churn")

ggplot(dataset, aes(x=TotalCharges, fill=Churn)) +
  geom_histogram(bins=20, col='black') +
  facet_wrap(~ordered(as.factor(tenure),
            levels=tenure_levels), scales="free_x") +
  labs(fill="Churn")

dataset$TotalCharges <- NULL
View(dataset)

# See Correlations between categories and Churn
cols <- seq(1:16)
results <- data.frame(Column=character(), `X-Squared`=double(),
                      `p-value`=double(), stringsAsFactors = FALSE)
for (j in cols){
  coluna <- colnames(new_dataset[j])
  teste <- chisq.test(as.factor(new_dataset[[j]]), as.factor(dataset[["Churn"]]))
  results[j, ] <- c(coluna, teste[1], teste[3])
}
View(results)

# Build Machine Learning models
new_dataset <- dataset
cols <- c(2:12, 14)
for (k in cols){
  new_dataset[[k]] <- as.factor(dataset[[k]])
}

dataset$Churn <- as.factor(mapvalues(dataset$Churn,
                                             from=c("No", "Yes"),
                                             to=c(0, 1)))
dataset <- dataset[c(-1, -3, -4, -6)]
intrain <- createDataPartition(as.factor(new_dataset$Churn), p=0.7,list=FALSE)
train <- new_dataset[intrain, ]
test <- new_dataset[-intrain, ]

  # Logistic Regression
logistic <- glm(Churn ~ ., family=binomial(link='logit'), data=train)
print(summary(logistic))

fitted.results <- predict(logistic, newdata=test,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != test$Churn)
print(paste('Logistic Regression Accuracy',1-misClasificError))
print("Confusion Matrix Para Logistic Regression"); table(test$Churn, fitted.results > 0.5)
exp(cbind(OR=coef(logistic), confint(logistic)))

tree <- ctree(Churn ~ ., train)
plot(tree, type='simple')
pred_tree <- predict(tree, test)
p1 <- predict(tree, train)
tab1 <- table(Predicted = p1, Actual = train$Churn)
tab2 <- table(Predicted = pred_tree, Actual = test$Churn)
print(paste('Decision Tree Accuracy',sum(diag(tab2))/sum(tab2)))

rfModel <- randomForest(Churn ~ ., data = train)
pred_rf <- predict(rfModel, test)
print("Confusion Matrix Para Random Forest"); table(test$Churn, pred_rf)
varImpPlot(rfModel, sort=T, n.var = 10, main = 'Top 10 Feature Importance')
























