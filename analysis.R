setwd("C:/Users/Erasmo/OneDrive/Projects/customer-churn-analytics")
getwd()

library(readr)
library(plyr)
library(ggplot2)
library(caret)
library(party)
library(randomForest)

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

# Change values of SeniorCitizen to the pattern
dataset$SeniorCitizen <- as.factor(mapvalues(dataset$SeniorCitizen, # plyr
                                             from=c(0, 1),
                                             to=c("No", "Yes")))

# Change tenure values to categorical
ggplot(dataset, aes(x=as.factor(tenure), fill=Churn)) +
  xlab('') +
  ylab('') +
  geom_bar(position='fill')

ggplot(dataset, aes(y=tenure, x="", fill=Churn)) + 
  stat_boxplot(geom='errorbar') +
  xlab('Churn') +
  ylab('Tenure') +
  geom_boxplot()

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
  geom_bar(position='fill', col='black') +
  xlab("") +
  ylab("")

# Analyze gender
ggplot(dataset, aes(y=gender, fill=Churn)) +
  geom_bar(position='fill', col='black') +
  xlab('') +
  ylab('')

ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position='fill', col='black') +
  facet_wrap(~gender) +
  xlab('') +
  ylab('') +
  labs(fill="Churn")

# Analyze SeniorCitizen
count(dataset$SeniorCitizen)
table(dataset$SeniorCitizen, dataset$tenure)

ggplot(dataset, aes(y=SeniorCitizen, fill=Churn)) +
  geom_bar(position='fill', col='black') +
  xlab('') +
  ylab('')

ggplot(dataset, aes(x=tenure_factor, fill=Churn)) +
  geom_bar(position='fill', col='black') +
  facet_wrap(~SeniorCitizen) +
  xlab('') +
  ylab('')

# Analyze Family (Partner and Dependents)
count(dataset$Partner)
table(dataset$Partner, dataset$tenure)

ggplot(dataset, aes(y=Partner, fill=Churn)) +
  geom_bar(position='fill', col='black') +
  xlab('') +
  ylab('')

ggplot(dataset, aes(x=Partner, fill=Churn)) +
  geom_bar(position='fill', col='black') +
  facet_grid(~ordered(as.factor(dataset$tenure), 
                      levels=tenure_levels)) +
  xlab('') +
  ylab('')

ggplot(dataset, aes(x=Churn, fill=Partner)) +
  geom_bar(position='dodge', col='black') +
  facet_grid(~ordered(as.factor(dataset$tenure), 
                      levels=tenure_levels)) +
  xlab('Churn') +
  ylab('')

count(dataset$Dependents)
table(dataset$Dependents, dataset$tenure)

ggplot(dataset, aes(y=Dependents, fill=Churn)) +
  geom_bar(position='fill', col='black') +
  xlab('') +
  ylab('')

ggplot(dataset, aes(x=Churn, fill=Dependents)) +
  geom_bar(position='dodge', col='black') +
  facet_grid(~ordered(as.factor(dataset$tenure), 
                       levels=tenure_levels)) +
  xlab('') +
  ylab('')

# Analyze PhoneService and MultipleLines
count(dataset$PhoneService)
ggplot(dataset, aes(y=PhoneService, fill=Churn)) +
  geom_bar(position='fill', col='black') +
  xlab('') +
  ylab('')

count(dataset$MultipleLines)
ggplot(dataset, aes(y=MultipleLines, fill=Churn)) +
  geom_bar(position='fill', col='black') +
  xlab('') +
  ylab('')

# Analyze InternetService
table(dataset$InternetService, dataset$Churn)

ggplot(dataset, aes(x=InternetService, fill=Churn)) +
  geom_bar(position="fill", col="black") +
  facet_grid(~ordered(as.factor(dataset$tenure), 
                      levels=tenure_levels)) +
  xlab('') +
  ylab('')

# Analyze columns related to Internet Services
library(gridExtra)

cols <- seq(9, 14)
for (i in cols){
  print(table(dataset[, c(i, 20)]))
}

new_df <- dataset[, c(9:14, 20)]
new_long <- tidyr::gather(new_df, key = type_col, value = categories, -Churn)

first_year_df <- dataset[dataset$tenure == "< 1 year", c(9:14, 20)]
first_year_long <- tidyr::gather(first_year_df, key = type_col, value = categories, -Churn)

ggplot(new_long, aes(x = categories, fill = Churn)) +
  geom_bar(position='dodge', col='black') + 
  facet_wrap(~ type_col, scales = "free_x")

ggplot(first_year_long, aes(x = categories, fill = Churn)) +
  geom_bar(position='dodge', col='black') + 
  facet_wrap(~ type_col, scales = "free_x")

# Analyzing Contract
ggplot(dataset, aes(x=Contract, fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  facet_grid(~ordered(as.factor(dataset$tenure), 
                      levels=tenure_levels)) +
  xlab('') +
  ylab('')

# Analyze Paperless Billing
ggplot(dataset, aes(x=PaperlessBilling, fill=Churn)) +
  geom_bar(position='dodge', col='black') +
  facet_grid(~ordered(as.factor(dataset$tenure), 
                      levels=tenure_levels)) +
  xlab('') +
  ylab('')

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
cols <- c(1, 3:17)
for (k in cols){
  dataset[[k]] <- as.factor(dataset[[k]])
}

dataset$Churn <- as.factor(mapvalues(dataset$Churn,
                                             from=c("No", "Yes"),
                                             to=c(0, 1)))
dataset <- dataset[c(2, 3, 4, 11, 13, 14, 15)]
intrain <- createDataPartition(as.factor(dataset$Churn), p=0.7,list=FALSE) #caret
train <- dataset[intrain, ]
test <- dataset[-intrain, ]

dataset$gender <- NULL
dataset$Partner <- NULL
dataset$Dependents <- NULL
dataset$MultipleLines <- NULL

  # Logistic Regression
lr <- glm(Churn ~ ., family=binomial(link='logit'), data=train)
print(summary(lr))

preds_lr <- predict(lr, newdata=test, type='response')
preds_lr <- ifelse(preds_lr > 0.3, 1, 0)

wrong_preds <- mean(preds_lr != test$Churn)
confusion_lr <- table(test$Churn, preds_lr)

lr_acc <- signif((1-wrong_preds)*100, digits=4)
lr_rec <- signif((confusion_lr[4]/(confusion_lr[2] + confusion_lr[4]))*100, digits=4)
lr_pre <- signif((confusion_lr[4]/(confusion_lr[3] + confusion_lr[4]))*100, digits=4)
lr_f1 <- signif((2*(lr_pre*lr_rec)/(lr_pre + lr_rec)), digits=4)

results <- data.frame(Model=c('Logistic Regression'), Accuracy=c(lr_acc),
                      Precision=c(lr_pre), Recall=c(lr_rec),
                      `F1 Score`=c(lr_f1))

print(paste('LR Accuracy: ', lr_acc, '%', sep=""))
print(paste('LR Precision: ', lr_pre, '%', sep=''))
print(paste('LR Recall: ', lr_rec, '%', sep=''))
print(paste('LR F1 Score: ', lr_f1, '%', sep=''))

print("Confusion Matrix Para Logistic Regression"); confusion_lr

  # Decision Tree
tree <- ctree(Churn ~ ., train) #party
plot(tree, type='simple')

preds_tree <- predict(tree, test)

confusion_tree <- table(Predicted = preds_tree, Actual = test$Churn)
tree_acc <- sum(diag(confusion_tree))/sum(confusion_tree)
print(paste('Decision Tree Accuracy: ', signif(tree_acc*100, digits=4), '%', sep=''))

  # Random Forest
rf <- randomForest(Churn ~ ., data = train)
preds_rf <- predict(rf, test)

confusion_rf <- table(Predicted=preds_rf, Actual=test$Churn)
rf_acc <- sum(diag(confusion_rf))/sum(confusion_rf)
print(paste('Random Forest Accuracy: ', signif(rf_acc*100, 4), '%', sep=''))

varImpPlot(rf, sort=T, n.var = 10, main = 'Top 10 Feature Importance')

print("Summary")
print(paste('Logistic Regression Accuracy: ', signif((1-wrong_preds)*100, digits=4),'%', sep=""))
print(paste('Decision Tree Accuracy: ', signif(tree_acc*100, digits=4), '%', sep=''))
print(paste('Random Forest Accuracy: ', signif(rf_acc*100, 4), '%', sep=''))