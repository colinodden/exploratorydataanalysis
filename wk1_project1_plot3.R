# Exploratory Data Analysis
# Week 1 Project
# Colin Odden
# colin.odden@osumc.edu
# 
#  @goal: examine household energy usage, constructing a set of plots
#  @materials: individual household electric power consumption data set,
#   source UC Irvine Machine Learning Data Repository

# packages
library(sqldf)
library(curl)

# settings
setwd("D:\\grc\\profdev\\coursera\\exp_dat_anal")
plot_width  =  480
plot_height  =  480

# read it
# install.packages("sqldf")

# load stuff
url_data <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
thefile <- "household_power_consumption.txt"

# download, unzip and cue up our data
if(!file.exists(thefile)) {
  temp <- tempfile()
  download.file(url_data,temp)
  thefile <- unzip(temp)
  unlink(temp)
}

hpc <- read.table(thefile, sep = ";", header = TRUE)

hpc$Date <- as.Date(hpc$Date, format = "%d/%m/%Y")
dim(hpc) # 9 vars, 2075259 rows
hpc <- hpc[(hpc$Date == "2007-02-01") | (hpc$Date == "2007-02-02"),]
dim(hpc) # 9 vars, 1440 rows
hpc$Global_active_power <- as.numeric(as.character(hpc$Global_active_power))
hpc$Global_reactive_power <- as.numeric(as.character(hpc$Global_reactive_power))
hpc$Voltage <- as.numeric(as.character(hpc$Voltage))
hpc$Sub_metering_1 <- as.numeric(as.character(hpc$Sub_metering_1))
hpc$Sub_metering_2 <- as.numeric(as.character(hpc$Sub_metering_2))
hpc$Sub_metering_3 <- as.numeric(as.character(hpc$Sub_metering_3))
hpc <- transform(hpc, timestamp = as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

dim(hpc)
head(hpc)

hpc <- hpc[order(hpc$Date,hpc$Time),] # we want to sort by date in all instances that follow, so let's do it here:
hpc <- transform(hpc, timestamp = as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

# plot 3 - Three overlaid connected scatterplots of the sub-metered rates
png(
  filename = "wk1_plot2.png"
  , width = plot_width
  , height = plot_height
)

label_y <- "Global Active Power (kilowatts)"
label_x <- ""
plot(
  hpc$timestamp
  , hpc$Sub_metering_1
  , type = "l"
  ,  xlab = label_x
  , ylab = "Energy sub metering"
)
lines(
  hpc$timestamp
  , hpc$Sub_metering_2
  , type = "l"
  , col = "red"
)
lines(
  hpc$timestamp
  , hpc$Sub_metering_3
  , type = "l"
  , col = "blue"
)
legend(
  "topright"
  , col = c("black","red","blue")
  , c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
  , lty = c(1,1)
  , lwd = c(1,1)
)
dev.off()
