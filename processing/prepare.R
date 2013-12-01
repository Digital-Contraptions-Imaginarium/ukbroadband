# The objective of this pre-processing script is to download the original Ofcom
# data and to pre-process it into manageable smaller pieces, suitable for being 
# fetched by a web page on demand.

# download and unzip the data
download.file("http://d2a9983j4okwzn.cloudfront.net/downloads/ofcom-uk-fixed-broadband-postcode-level-data-2013.zip", destfile = "./ofcom-uk-fixed-broadband-postcode-level-data-2013.zip")
unzip("./ofcom-uk-fixed-broadband-postcode-level-data-2013.zip", exdir = "./ofcom-uk-fixed-broadband-postcode-level-data-2013", overwrite = TRUE)

# read the data and assemble in one data.frame
b1 <- read.csv("./ofcom-uk-fixed-broadband-postcode-level-data-2013/ofcom-part1-fixed-broadband-postcode-level-data-2013.csv", na.strings = "N/A", colClasses = c("factor", "factor", "character", "character", "character", "character", "character", "character"))
b2 <- read.csv("./ofcom-uk-fixed-broadband-postcode-level-data-2013/ofcom-part1-fixed-broadband-postcode-level-data-2013.csv", na.strings = "N/A", colClasses = c("factor", "factor", "character", "character", "character", "character", "character", "character"))
b <- rbind(b1, b2)
rm(b1, b2)

# transform Y/N columns to logical values
b$Lines...2Mbps.Y.N.[b$Lines...2Mbps.Y.N. == "N"] <- "FALSE"
b$Lines...2Mbps.Y.N.[b$Lines...2Mbps.Y.N. == "Y"] <- "TRUE"
b$Lines...2Mbps.Y.N. <- as.logical(b$Lines...2Mbps.Y.N.)
b$NGA.Available.Y.N.[b$NGA.Available.Y.N. == "N"] <- "FALSE"
b$NGA.Available.Y.N.[b$NGA.Available.Y.N. == "Y"] <- "TRUE"
b$NGA.Available.Y.N. <- as.logical(b$NGA.Available.Y.N.)

# replace *.Speed.Mbps values expressed as ">=30" with "30" and make them numeric
b$Average.Speed.Mbps[b$Average.Speed.Mbps == ">=30"] <- "30"
b$Average.Speed.Mbps <- as.numeric(b$Average.Speed.Mbps)
b$Median.Speed.Mbps[b$Median.Speed.Mbps == ">=30"] <- "30"
b$Median.Speed.Mbps <- as.numeric(b$Median.Speed.Mbps)
b$Maximum.Speed.Mbps[b$Maximum.Speed.Mbps == ">=30"] <- "30"
b$Maximum.Speed.Mbps <- as.numeric(b$Maximum.Speed.Mbps)

# replace Number.of.Connections expressed as "<3" with "1" and make them numeric
b$Number.of.Connections[b$Number.of.Connections == "<3"] <- "1"
b$Number.of.Connections <- as.numeric(b$Number.of.Connections)

# create one .csv file for each first four letter
for (prefix in unique(substr(b$Postcode.No.Spaces., 1, 4))) {
    sub <- b[grep(paste0("^", prefix, sep = ""), b$Postcode.No.Spaces.), ]
    if (nrow(sub) > 0) {
        write.csv(sub, file = paste0("../web/data/", prefix, ".csv", sep=""), row.names = FALSE)
    }
}
