if(!file.exists("./data/summarySCC_PM25.rds")){
        if(!file.exists("./data")){dir.create("data")}
        
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileUrl, destfile = "./data/PM25.zip")
        unzip("./data/PM25.zip",exdir="./data")
        unlink("./data/PM25.zip"); 
}

if(!exists("PM25EmissionData")){
        PM25EmissionData <- readRDS("./data/summarySCC_PM25.rds")
}

PM25Baltimore <- PM25EmissionData[PM25EmissionData$fips==24510,]
PM25Baltimore$year <- factor(PM25Baltimore$year) 
PM25Baltimore$type <- factor(PM25Baltimore$type) 

require(ggplot2)
require(grid)

g <- ggplot(PM25Baltimore,aes(x = year, y = Emissions))

png("./figures/plot3.png", width=1000,height=480)
g + geom_bar(stat = "identity") + facet_grid(.~type) + 
        ggtitle("PM2.5 emission in Baltimore through the years for each type of emission") +
        theme(plot.title = element_text(face="bold",vjust=2)) + 
        theme(plot.margin = unit(c(1,1,1,0),"cm")) +
        ylab("PM2.5 Emission (in tons)")
dev.off()
