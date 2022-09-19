library(factoextra)
library(mlr3)

library(readr)
ops_data <- read_csv("ops_data.csv", col_types = cols(...1 = col_skip()))
View(ops_data)

## nw_opsData <- ops_data[1:99]

set.seed(100)
sam_scale_ops <- ops_data[sample(1:nrow(ops_data), 5000),]
scale_opsData <- scale(sam_scale_ops) #scale the dataset 



##sam_scale_ops <- as.matrix(dist(sam_scale_ops)) #calc distancew

##Cal how many clusters elbow 
fviz_nbclust(sam_scale_ops, kmeans, method = "wss") + 
  labs(subtitle = "elbow method")

km.out <- kmeans(sam_scale_ops,centers = 6, nstart = 1000)
km.cluster <- km.out$cluster

fviz_cluster(km.out, data = sam_scale_ops[, -5],
             palette = c("#df8e2e","#2E9FDF", "#00AFBB", "#E7B800", "#09192c", "#bb8f0a"), 
             geom = "point",
             ellipse.type = "convex", 
             ggtheme = theme_bw()
)


library(mclust)
library(ggplot2)
par(mar=c(100,100,100,100))

ggpairs(sam_scale_ops[,2:5])

ggplot(data = ops_data[,2:8], aes(x=Demand_Node_2,y=Demand_Node_5)) + 
  geom_point()+ geom_density2d()

mc <- Mclust(sam_scale_ops)
mc.2 <- Mclust(ops_data[,2:8])
fviz_mclust_bic(mc.2)
plot(mc.2)
