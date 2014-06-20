if(!file.exists("./data/summarySCC_PM25.rds")){
        if(!file.exists("./data")){dir.create("data")}
        
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileUrl, destfile = "./data/PM25.zip")
        unzip("./data/PM25.zip",exdir="./data")
        unlink("./data/PM25.zip"); 
}

if(!(exists("PM25EmissionData") & exists("mapping"))){
        PM25EmissionData <- readRDS("./data/summarySCC_PM25.rds")
        mapping <- readRDS("./data/Source_Classification_Code.rds")
}


SCCCoalComb <-  as.character(mapping$SCC[grepl("Comb.*Coal",mapping$EI.Sector)])
CoalCombIndex <- PM25EmissionData$SCC %in% SCCCoalComb
PM25CoalComb <- PM25EmissionData[CoalCombIndex,]

totalCoalCombPerYear <- tapply(PM25CoalComb$Emissions, PM25CoalComb$year,sum)

png("./figures/plot4.png")
barplot(totalCoalCombPerYear/1000000,ylab="PM2.5 emission (in million tons)",xlab="year", ylim = c(0,0.6),
        main="Coal Combustion PM2.5 emission in the USA over the years", col = "red")
dev.off()