# clean working environment
# rm(list=ls()) 

library(kknn)
source("http://www.rob-mcculloch.org/2018_ml/webpage/R/docv.R")

# wdbc = wisconsin diagnostic breast cancer 
wdbc<- read.csv("brcancer.csv", header=TRUE)
wdbc <- wdbc[,-1] #remove ID from dataset
means = wdbc[2:11]

## Split into 70% train, 30% test 
## Example from hw4.r 
n = nrow(wdbc) #num "rows" in data
set.seed(30) 
ntrain = floor(n*0.70) #70% for train 
ii = sample(1:n,ntrain) #reorder elements randomly
wdbc_train = wdbc[ii,]
wdbc_test= wdbc[-ii,]

# assign variables as x and y
x=wdbc_train[,2:11] #only use mean data; 2:11
y=wdbc_train[,1]

# apply scaling function to each column of x
mmsc=function(x){return((x-min(x))/(max(x)-min(x)))}
xs = apply(x,2,mmsc) #scaling function 

#plot y vs each x
# TODO: figure out how to plot all of them at once
par(mfrow=c(1,2)) #two plot frames
pdf(file="crossval-test.pdf")
plot(x[,1],y,xlab="radius_mean",ylab="diagnosis")
dev.off()

# benign = 0
# malignant = 1 
levels(y) = c(0,1)

# turn y into a vector, yv, for cross-val 
yv = as.numeric(as.vector(y))

#run cross val once
par(mfrow=c(1,1)) 
#set.seed(30) 
kv = seq(1, 100, 5) #k values to try
n = length(yv)
cvtemp = docvknn(xs,yv,kv,nfold=10)
cvtemp = sqrt(cvtemp/n) #docvknn returns sum of squares
plot(kv,cvtemp)

# Preliminary plot for values of k versus cvmean, comparing the k parameter from 2 to 30 with 
# the RMSE of a single model. This allows us to approximate range of appropriate k values 
# before moving onto a more computationally expensive model. Looks like the optimal k value is
# somewhere around k=19, so we will reset the kv value to a smaller window

kv = 2:30 #new k values to try
#run cross val multiple times 
#set.seed(30) 

cvmean = rep(0,length(kv))
ndocv = 15 # number of CV splits to try...50 took forever so I changed to 10
n=length(yv) #vector version of y
cvmat = matrix(0,length(kv),ndocv) # track results for each split
for(i in 1:ndocv) {
    cvtemp = docvknn(xs, yv, kv, nfold=10)
    cvmean = cvmean + cvtemp
    #cat("cvmean: ", cvmean, "/n/n/n")
    cvmat[,i] = sqrt(cvtemp/n)
}
cvmean = cvmean/ndocv
cvmean = sqrt(cvmean/n)
plot(kv,cvmean,type="n",ylim=range(cvmat),xlab="k",cex.lab=1.5)
for(i in 1:ndocv) lines(kv,cvmat[,i],col=i,lty=3)  #plot each result
lines(kv,cvmean,type="b",col="black",lwd=2)  #plot average result

#print table of k's and rmse's
for(i in 2:29) {
  cat("k=",i, " rmse=", cvmean[i], "\n")  
} 

cat("optimal k=", which.min(cvmean), "with average rmse of ", min(cvmean), "\n")



# Plot of k verses cvmean, which compares the paramter k at values between 2 and 30 with the
# RMSE of each model (calculated by comparing against the testing data). Each colored line represents a
# different subset of the training data that, when averaged together to produce the black line, reduces bias and
# variance in the model.


# refit using k=17

#TODO: not sure if i should be using y or yv here... 
ddf = data.frame(yv,xs)
near17 = kknn(yv~.,ddf,ddf,k=17,kernel="rectangular")
lmf = lm(yv~.,ddf)
fmat = cbind(yv,near17$fitted,lmf$fitted)

#lets see how our knn model compares to linear 
colnames(fmat) = c("y","kNN17","linear")
pairs(fmat)
print(cor(fmat))





