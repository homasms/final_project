df <- read.csv("all_drugs.csv")

# ********** load drug names to extract their informations from drugbank ******
drugs <- scan("Drugs.txt", sep = "\n", what = "list")
drugs <- drugcomb$drugName
mycol <- c("drugbank-id", "name", "description", "cas-number", "unii", 
           "state", "groups", "general-references", "synthesis-reference",
           "indication", "pharmacodynamics", "mechanism-of-action", "toxicity", 
           "metabolism", "absorption", "half-life", "protein-binding",
           "route-of-elimination", "volume-of-distribution", "clearance",
           "classification", "salts", "synonyms", "products", "international-brands",
           "mixtures", "packagers", "manufacturers", "prices", "categories",
           "affected-organisms", "dosages", "atc-codes", "ahfs-codes", "pdb-entries",
           "fda-label", "msds", "patents", "food-interactions", "drug-interactions",
           "sequences", "experimental-properties", "external-identifiers", "external-links",
           "pathways", "reactions", "snp-effects", "snp-adverse-drug-reactions", "targets",
           "enzymes", "carriers", "transporters", "average-mass", "monoisotopic-mass", 
           "calculated-properties")
df <- all_drugs

df$name <- tolower(df$name)
df$synonyms <- tolower(df$synonyms)

# get drugs of first column
drugs <- tolower(drugs)

# ********** create data frame from drugCombDB drugs infos
# we check names and synonyms fields of drugbank database
# then, we split drug name and take first part and search again

# initial dataframe of all needed drugs
drugDf <- as.data.frame(matrix(ncol=length(mycol)+1, nrow = length(drugs)))
names(drugDf) <- c("drugName", mycol)
#rbind(drugDf, c("sjdf", mycol))
n <- 1
r <- 1
for(drug in drugs){
  #drug <- drug_ex_name_pair[rowNum,]
  if(n %% 20 == 0){
    print(n)
    print(drug)
  }
  try(
    {
      # check in name column
      tmp <- df[df$name == drug,]
      if(nrow(tmp) == 0)
        # check in synonym column
        tmp <- df[df$synonyms == drug,]
      if(nrow(tmp) == 0)
        # check in description column
        tmp <- df[df$description == drug,]
      if(nrow(tmp) == 0)
        # check in absorption column
        tmp <- df[df$absorption == drug,]
      if(nrow(tmp) == 0)
        # check in international brand column
        tmp <- df[df$international.brands == drug,]
      if(nrow(tmp) == 0)
        # check in general refrences column
        tmp <- df[df$general.references == drug,]
      if(nrow(tmp) == 0)
        # check in product column
        tmp <- df[df$products == drug,]
      if(nrow(tmp) == 0)
        # check in prices column
        tmp <- df[df$prices == drug,]
      
      if(nrow(tmp) == 0)
        tmp <- df[grepl(drug, df$name),]
      #if(drug == "warfarin")
       # print(tmp)
      if(nrow(tmp) == 0)
        # check in synonym column
        tmp <- df[grepl(drug, df$synonyms),]
      if(nrow(tmp) == 0)
        # check in description column
        tmp <- df[grepl(drug, df$description),]
      if(nrow(tmp) == 0)
        # check in absorption column
        tmp <- df[grepl(drug, df$absorption),]
      if(nrow(tmp) == 0)
        # check in international brand column
        tmp <- df[grepl(drug, df$international.brands),]
      if(nrow(tmp) == 0)
        # check in general refrences column
        tmp <- df[grepl(drug, df$general.references),]
      if(nrow(tmp) == 0)
        # check in product column
        tmp <- df[grepl(drug, df$products),]
      if(nrow(tmp) == 0)
        # check in prices column
        tmp <- df[grepl(drug, df$prices),]
      if(nrow(tmp) != 0){
        # save to dataframe
        new <- c(drug, tmp[2:56])
        names(new) <- c("drugName", mycol)
        #if(r == 1)
         # drugDf <- new
        drugDf[r,] <- new
        #drugCombDf[r,] <- c(drug, tmp[2:56])
        r <- r + 1
      }
      # not found in df
      if(nrow(tmp) == 0){
        # check just the first of drug name
        firstPartOfDrugName <-strsplit(drug, " ")[[1]][1]
        # check in name column
        tmp <- df[grepl(firstPartOfDrugName, df$name),]
        if(nrow(tmp) == 0)
          # check in sysnonym column
          tmp <- df[grepl(firstPartOfDrugName, df$synonyms),]
        if(nrow(tmp) != 0){
          # save to data frame
          new <- c(drug, tmp[2:56])
          names(new) <- c("drugName", mycol)
          #if(r == 1)
           # drugDf <- new
          drugDf[r,] <- new
          #drugCombDf[r,] <- c(drug, tmp[2:56])
          r <- r + 1
        }
      }
    }
  )
  n <- n + 1
}

drugDf <- drugDf[1:sum(!is.na(drugDf$drugName)),]

write.csv(drugDf$drugName, "drugcombdb_in_drugbank.csv")

remainDrugs <- drugs[!(drugs %in% drugDf$drugName)]
write.csv(remainDrugs, "drugcombdb_not_in_drugbank.csv")


# make dataset clean for opening with excel
for(i in 1:56)
  drugDf[,i] <- gsub("\n", "||", drugDf[,i])

for (i in 1:56){
  for (j in 1:nrow(drugDf)){
    if (is.na(drugDf[j, i]))
      next
    num <- nchar(drugDf[j, i])
    if (num > 30000)
      drugDf[j, i] <- substr(drugDf[j, i], start = 1, stop = 30000)
  }
}


# save final table in 4 files
eachPart <- floor(nrow(drugDf)/3)
write.csv(drugDf[1:eachPart,], "first_part.csv")
write.csv(drugDf[eachPart+1:2*eachPart,], "second_part.csv")
write.csv(drugDf[2*eachPart+1,nrow(drugDf)], "third_part.csv")


