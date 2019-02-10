install.packages("robis")
install.packages("mregions")
install.packages("httr")
install.packages("jsonlite")
install.packages("sf")
install.packages("mapview")

library("httr")
library("jsonlite")
library("robis")
library("sf")
library("mapview")
library("mregions")

# Get a JSON response
GAZT_json <- GET("http://marineregions.org/rest/getGazetteerWMSes.json/21460/")
stop_for_status(GAZT_json)  # convert HTTP errors to R errors
names(GAZT_json)
GAZT_json$status_code
GAZT_json$headers$`content-type`

# Parse with httr
json_text_content <- content(GAZT_json, as = "text")
json_text_content
json_parsed_content <- content(GAZT_json, as = "parsed")
json_parsed_content
names(json_parsed_content)

# Get a 2nd JSON response
#GAZT2_json <- GET( "http://geo.vliz.be/geoserver/wfs?request=getfeature"&service=wfs, version=1.1.0, typename=MarineRegions:longhurst, outputformat=json, filter=<PropertyIsEqualTo><PropertyName>provcode</PropertyName><Literal>NECS</Literal></PropertyIsEqualTo>)
stop_for_status(GAZT2_json)  # convert HTTP errors to R errors
names(GAZT2_json)
GAZT2_json$status_code
GAZT2_json$headers$`content-type`

#Using SF and MAPVIEW package
baseurl <- "http://geo.vliz.be/geoserver/wfs?"
wfs_request <- "request=GetFeature&service=WFS&version=1.1.0&typeName=MarineRegions:longhurst&outputFormat=json&propertyName=provcode&literal=NECS"
fi_regions_wfs <- paste0(baseurl,wfs_request)
fi_regions <- st_read(fi_regions_wfs)
head(fi_regions)
mapview(fi_regions, label = fi_regions$provcode, color = "darkgreen", col.regions = "green", alpha.regions = .05)

# Convert parsed JSON file to data frame
json_fi_regions_df<- as.data.frame(fi_regions)
View(json_fi_regions_df)
head(json_fi_regions_df)
#https://www.rstudio.com/resources/videos/using-web-apis-from-r/

#change1
#Robis package
library("robis", lib.loc="~/R/win-library/3.5")
data <- occurrence("Abra alba") #Get occurrences by scientific name
data <- occurrence(aphiaid = 141433) #Get occurrences by AphiaID
View(data)
data <- occurrence("Abra alba", fields = c("decimalLongitude", "decimalLatitude")) #Restrict fields in result set
data <- occurrence("Abra nitida", qc = c(22, 23))#Filter occurrences by QC flags
data <- occurrence("Abra alba", geometry = "POLYGON ((2.59689 51.16772, 2.62436 51.14059, 2.76066 51.19225, 2.73216 51.20946, 2.59689 51.16772))")#Get occurrences by geometry
leafletmap(data)#Plot occurrences on a Leaflet map
data <- checklist("Semelidae", year = 2005)
data2 <- checklist(geometry = "POLYGON ((2.59689 51.16772, 2.62436 51.14059, 2.76066 51.19225, 2.73216 51.20946, 2.59689 51.16772))")
datasets <- dataset(seq(2500, 2520))