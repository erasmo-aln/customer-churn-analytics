# customer-churn-analytics
- OK Brief overview about the business problem, the dataset and the tools used.
- OK The resulting models (lr, dc, rf) and their final accuracies.
- OK Now begins the analysis itself. The first section should be the explanation of each column and the data type (str function).
- OK After knowing the dataset, it is time to clean it up, beginning with NA values and see which column will be removed or not.
- Now, the longest section is this one, that is EDA. Need to analyze each column individually, maybe subsections here could help.
- This one should show the chi-squared test and its results. Discuss about previous conclusions and the chi2 test.
- Now is the time to build models, beginning with logistic regression, then decision tree, then random forest.
- After evaluating these 3 models, check the importance of variables and train again, take conclusions and pick the best models.
- Final conclusion of the analysis.
  
# Customer Churn Analytics
## Project Overview
The goal of this project is to understand why people are leaving (or have left) the company, and how to predict that behavior for other customers. Churn Analytics is very important, because when you understand the people's behavior that leave your company, you can improve your service (or product) specifically to retain those customers, maximizing profit.  
The dataset used is the [`Telco-Customer-Churn.csv`](Telco-Customer-Churn.csv), from a telecommunications company that contains data of more than 7000 customers.  
Three models were used in the predictive modeling: Logistic Regression, Decision Tree and Random Forest. The accuracies reached 78.94%, 77.75% and 78.04%, respectively, which is a relatively good result.

## Table of Contents
- [Understanding the Data](#data)
- [Data Cleaning](#clean)
- [Exploratory Data Analysis](#eda)

<a name="data"></a>
## Understanding the Data
The dataset has 7043 rows and 23 columns. The columns that have *character* types are *categorical* variables and the *numeric* columns will be specified:
- **CustomerId** (*character*): unique identification of each customer.
- **gender** (*character*): the customer's gender, either Male or Female.
- **SeniorCitizen** (*numeric/categorical*): whether the customer is Senior or not (0 or 1).
- **Partner** (*character*): whether the customer has a partner or not (Yes or No).
- **Dependents** (*character*): whether the customer has dependents or not (Yes or No).
- **tenure** (*numeric/discrete*): the number of months the customer has in the company.
- **PhoneService** (*character*): whether the customer has phone service or not (Yes or No).
- **MultipleLines** (*character*): whether the customer has multiple lines or not (Yes, No Phone Service or No).
- **InternetService** (*character*): the type of internet the customer has (DSL, Fiber optic or No).
- **OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies** (*character*): whether the customer has each service or not (Yes, No or No internet service).
- **Contract** (*character*): the kind of contract (month-to-month, One year, Two year).
- **PaperlessBilling** (*character*): whether the customer has paperless billing or not (Yes or No).
- **PaymentMethod** (*character*): the method of payment (Electronic check, Mailed check, Bank transfer (automatic), Credit card (automatic)).
- **MonthlyCharges** (*numeric/continuous*): the monthly charges in dollars.
- **TotalCharges** (*numeric/continuous*): the total charges since the customer entered in the company.
- **Churn** (*character*): whether the customer left the company or not (Yes or No).

<a name="clean"></a>
## Data Cleaning
- The dataset contains 11 NA values in the column **TotalCharges**. Considering that this is equivalent to *0.15%* of the total, these rows were removed, remaining 7032 rows.  
- The column **CustomerId** is only an identifier, so it can be excluded.
- All categorical variables are *character* type, so the **SeniorCitizen** was changed from 1/0 to Yes/No to keep the pattern.
- The tenure column can be converted to categorical too, but before we'll do some analysis on it.

<a name="eda"></a>
## Exploratory Data Analysis




