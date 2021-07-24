from selenium import webdriver
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException, TimeoutException
import csv


# add founded drug exCode(from drugCombDB) and drugName(from drugBank) to csv file from_scarping_drugs.csv 
def addToFile(drug_exCode, drug_name):
    try:
        with open("from_scraping_drugs.csv", "a") as csvfile:
            csvfile.write("%s, %s\n" % (drug_exCode, drug_name))
            
    except IOError:
        pass


opts = Options()
opts.set_headless()
assert opts.headless

# load drugs that we want to search in drugbank
csv_file = open("drugbank_all_full_database.xml_2/failed_to_find_drugs_after_splitting.csv")
drugs = csv.reader(csv_file, delimiter = ",")
list_of_drugs = list(drugs)
csv_file.close()


# count iterated drugs
round = 0
# send request to drugbank.com for each drug and save its name
for drug in list_of_drugs:
    round += 1
    print(round)
    drug_exCode = drug[1]
    driver = Chrome("e:\chromedriver",options=opts)
    driver.get("https://go.drugbank.com/unearth/q?utf8=✓&searcher=drugs&query=" + drug_exCode)
    try:
        # from drugbankSourcePage.html, we know the element name
        element = driver.find_element_by_name("dc.title")
        drug_name = element.get_attribute('content')
        print(round, ",", drug_exCode, ",", drug_name)
        addToFile(drug_exCode, drug_name) 
    except (NoSuchElementException, TimeoutException):
        pass
        
driver.quit()







