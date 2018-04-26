# clean working environment
# rm(list=ls()) 

# get libraries 
#source('http://www.rob-mcculloch.org/2018_ml/webpage/notes/robfuns.R')
#source('http://www.rob-mcculloch.org/2018_ml/webpage/notes/rob-utility-funs.R')
#require(dplyr)
# dpl=FALSE

# wdbc = wisconsin diagnostic breast cancer 
wdbc = read.csv("brcancer.csv", header=TRUE)
wdbc = wdbc[,-1] #remove ID from dataset
wdbc = wdbc[1:11] #use means only
wdbc = wdbc[1:11] #only use means 

wdbc$diagnosis2 = ifelse(wdbc$diagnosis == "M", 1, 0)
colnames(wdbc) = gsub(" ", "_", colnames(wdbc))

# split dataset into train/test 
n = nrow(wdbc) #num "rows" in data
set.seed(30) 
ntrain = floor(n*0.70) #70% for train 
ii = sample(1:n,ntrain) #reorder elements randomly
wdbc_train = wdbc[ii,]
wdbc_test= wdbc[-ii,]


wdbc_testy = wdbc_test$diagnosis2
wdbc_trainy = wdbc_train$diagnosis2 

logit.model = glm(wdbc_train$diagnosis2 ~ ., data = wdbc_train[-c(1)]) 
#logit.model1 = glm(wdbc_train$diagnosis2 ~ ., data = wdbc_train[-c(1)], family=binomial(link='logit')) 

#prints out regression output 
summary(logit.model) 

yhat = predict(logit.model,wdbc_test)

#split values by probability 
yhatbin = ifelse(yhat > 0.5,1,0) 

# get confusion matrix 
table(yhatbin, wdbc_testy)

# plot distributed values 
plot(yhat, wdbc_testy)

