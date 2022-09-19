#Demand 

folder_demand <- "~/Projects/LeakDB/CCWI-WDSA2018/Benchmarks/Hanoi_CMH/Scenario-1/Demands"

demand_data1 <- clean_scenarioData(folder_demand, "Demand_Node_")

#Pressure scenario 2

folder_pressure <- "~/Projects/LeakDB/CCWI-WDSA2018/Benchmarks/Hanoi_CMH/Scenario-1/Pressures"

pressure_data1 <- clean_scenarioData(folder_pressure,"Pressure_Node_")
head(pressure_data1)

##Flow 

flow_folder <- "~/Projects/LeakDB/CCWI-WDSA2018/Benchmarks/Hanoi_CMH/Scenario-1/Flows"   

flow_data1 <- clean_scenarioData(flow_folder,"Flow_Link_")
head(flow_data1)


##merged scenario 1 dataset
SC1 <- cbind(demand_data1,flow_data1, pressure_data1)

ops_data <- rbind(SC1,SC2,SC3,SC4,SC5,SC6,SC7, SC8,SC9,SC10)

write.csv(ops_data, "ops_data.csv")
##View(ops_data)




dcol <- seq(from=as.POSIXct("2017-01-01 00:00:00"),to= as.POSIXct("2017-12-31 23:30:00") ,by="30 min")
SC1$Time <- dcol
