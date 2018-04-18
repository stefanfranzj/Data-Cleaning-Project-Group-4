filepath<-"C:/Users/Stefan Franz Jonsson/Desktop/Big Data & Business/Data-Cleaning-Project-Group-4/Data Cleaning Project/Task 2" ###insert your own filepath here

setwd(filepath) ##Setting working diractery to extract file Panel_8595 

### Created a sepreate file to the orginal Panel_8595 document, For this file I deleted the first 2 rows, and named it Panel_8595
  ### The new "Panel_8595 - Copy" can be read by the read.table function

filename<-"Panel_8595 - Copy.txt" ###Give the original data a name 

Pasurka<-read.table(filename, header=FALSE) ### give data set the variable Pasurka to begin cleaning process

View(Pasurka)
summary(Pasurka) #trying to match the values to find the name of the columns

names(Pasurka) ###find the cloumn Names 

library(dplyr) ###use the dplyr package to filter 

Pasurka87<-filter(Pasurka, V3 == 87) ###filter for the year 1987

summary(Pasurka87) ### see if the values match the values on page 37 on the official paper

### From this we learn 
# V1 = Plant ID 
# V2 = ???
# V3 = Year (19--)
# V4 = Electricity (kWh)
# V5 = SO2 (Short tons)
# V6 = NOx (Short tons)
# V7 = Capital Stock (Dollars in, 1973$)
# V8 = Employees (Workers)
# V9 = Heat content of coal (Btu)
# V10 = Heat content of oil (Btu)
# V11 = Heat content of gas (Btu)
# V12 = Irrelevant
# V13 = Irrelevant


View(Pasurka87)

Pasurka95<-filter(Pasurka, V3 == 95) #double cheack to see if the columns match the data showing in the official paper

summary(Pasurka95)

### Now deleting columns that are not of interest 

Pasurka_C1<-subset(Pasurka,select = -c(V2,V12,V13)) ### Removed V2, V12 and V13 from the data set, New data set called Pasurka_C1

View(Pasurka_C1) ### To see if the columns have been deleted correctly 

### Now to change the names of the coulmns, into their proper names

names(Pasurka_C1) ### see how many columns we have, should have 10 

names(Pasurka_C1)<- c("Plant_ID",
                      "Year",
                      "Electricity_kWh",
                      "SO2_Short_tons",
                      "NOx_Short_tons",
                      "Capital_Stock_Dollars_in_1973",
                      "Employees_Workers",
                      "Heat_content_of_coal_Btu",
                      "Heat_content_of_oil_Btu",
                      "Heat_content_of_gas_Btu") #Changed the coloumn names

names(Pasurka_C1) 
View(Pasurka_C1) ### Check to see if the coulmn names are correct

### Now converting all energy measurements (energy produced and heat contents) into daily averages, measured in Mwh
### And aducting the 1973 dollars to inflation inorder to represent 2018 dollars 

Pasurka_C2<-mutate(Pasurka_C1, 
                   Electricity_daily_MWh=((Electricity_kWh/1000)/365),
                   SO2_Short_tons_daily=SO2_Short_tons/365,
                   NOx_Short_tons_daily=NOx_Short_tons/365,
                   Heat_Content_of_coal_daily_MWh=(((Heat_content_of_coal_Btu)*2.93071e-7)/365),
                   Heat_Content_of_oil_daily_MWh=(((Heat_content_of_oil_Btu)*2.93071e-7)/365),
                   Heat_Content_of_gas_daily_MWh=(((Heat_content_of_gas_Btu)*2.93071e-7)/365),
                   Capital_Stock_Dollars_in_millions_2018=(Capital_Stock_Dollars_in_1973*5.62)/1000000
                   )
summary(Pasurka_C2)
View(Pasurka_C2)

### Creating new data frame with old energy values deleted, and the old dollar value for capital stock deleted


Pasurka_C3<-subset(Pasurka_C2,select = -c(Electricity_kWh,
                                          Capital_Stock_Dollars_in_1973,
                                          SO2_Short_tons,
                                          NOx_Short_tons,
                                          Heat_content_of_coal_Btu,
                                          Heat_content_of_oil_Btu,
                                          Heat_content_of_gas_Btu))
                                         
### Adding a factor variable to the data frame indicating whether Phase I of the Clean Air Act had been announced.

Pasurka_C3$Phase_I_of_the_Clean_Air_Act <- ifelse(Pasurka_C3$Year==90,"Announced",
                                                  ifelse(Pasurka_C3$Year>90,"Already Announced", "Not Announced"))

View(Pasurka_C3)  ###To check if the cahnges were made succefully 

###Create on last data Frame with nice column headers

names(Pasurka_C3)

Pasurka_Final<-Pasurka_C3

names(Pasurka_Final)<-c("Plant ID",
                     "Year",
                     "Employees (Workers)",
                     "Electricity (MWh, per day)",
                     "SO2 (Short tons, per day)",
                     "NOx (Short tons, per day)",
                     "Heat content of coal (MWh, per day)",
                     "Heat content of oil (MWh, per day",
                     "Heat content of gas (MWh, per day)",
                     "Capital stock (Dollars (in millions, 2018$))",
                     "Phase I of the Clean Air Act")

names(Pasurka_Final)

Pasurka_Final <- Pasurka_Final[c(1,2,4,5,6,10,3,7,8,9,11)] ###Reorganize the columns to keep them in the same order as the document shows.

View(Pasurka_Final) ### Finale check to make sure eveything looks right

write.table(Pasurka_Final, file = "tidy2.txt")

################################### Creating tidy2_a that shows the averages across all years for each plant 

filename_a<-"tidy2.txt"

tidy2_a<-read.table(filename_a, header=TRUE)

View(tidy2_a)

names(tidy2_a)

Agg_tidy2_a<-aggregate(.~Plant.ID, tidy2_a, mean) ### Create an average across all years for each plant for the 11 year period

View(Agg_tidy2_a)

names(Agg_tidy2_a)

###Then delete the non relevant variables such as: Year, Phase.I.of.the.Clean.Air.Act

tidy2_a_final<-subset(Agg_tidy2_a,select = -c(Year,
                                              Phase.I.of.the.Clean.Air.Act))
names(tidy2_a_final)

###Finaly to change the column headers so they look nice

names(tidy2_a_final)<-c("Plant ID",
                        "Electricity (MWh, per day)",
                        "SO2 (Short tons, per day)",
                        "NOx (Short tons, per day)",
                        "Capital stock (Dollars (in millions, 2018$))",
                        "Employees (Workers)",
                        "Heat content of coal (MWh, per day)",
                        "Heat content of oil (MWh, per day",
                        "Heat content of gas (MWh, per day)")

View(tidy2_a_final) ###Check that all changes went through without error

write.table(tidy2_a_final, file = "tidy2_a.txt")

##################################### Creating tidy2_b that shows the aggregate value of all variables within a particular year accross all 92 plants

filename_b<-"tidy2.txt"

tidy2_b<-read.table(filename_a, header=TRUE)

View(tidy2_b)

names(tidy2_a)

Agg_tidy2_b<-aggregate(.~Year, tidy2_a, sum) ### Create an aggregate across all plants for each year

View(Agg_tidy2_b)

names(Agg_tidy2_b)

###Then delete the non relevant variable such as: Plant.ID, and changing Phase.I.of.the.Clean.Air.Act so it becomes a statement and not a sum

tidy2_b_2<-subset(Agg_tidy2_b,select = -c(Plant.ID))

tidy2_b_2$Phase.I.of.the.Clean.Air.Act <- ifelse(tidy2_b_2$Year==90,"Announced",
                                                  ifelse(tidy2_b_2$Year>90,"Already Announced", "Not Announced"))

View(tidy2_b_2) ###To check that all the right changes have been made

###Finaly to change the column headers so they look nice

tidy2_b_final<-tidy2_b_2

names(tidy2_b_final)

names(tidy2_b_final)<-c("Year",
                        "Electricity (MWh, per day)",
                        "SO2 (Short tons, per day)",
                        "NOx (Short tons, per day)",
                        "Capital stock (Dollars (in millions, 2018$))",
                        "Employees (Workers)",
                        "Heat content of coal (MWh, per day)",
                        "Heat content of oil (MWh, per day",
                        "Heat content of gas (MWh, per day)",
                        "Phase I of the Clean Air Act")

View(tidy2_b_final) ###Check that all changes went through without error

write.table(tidy2_b_final, file = "tidy2_b.txt")


###Author Stefan Jonsson