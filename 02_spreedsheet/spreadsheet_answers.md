# Spreadsheet Answers



## Cleaning Steps



* Reviewed raw dataset for inconsistencies and formatting issues
* Corrected invalid column headers and ensured proper naming conventions
* Removed extra spaces and standardized text formatting using TRIM and PROPER functions
* Handled missing values in important fields such as region and merchant data
* Ensured all date values were in a consistent format
* Verified data types for numerical columns like amount and risk\_score



## Standardization Rules



* Merchant names converted to proper case for consistency
* Status values standardized into:

  * CAPTURED
  * FAILED
  * CHARGEBACK
* Risk score values extracted and converted into numeric format
* Gateway regions standardized into:

  * APAC
  * EU
  * US
* All currency values converted into USD using exchange rates



## Lookup and Enrichment Logic



* Used `merchant\_master.csv` to:

  * Map merchant IDs to merchant names
  * Fill missing region values using default region
* Used `exchange\_rates.csv` to:

  * Convert transaction amounts into USD (amount\_usd)
* Applied lookup functions such as VLOOKUP/XLOOKUP to merge additional data



## Final Answers



* Total raw rows: 5
* Total cleaned rows: 5
* Invalid or missing rows handled: 1
* Top region by GMV: APAC
* Number of high value transactions: 0
* Number of high risk transactions: 1
* Top merchant by captured GMV: Beta Stores



## Formula Samples



**Merchant Name Cleaning**
=PROPER(TRIM(A2))



**Status Standardization**
=IF(ISNUMBER(SEARCH("chargeback",A2)),"CHARGEBACK",
IF(ISNUMBER(SEARCH("captured",A2)),"CAPTURED","FAILED"))



**Risk Score Extraction**
=VALUE(REGEXEXTRACT(A2,"\\d+"))



**Currency Conversion**
=amount \* VLOOKUP(currency, exchange\_rates, 2, FALSE)



**High Value Flag**
=IF(AND(region="APAC",amount\_usd>5000),1,
IF(AND(region="EU",amount\_usd>6000),1,
IF(AND(region="US",amount\_usd>7000),1,0)))



**High Risk Flag**
=IF(OR(risk\_score>=70,status="CHARGEBACK"),1,0)

