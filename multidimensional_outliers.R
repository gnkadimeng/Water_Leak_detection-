
X=SC10[,10:30]        # has 11 columns
X$LEAK <- seq(0,0, length.out = nrow(X))
X <- select(X, -LEAK)


Xval=SC10[START:END,] # This is cross-validation data
Xval <- Xval[,10:30]
Xval <- select(Xval, -LEAK)
Xval$LEAK <- seq(1,1, length.out = nrow(Xval))
yval = as.data.frame(Xval$LEAK)  # This shows which rows in Xval are anomalous

dim(yval)

X%>%as.data.frame()%>%melt()%>%
  ggplot(aes(x=value,color=variable))+geom_density()

cat("Number of variables and observations of X")
dim(X)

cat("Number of variables and observations of cross-validation data")
dim(Xval)

cat("Labels of cross-validation data")
cat("\ny=0 corresponds to normal servers and y=1 corresponds to anomalous servers")
dim(yval)

Xval%>%as.data.frame()%>%melt()%>%
  ggplot(aes(x=value,color=variable))+geom_density()

# Create preProcess object
X = as.data.frame(X)
preObj <- preProcess(X,method="center")

# Center the data- subtract the column means from the data points
X2 <- predict(preObj,X)

#####

sigma2=cov(X2)
sigma2=diag(sigma2)
sigma2=diag(sigma2)

###Calculate probability for X:

X2= as.matrix(X2)
A=(2*pi)^(-ncol(X2)/2)*det(sigma2)^(-0.5)

B = exp(-0.5 *rowSums((X2%*%ginv(sigma2))*X2))
p = A*B

###Next, let's calculate probabilties for the cross-validation data (Xval).

# Create preProcess object
Xval = as.data.frame(Xval)
preObj <- preProcess(Xval,method="center")

# Center the data- subtract the column means from the data points

Xval_centered <- predict(preObj,Xval)



Xval_centered = as.matrix(Xval_centered)
sigma2=diag(var(Xval_centered))
sigma2= diag(sigma2)

A=(2*pi)^(-ncol(Xval_centered)/2)*det(sigma2)^(-0.5)

B = exp(-0.5 *rowSums((Xval_centered%*%ginv(sigma2))*Xval_centered))
pval = A*B

#####Now, we can determine the best probability threshold and also the associated F1 score.

bestEpsilon = 0
bestF1 = 0
F1 = 0

stepsize = (max(pval) - min(pval)) / 1000

for (epsilon in seq(from =min(pval), by= stepsize,to =max(pval))){
  
  predictions = (pval < epsilon)*1
  
  tp = sum((predictions == 1) & (yval == 1))
  fp = sum((predictions == 1) & (yval == 0))
  fn = sum((predictions == 0) & (yval == 1))
  prec = tp / (tp + fp)
  rec = tp / (tp + fn)
  F1 = (2 * prec * rec) / (prec + rec)
  
  if (!is.na(F1)& (F1 > bestF1)==TRUE){
    bestF1 = F1
    bestEpsilon = epsilon
    
  }
}

cat("\n bestF1 =",bestF1)
cat("\n bestEpsilon =",bestEpsilon)

####Finally, let's calculate the number of anomalous and normal servers.'


probability=p
X=cbind(X,probability)
X$outliers= X$probability < bestEpsilon
X$outliers=as.factor(X$outliers)

table(X$outliers)

X$outliers= X$probability < bestEpsilon
X$outliers=as.factor(X$outliers)
View(X)

