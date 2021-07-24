#setwd("F:/1- final_project/4. DCDB/DCDB2_plaintxt/dcdb")
#usg <- read.table("DC_USAGE.txt", sep = "\t", header = TRUE)
#View(head(usg))

# ************** load dcdb and drugcomb drugs **************
dcdb <- read.table("F:/1- final_project/4. DCDB/components_identifier/components_identifier.txt", sep = "\t", header = TRUE)
dcdb$Name <- tolower(dcdb$Name)
#View(head(dcdb))

drugcomb <- read.csv("F:/1- final_project/1. drugCombDb-datasets/5.2.drug_chemical_info.csv", header = TRUE)
drugcomb$drugName <- tolower(drugcomb$drugName)
#View(head(drugcomb))


# search dcdb drugs in drugcomb
founded <- as.data.frame(matrix(nrow=900, ncol = 1))
others <- as.data.frame(matrix(nrow=900, ncol = 1))
r <- 1
o <- 1
for (drug in dcdb$Name){
    print(drug)
    if (drug %in% drugcomb$drugName){
        founded[r,] <- drug
        r <- r + 1
    }
    else if (drug %in% drugcomb$drugNameOfficial){
        founded[r,] <- drug
        r <- r + 1
    }
    else{
        others[o,] <- drug
        o <- o + 1
    }
}
others <- others[c(1:471),]
View(founded)
setwd("f:/1- final_project")
write.csv(dcdb$Name, "dcdb_names_complete.csv")


# ****** convert drugcomb cids to proper format. (CIDs001234 --> 1234)
dcdb_cids <- read.table("f:/1- final_project/4. dcdb/dcdb_cids_complete.txt", sep = "\t", fill = TRUE)

for (i in (1:3059)){
    #print(substring(cid, first=5))
    c <- substring(drugcomb$cIds[i], first=5)
    #print(c)
    #print(sub("^0+", "", c))
    drugcomb$cIds[i] <- sub("^0+", "", c)
}


for (i in (1:1103)){
    if(dcdb_cids[i,2] %in% drugcomb$cIds){
        print(dcdb_cids[i,1])
        founded[r,] <- dcdb_cids[i,1]
        r <- r + 1
    }
    else{
        #print(dcdb_cids[i,1])
        others[o,] <- dcdb_cids[i,1]
        o <- o + 1
    }
}

founded[c(1:420),1] <- unique(founded[,1])
write.csv(founded[c(1:420),], "dcdb_drugs_in_drugcombdb.csv")
notFounded <- dcdb$Name[!(dcdb$Name %in% founded$V1)]
write.csv(notFounded, "not_in_drugcombDb.csv")
others[,1] <- unique(others[,1])
