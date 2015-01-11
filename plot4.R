#Course Project 1
#Fork Github Repository from:
#https://github.com/rdpeng/ExData_Plotting1

#####Istructions from Assignment web page= https://class.coursera.org/exdata-010/human_grading/view/courses/973504/assessments/3/submissions #######

# When loading the dataset into R, please consider the following:
#
# The dataset has 2,075,259 rows and 9 columns. First calculate a rough estimate of how much memory the dataset will require in memory before reading into R. Make sure your computer has enough memory (most modern computers should be fine).
#
# We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to read the data from just those dates rather than reading in the entire dataset and subsetting to those dates.
#
# You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime() and as.Date() functions.
#
# Note that in this dataset missing values are coded as ?.

##########

#Data available at:
#"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#go to home directory
setwd("~/")

#create new directory for download, use abbreviation "HPC" for Household Power Consumption.
if (!file.exists("HPC_data")) {
	dir.create("HPC_data")
}

#move to new directory
setwd("~/HPC_data")

# Download the data and unzip it
source <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

library(RCurl)

# create a temporarily file
file_zipped <- tempfile()

# download file
download.file(url=source, destfile=file_zipped, method="curl", mode="wb")

# unzip file to the current working directory
unzip(zipfile=file_zipped, exdir=".")

# clean the temporarily file
rm(file_zipped)

#check file name
#dir()
#list.files()
#[1] "household_power_consumption.txt"

#read data using read.csv2 command which defaults to ";" separator
HPC_data <- read.csv2("./household_power_consumption.txt", header= TRUE, col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), dec = ".",  stringsAsFactors = FALSE, na.strings = "?")

#check import
#head(HPC_data)
#str(HPC_data)
#summary(HPC_data)


library(lubridate)

HPC_data$Date <- dmy(HPC_data$Date, tz = "America/Los_Angeles")

HPC_data$Time <- hms(HPC_data$Time)

HPC_data$Date <- (HPC_data$Date + HPC_data$Time)

HPC_data <- HPC_data[,-2]

#head(HPC_data)
#str(HPC_data)

#dtime <- difftime(as.POSIXct("2007-02-03"), as.POSIXct("2007-02-01"),units="mins")

feb_1st_2nd_2007 <- subset(HPC_data, HPC_data$Date >= "2007-02-01 00:00:00" & HPC_data$Date < "2007-02-03 00:00:00")

#head(feb_1st_2nd_2007)
#str(feb_1st_2nd_2007)
#summary(feb_1st_2nd_2007)


library(zoo)

feb_1st_2nd_2007_zoo <- zoo(feb_1st_2nd_2007[,2:8], feb_1st_2nd_2007$Date)

png(file = "plot4.png", width = 480, height = 480)

#Insert plot code here
# save off original settings in order to reset on exit
oldPar <- par(no.readonly=TRUE)

par(mfrow = c(2,2))

#top left
hist(feb_1st_2nd_2007$Global_active_power,  main = "", xlab =  "Global Active Power (kilowatts)", col = 2,, xlim = c(0, 6), ylim = c(0, 1200))

#top right
plot(feb_1st_2nd_2007$Voltage, type = "l",  ylab =  "Voltage", xlab = "timedate")


#bottom left
plot(feb_1st_2nd_2007_zoo$Sub_metering_1, ylab =  "Energy sub metering", xlab = "", type = "n")
lines(feb_1st_2nd_2007_zoo$Sub_metering_1, col = 1)
lines(feb_1st_2nd_2007_zoo$Sub_metering_2, col = 2)
lines(feb_1st_2nd_2007_zoo$Sub_metering_3, col = 4)
legend("topright", bty = "n", lwd = 2, lty = , cex = 1, y.intersp = 0.8, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c(1,2,4))

#bottom right
plot(feb_1st_2nd_2007$Global_reactive_power, type = "l",  ylab =  "Global_reactive_power", xlab = "timedate")

dev.off()

par(oldPar)


