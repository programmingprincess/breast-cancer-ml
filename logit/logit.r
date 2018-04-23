# clean working environment
# rm(list=ls()) 

# wdbc = wisconsin diagnostic breast cancer 
wdbc<- read.csv("brcancer.csv", header=TRUE)


attach(wdbc)

# Check correlation analysis by plotting
plot(wdbc[c(1:9,31)], col=wdbc$diagnosis)

set.seed(1)
train = sample.split(wdbc, SplitRatio = 0.70)

glm.fit = glm(diagnosis~.,data=wdbc,family=binomial)

glm.git <- glm(Diag~.-id, data=train,family="binomial",metric='accuracy')

# plot(wdbc[c(3:7)], col=brcancer$Diag)