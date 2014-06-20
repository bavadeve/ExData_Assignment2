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

totalVehiclesBalt <- tapply(PM25Vehicles$Emissions[PM25Vehicles$fips==24510], PM25Vehicles$year[PM25Vehicles$fips==24510],sum)

png("./figures/plot5.png")
barplot(totalVehiclesBalt,ylab="PM2.5 emission (in tons)",xlab="year", ylim = c(0,350),
        main="Vehicle PM2.5 emission in Baltimore over the years", col = "red")
dev.off()