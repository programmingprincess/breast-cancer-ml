# breast-cancer-ml
This project will attempt to classify breast cancer tumors into two categories, benign or malignant, depending on tumor characteristics. We will use the Wisconsin Diagnostic Breast Cancer dataset, obtained from [Kaggle](https://www.kaggle.com/uciml/breast-cancer-wisconsin-data). This is the final project for our statistical machine learning course. 

## Data prep 
Attributes include ID number, diagnosis (B = benign, M = malignant), and 30 real-valued input features. Features are computed from a digitized image of breast mass, and the data describes characteristics of the cell nuclei present in the image.

First, we removed the ID attribute from the dataset because it does not correlate with diagnosis. Then, we created a dataset with only the variables we wantd to use: columns 1 through 11 (diagnosis column and 10 mean-value features).

We also added a column that maps B (benign) to 0 and M (malignant) to 1. This column contains the same information as the original diagnosis column, except the values are 0 and 1 rather than B and M (respectively). In total, the dataset contains 569 observations and 12 variables. We split the data into two sets to build our models: 70% training data, and 30% test data.

# Methods used: 

## Logistic Regression 
We used generalized linear models (glm) to model our data. Since the outcome we are trying to predict is binomial (benign or malignant), we chose a logistic regression model.

## K-Nearest Neighbors 
We used the r package kknn to fit our knn model. To begin, we ran cross-validation once with a large interval of k-values to find an appropriate range of values. Then, with a smaller interval, we ran 10-fold cross validation multiple times to find the optimal k-value. We fit our test data using the optimal k-value, and generated plots and a confusion matrix to determine accuracy.

## Naive Bayesian Classification
We used a Naive Bayesian Classifier (e1071) to model the data on on a conditionally independent basis. The outcome prediction is binomial, which is a great fit for Naive Bayesian Classifiers. After tuning the laplace value for lowest misclassification rate, we ran Naive Bayes classification with laplace=1.

## Neural Net
We used a neural network (nnet) package to create a single layer neural net. Tuning was performed with multiple network structures, with different numbers of nodes in the hidden layer. After tuning and analysis, our chosen model included a hidden layer with 5 nodes.
