data1 <- read.csv("../raw/ofcom-uk-fixed-broadband-postcode-level-data-2013/ofcom-part1-fixed-broadband-postcode-level-data-2013.csv", na.strings = "N/A")
data2 <- read.csv("../raw/ofcom-uk-fixed-broadband-postcode-level-data-2013/ofcom-part1-fixed-broadband-postcode-level-data-2013.csv", na.strings = "N/A")
data <- rbind(data1, data2)
rm(data1, data2)
for (letter1 in letters) {
    for (letter2 in letters) {
        for (digit1 in 0:9) {
            prefix <- toupper(paste0(letter1, letter2, digit1, sep=""))
            sub <- data[grep(paste0("^", prefix, sep = ""), data$Postcode.No.Spaces.), ]
            if (nrow(sub) > 0) {
                write.csv(sub, file = paste0(prefix, ".csv", sep=""), row.names = FALSE)
            }
        }
    }
}