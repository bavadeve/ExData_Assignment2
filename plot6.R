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

SCCVehicles <-  as.character(mapping$SCC[grepl("Vehicles",mapping$EI.Sector)])
VehiclesIndex <- PM25EmissionData$SCC %in% SCCVehicles
PM25Vehicles <- PM25EmissionData[VehiclesIndex,]

baltAndLAVehicles <- PM25Vehicles[(PM25Vehicles$fips=="24510"|PM25Vehicles$fips=="06037"),]
baltAndLAVehicles$fips <- factor(baltAndLAVehicles$fips, labels=c("Los Angeles","Baltimore"))
baltAndLAVehicles$year <- factor(baltAndLAVehicles$year)

require(ggplot2)
g <- ggplot(baltAndLAVehicles,aes(x = year, y = Emissions))


png("./figures/plot6.png")
g + geom_bar(stat = "identity") + facet_grid(.~fips) + ggtitle("Trend of vehicle PM2.5 emission in Baltimore and Los Angeles") +
        theme(plot.title = element_text(face="bold"))
dev.off()