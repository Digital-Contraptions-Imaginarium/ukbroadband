# The objective of this pre-processing script is to download the original Ofcom
# data and to pre-process it into manageable smaller pieces, suitable for being 
# fetched by a web page on demand.

library(rjson)

# Thanks to http://theweiluo.wordpress.com/2011/09/30/r-to-json-for-d3-js-and-protovis/
toJSONArray <- function (dtf) {
    clnms <- colnames(dtf)
    name.value <- function (i){
        quote <- '';
        if(class(dtf[, i])!='numeric'){
            quote <- '"';
        }
        paste('"', i, '" : ', quote, dtf[,i], quote, sep='')
    }
    objs <- apply(sapply(clnms, name.value), 1, function(x){paste(x, collapse=', ')})
    objs <- paste('{', objs, '}')
    res <- paste('[', paste(objs, collapse=', '), ']')
    return(res)
}

# download and unzip the data
download.file("http://d2a9983j4okwzn.cloudfront.net/downloads/ofcom-uk-fixed-broadband-postcode-level-data-2013.zip", destfile = "./ofcom-uk-fixed-broadband-postcode-level-data-2013.zip")
unzip("./ofcom-uk-fixed-broadband-postcode-level-data-2013.zip", exdir = "./ofcom-uk-fixed-broadband-postcode-level-data-2013", overwrite = TRUE)

# read the data and assemble in one data.frame
b1 <- read.csv("./ofcom-uk-fixed-broadband-postcode-level-data-2013/ofcom-part1-fixed-broadband-postcode-level-data-2013.csv", na.strings = "N/A", colClasses = c("factor", "factor", "character", "character", "character", "character", "character", "character"))
b2 <- read.csv("./ofcom-uk-fixed-broadband-postcode-level-data-2013/ofcom-part2-fixed-broadband-postcode-level-data-2013.csv", na.strings = "N/A", colClasses = c("factor", "factor", "character", "character", "character", "character", "character", "character"))
b <- rbind(b1, b2)
rm(b1, b2)

# It has been recorded that there are duplicate rows in the original data. When
# that happens, for each couple of records' Postcode.Data.Status is "Insufficient
# Premises" and "No Data". In the light of what "Insufficient Premises" means,
# I assume that that record is more meaningful than the "No Data" one. I remove
# the "No Data" duplicates.
duplicatePostcodes <- unique(b$Postcode.No.Spaces.[duplicated(b$Postcode.No.Spaces.)])
b <- subset(b, !((Postcode.No.Spaces. %in% duplicatePostcodes) & (Postcode.Data.Status == 'No Data')))

# rename the columns
names(b)[names(b) == "Postcode.No.Spaces."] <- "Postcode.No.Spaces"
names(b)[names(b) == "Lines...2Mbps.Y.N."] <- "Lines.Less.Than.2Mbps.T.F"
names(b)[names(b) == "NGA.Available.Y.N."] <- "Superfast.Broadband.Available.T.F"

# transform Y/N columns to logical values
b$Lines.Less.Than.2Mbps.T.F[b$Lines.Less.Than.2Mbps.T.F == "N"] <- "FALSE"
b$Lines.Less.Than.2Mbps.T.F[b$Lines.Less.Than.2Mbps.T.F == "Y"] <- "TRUE"
b$Lines.Less.Than.2Mbps.T.F <- as.logical(b$Lines.Less.Than.2Mbps.T.F)
b$Superfast.Broadband.Available.T.F[b$Superfast.Broadband.Available.T.F == "N"] <- "FALSE"
b$Superfast.Broadband.Available.T.F[b$Superfast.Broadband.Available.T.F == "Y"] <- "TRUE"
b$Superfast.Broadband.Available.T.F <- as.logical(b$Superfast.Broadband.Available.T.F)

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
if (!file.exists("./data")) {
    dir.create("./data") 
}
for (prefix in unique(substr(b$Postcode.No.Spaces, 1, 4))) {
    sub <- b[grep(paste0("^", prefix, sep = ""), b$Postcode.No.Spaces), ]
    if (nrow(sub) > 0) {
        write.csv(sub, file = paste0("./data/", prefix, ".csv", sep=""), row.names = FALSE)
    }
}

# create a .json file referencing the files, to be used on the website
filesList <- data.frame(postcode = unique(substr(b$Postcode.No.Spaces, 1, 4)))
filesList$url <- paste0("./data/", filesList$postcode, ".csv", sep="")
writeLines(toJSONArray(filesList), "./data/filesList.json")
