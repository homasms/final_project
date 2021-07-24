setwd("F:\\1- final_project")
setwd("F:/1- final_project/atc-make")
all_drugs <- read.csv("2. drugbank_all_full_database.xml_2/2. all_drugs.csv")
output <- read.csv("output.csv")


for(i in 4:9){
    output[,i] <- gsub("\n", "||", output[,i])
    output[,i] <- gsub("\"", "", output[,i])
}


for (i in 1:9){
    for (j in 1:nrow(output)){
        if (is.na(output[j, i]))
            next
        num <- nchar(output[j, i])
        if (num > 30000)
            output[j, i] <- substr(output[j, i], start = 1, stop = 30000)
    }
}



write.csv(output, "columns.csv", row.names = FALSE)
result <- merge(output, all_drugs, by = "drugbank.id")

m <- result[,c(1, c(3:9), c(12:38), 40, 41, c(43:48), c(50:57), c(60:63))]
write.csv(m, "all_drugs_new.csv", row.names = FALSE)
write.csv(m[c(1:3500),], "first_part.csv")
write.csv(m[c(3501:7000),], "second_part.csv")
write.csv(m[c(7001:10500),], "third_part.csv")
write.csv(m[c(105001:13580),], "forth_part.csv")

x <- read.csv("1.csv")
y <- read.csv("2.csv")
names(x) <- c("1", "2", "3")
names(y) <- c("1", "2", "3")
x[,1] <- c("a", "b")
y[,1] <- c("a")
z <- merge(x, y, by = "1")
z <- cbind(x, y)
