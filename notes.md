# Info
7043 lines  
21 columns

# Step by step

### Step 1
There are 11 NA values in Total Charges. I'll delete it. After deleting, there are 7032 rows remaining.

### Step 2
Looking to the columns, CustomerId should be removed. 20 columns remaining (19 features, 1 label).

### Step 3
Now I need to analyze column by column to check if it is categorical or quantitative features, and to see the levels.  
- Gender: categorical "Male/Female"  
- SeniorCitizen: categorical "0/1"
- Partner: categorical "Yes/No"
- Dependents: categorical "Yes/No"
- Tenure: quantitative -- Number of months the customer stayed at the company
- PhoneService: categorical "Yes/No"
- MultipleLines: categorical "Yes/No/No Phone Service"
- InternetService: categorical "DSL/Fiber Optic/No"
- OnlineSecurity ~ StreamingMovies: categorical "Yes/No/No internet service"
- Contract: categorical "month-to-month/One year/Two year"
- PaperlessBilling: categorical "Yes/No"
- PaymentMethod: categorical "Electronic check/Mailed check/Bank transfer (automatic)/Credit card (automatic)"
- Churn: categorical "Yes/No"
- TotalCharges: Numerical -- Basically, MonthlyCharges X tenure

### Step 4
- Change SeniorCitizen to "Yes/No" instead of "0/1" just to stick to the pattern.
- Change tenure values from 1 to 72 to "< 1 year" to "> 5 years". Viewing the plot, it is clear that most customers that leave the company, are new clients with less than a year of service.
- Analyzing the gender column related to Churn and tenure, basically there is no difference, the ratio in males that leave the company is the same as the females.
- There are significantly less Senior clients than not seniors (1142 vs 5890), the clients that are not Seniors follows the pattern given in tenure (high positive churn ratio in the first year but decreasing as time increases), but when the client is senior, the leaving ratio tends to be higher (there are more people leaving than staying/entering). After 1 year of service, the churn ratio is positive, but almost equal. This trend only ends after the 4 years of service, when there are clearly a difference between senior that churn and don't.
- In the family categories (partner and dependents), the Partner column is well-distributed (basically No and Yes are equal, 3639 vs 3393) and an interesting behavior about them is that the number of clients without partner tends to decrease as the time increases, and the opposite occurs when the client has a partner (the number os clients that are more time in the company tends to have a partner). Analyzing the churn, there is no special behavior, in the first year the ratio is high and decreases along the time. In the Dependents column, the same thing is visible, but the first year and above 5 years are the tenure when most clients are, kind of U shaped plot. In the first year the number of clients that has no dependents are higher than opposite. But the trend is to decrease too.
- Now, need to analyze PhoneService to see if it is necessary to keep the "No phone service" in MultipleLines column. The PhoneService column has a huge difference between Yes and No, so I deleted that columns and decided to maintain the "No Phone Service" on MultipleLines column.
- Looking to MultipleLines column, all values (No, Yes, No phone service) seems to be well distributed (around 25%) in relation to Churn, what indicates no direct problem in that service.
- InternetService has many differences between services and Churn, so I need to take a look at the tenure for each service to see if it is a tenure problem, or the service problem.
- Looking into tenure in relation to Churn and InternetService, it is clear that fiber optic has some problem, because fiber optic and DSL services have the same proportions in relation to clients with less than 1 year, so the Churn is not about distribution. That said, the InternetService column has to be included. Fiber optic service has a Churn of 41%, meaning a high leaving ratio, which is bad.
- The Internet associated services, when the client has no internet, there are only a few churn. When they have internet but don't have those additional services, the Churn are higher. And when they have those services, the churn is midterm. (NEED TO ANALYZE DEEPER YET, ERASE THIS PARENTHESIS WHEN DONE)
- Need to analyze the type of contract now. The contract column, clearly has a huge range between monthly, yearly and 2yearly contracts. In respect to Churn, in the monthly contract, it is 42% of cancelling. But this is not a problem specific to the contract, it is related to tenure.
- There are much more people into month-to-moth contract that are new clients, that is, less than a year of service. And how tenure is directly impacting the Churn (newer clients tends to cancel more than older clients), that is not sure the impacts of the contract. But starting from 4 years of service, the majority of contracts tends to be yearly or 2 years instead monthly. After 5 years, that difference is clear. Tenure and Contract are high "correlated", but I think that keeping the contract column is more benefitial than it doesn't.
- In the paperless billing column, apparently there is a problem with clients that use it. The trend is to decrease as the service time increases for both types of billing. The problem is that in the first year, clients that use paperless billing tends to leave more frequently. This doesn't prove that paperless billing causes the client to leave, but it is a correlation between them, for sure.
- Same thing for Payment Method, all types tends to decrease as time increases, but something is wrong with electronic check, because in the first year of service, there are more people leaving than staying. After the first year, this difference is barely visible until the second year at least. The other methods follows the pattern in the first year (high leaving ratio, but still positive).
- As the TotalCharges is basically an equation given the MonthlyCharges, that column will be removed.
- On the MonthlyCharges, there is a peak of clients that pays less than 30 dollars, but the churn ratio is low. On the first year, the probability that a client that pays around 45 dollars leave is near 50%. Looking every plot, it's possible to see the high churn ratio "moving" to the right as the service time increases. For newer clients, that range is above 65 dollars, for the one year clients it is about 75 dollars, for the second year same (75 dollars), third year around 75 and 100 dollars, fourth year 100 dollars, same for the fifth year. Possibly the service provided in that range has some problem connected with the previous analysis.

### Step 5
- After analysis of plots, I did a Chi-Squared table with all the data in relation to Churn. The results only reflects the previous analysis, showing that the gender are not relevant to Churn, as well as MultipleLines (yet much stronger than gender), the other variables showed high p-values, which means they are strong correlated to Churn, especially Tenure and Contract.

### Step 6
- Time to build ML models.
- Logistic Regression: 78.94%
- Decision Tree: 77.75%
- Random Forest: 78.04%
- After taking only the 6 more important features, the accuracies became:
- Logistic Regression: 78.61%
- Decision Tree: 77.7%
- Random Forest: 64.09%
- Doesn't changed too much in the lr and dt models, but affected a lot random forest. Based on that, it's better to keep all the variables and use the Logistic regression model.