## Task 2 - Cleaning, Transforming, and Parsing/Partitioning
---
**1. Import Panel8589.txt into R using the read.table() function.**

Open R Studio and set the working directory to the folder containing the 'Panel_8595.Txt', in order to be able to extract the data from the file.

```
filepath<-"C:/Users/Stefan Franz Jonsson/Desktop/Big Data & Business/Data-Cleaning-Project-Group-4/Data Cleaning Project/Task 2"

setwd(filepath)
```

I created a separate file to the original Panel_8595 document, For this file, I deleted the first 2 rows, and named it "Panel_8595 - Copy". The new "Panel_8595 - Copy" can be read by the read.table function

```
filename<-"Panel_8595 - Copy.txt"  

Pasurka<-read.table(filename, header=FALSE)
```
Pasurka is now a data frame and is ready to be cleaned

---
**2. Figure out what is being measured in each column (and in what units) Remove any superfluous variables not to be used in the analysis.**

To be able to find what columns represented what measurement I had to Use the table given in the paper named "Decomposing electric power plant emissions within a joint production framework" by Carl A. Pasurka Jr.

The Table is illustrated below, and it summarises statistics for 92 coal-fired power plants in 1987 and 1995.

|  | Units | Mean | S.D. | Maximum | Minimum |
|---|-------|------|----|---------|---------|
|1987||||| 
|Electricity| kWh (millions)|4314.2|3526.2|14,598.6|45.4| 
|SO2 |Short tons|55,287.4 |70,301.0 |367,330.4 |704.2 |
|NOx |Short tons |18,241.7 |15,727.6 |68,829.2 |243.9 |
|Capital stock |Dollars (in millions, 1973$) |216.4 |127.6 |568.2 |38.1|
|Employees |Workers |219.0 |138.5 |687.0 |37.0| 
|Heat content of coal| Btu (in billions) |43,887.9 |35,456.2 |160,037.4 |683.8 |
|Heat content of oil |Btu (in billions) |101.5 |107.9 |432.4 |0.0 |
|Heat content of gas |Btu (in billions) |51.5 |189.6 |1267.7 |0.0 |
|1995|||||| 
|Electricity |kWh (in millions) |4686.5 |4065.3 |18,212.1 |166.6 |
|SO2 |Short tons |40,745.2 |48,244.8 |252,344.6 |1,293.2 |
|NOx |Short tons |17,494.0 |16,190.1 |72,524.1 |423.1 |
|Capital stock |Dollars (in millions, 1973$) |240.0 |146.4 |750.0 |39.3|
|Employees |Workers |185.2 |110.9 |535.0 |39.0 |
|Heat content of coal |Btu (in billions) |46,936.3 |39,852.6 |173,436.8 |1,869.3 |
|Heat content of oil |Btu (in billions) |91.5 |112.7 |618.9 |0.0 |
|Heat content of gas |Btu (in billions) |76.5 |275.5 |2083.0 |0.0|

In order to find the Mean, Max, and Min for my data, I first had to use the filter function in order to only show the values from 1987, because those values are shown in the graph. After I had done this I used the summary function to match up the column names to there corresponding values. It could be deduced that the column header V3 was the year, due to the sequential nature of the column information. 

```
library(dplyr) 

Pasurka87<-filter(Pasurka, V3 == 87) 

summary(Pasurka87)
```
The summary function produces this table: 

| |V1|V2|V3|V4|V5|V6|V7|V8|V9|V10|V11|V12|V13|
|-|--|--|--|--|--|--|--|--|--|---|---|---|---|
|Min.|3|.:92|87|4.540e+07|704.2|243.9|38107910|37.0|:6.838e+11|   Min.   :0.000e+00|0.000e+00|470.1|0.000|
|1st Qu.|1011||87|1.432e+09|13012.8|6663.8|111605992|112.8|1.479e+13 |2.053e+10|0.000e+00|7267.1|1.596|  
|Median|2720||87|3.373e+09|28580.9|13923.4|189954364|181.0:|3.428e+13   |5.563e+10|0.000e+00|17727.8|4.093|   
|Mean|2928||87|4.314e+09|55287.4|18241.7|216400666|219.0|4.389e+13   |1.015e+11|5.147e+10|33511.4|7.701| 
|3rd Qu.|3945||87|6.846e+09|64964.4|26635.4|305050196|281.8|6.901e+13   |1.636e+11|0.000e+00|39038.2|8.947|  
|Max.|8226||87|1.460e+10|367330.4|68829.2|568167950|687.0|1.600e+14   |4.324e+11|1.268e+12|193312.3|55.518|
   
Now by matching the values, we can make the interpretation that
```
# V1 = Plant ID 
     - Power Plant identification number 

# V2 = ???
     - Empty Variable 

# V3 = Year (19--)
     - The year the data was measured and collected 

# V4 = Electricity (kWH) 
     - The net generation of electricity produced in kilowatt hours 

# V5 = SO2 (Short tons)
     - The emission of Sulpher dioxide in short tons

# V6 = NOx (Short tons)
     - The emission of Nitrogen oxide in short tons

# V7 = Capital Stock (Dollars in, 1973$)
     - The total amount of a firm's capital measured in 1973 dollars 

# V8 = Employees (Workers)
     - Average number of workers for each power plant 

# V9 = Heat content of coal (Btu)
     - The heat content of coal consumed at each power plant measured in British thermal units

# V10 = Heat content of oil (Btu)
     - The heat content of oil consumed at each power plant measured in British thermal units

# V11 = Heat content of gas (Btu)
     - The heat content of gas consumed at each power plant measured in British thermal units

# V12 = Irrelevant
# V13 = Irrelevant
```
The next step was remove any superfluous variables such as V2, V12, V13
```
Pasurka_C1<-subset(Pasurka,select = -c(V2,V12,V13))
```
Finally, the column names are changed to there corresponding variables
```
names(Pasurka_C1)<- c("Plant_ID",
                      "Year",
                      "Electricity_kWh",
                      "SO2_Short_tons",
                      "NOx_Short_tons",
                      "Capital_Stock_Dollars_in_1973",
                      "Employees_Workers",
                      "Heat_content_of_coal_Btu",
                      "Heat_content_of_oil_Btu",
                      "Heat_content_of_gas_Btu")
```

---
**3. Convert all energy measurements (energy produced and heat contents) into daily averages, measured in MWh. Convert all pollutants quantities, measured in annualized short tons, into daily averages. Convert all dollars (measured in 1973 $’s) into 2017 dollars.**

In order to create the new variables needed for the conversion, a mutate function had to be applied.

The conversion rates were the following:
- 1 year = 365 days
- 1 Kilowatt hour = 0.001 Megawatt-hour
- 1 Btu = 2.93071e-7 MWh
- $1 from 1973 = $5.62 as of March 2018


```
Pasurka_C2<-mutate(Pasurka_C1, 
                   Electricity_daily_MWh=((Electricity_kWh/1000)/365),
                   SO2_Short_tons_daily=SO2_Short_tons/365,
                   NOx_Short_tons_daily=NOx_Short_tons/365,
                   Heat_Content_of_coal_daily_MWh=(((Heat_content_of_coal_Btu)*2.93071e-7)/365),
                   Heat_Content_of_oil_daily_MWh=(((Heat_content_of_oil_Btu)*2.93071e-7)/365),
                   Heat_Content_of_gas_daily_MWh=(((Heat_content_of_gas_Btu)*2.93071e-7)/365),
                   Capital_Stock_Dollars_in_millions_2018=(Capital_Stock_Dollars_in_1973*5.62)/1000000
                   )
```

The next step is to create a new data frame with the old energy values deleted, and the old dollar value for capital stock deleted

```
Pasurka_C3<-subset(Pasurka_C2,select = -c(Electricity_kWh,
                                          Capital_Stock_Dollars_in_1973,
                                          SO2_Short_tons,
                                          NOx_Short_tons,
                                          Heat_content_of_coal_Btu,
                                          Heat_content_of_oil_Btu,
                                          Heat_content_of_gas_Btu))
```

---
**4. Add a factor variable indicating whether or not Phase I of the Clean Air Act had already been announced or not (the CAA Phase I restrictions were announced in 1990).**
For this task, I created a factor variable using an ifelse statement. The statement was based on the year variable.

```
Pasurka_C3$Phase_I_of_the_Clean_Air_Act <- ifelse(Pasurka_C3$Year==90,"Announced",
                                                  ifelse(Pasurka_C3$Year>90,"Already Announced", "Not Announced"))
``` 
Every year before 1990 the variable states that the CAA Phase I has not been announced. For the year 1990, the variable states that Phase I has been announced, and after every year after that is states that it has already been announced. 

Lastly, I created a new data frame where the column order matches the original table illustrated in the official research document created by Carl A. Pasurka Jr.

```
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

Pasurka_Final <- Pasurka_Final[c(1,2,4,5,6,10,3,7,8,9,11)]
``` 
This code cleaned up the column names making them spaced seperated. Now the column order is correct.  

---
**5.Save your cleaned data set using the write.table() function as tidy2.txt**
Using the write.table function the final cleaned dataset was saved as a text file called tidy2.txt

```
write.table(Pasurka_Final, file = "tidy2.txt")
```

---
**6. Create another dataset called tidy2_a.txt that averages all variables across all years for each plant for the 11 year period so that the tidy dataset has 92 rows of observations for all of the relevant variables.**

Using the "tidy2.txt" I created a new data frame named tidy2_a. Then by using the aggregate function, I was able to create an average across all years for each plant for the 11 year period. 
```
filename_a<-"tidy2.txt"

tidy2_a<-read.table(filename_a, header=TRUE)

Agg_tidy2_a<-aggregate(.~Plant.ID, tidy2_a, mean) 
View(Agg_tidy2_a)
```
From there I create a new data frame, where I delete the nonrelevant variables such as Year, Phase I of the Clean Air Act. 

```
tidy2_a_final<-subset(Agg_tidy2_a,select = -c(Year,
                                              Phase.I.of.the.Clean.Air.Act))
```

Finally I change the columns names so they are regularly spaced 
```
names(tidy2_a_final)<-c("Plant ID",
                        "Electricity (MWh, per day)",
                        "SO2 (Short tons, per day)",
                        "NOx (Short tons, per day)",
                        "Capital stock (Dollars (in millions, 2018$))",
                        "Employees (Workers)",
                        "Heat content of coal (MWh, per day)",
                        "Heat content of oil (MWh, per day",
                        "Heat content of gas (MWh, per day)")
```
Using the write.table function the final cleaned dataset was saved as a text file called tidy2_a.txt

```
write.table(tidy2_a_final, file = "tidy2_a.txt")
```

---
**7.Create another dataset called tidy2_b.txt that aggregated (adds) all variables within a  particular year across all 92 plants so that the tidy dataset has 11 rows of observations for all of the relevant variables.**

Using the "tidy2.txt" I created a new data frame named tidy2_b. Then by using the aggregate function, I was able to create a dataset that aggregates the value of all variables within a particular year across all 92 plants. 
```
filename_b<-"tidy2.txt"

tidy2_b<-read.table(filename_a, header=TRUE)

Agg_tidy2_b<-aggregate(.~Year, tidy2_a, sum)
```
From there I create a new data frame, where I delete the nonrelevant variables such as Plant ID.
```
tidy2_b_2<-subset(Agg_tidy2_b,select = -c(Plant.ID))
```
Then I had to change Phase.I.of.the.Clean.Air.Act so it becomes a statement and not a sum
```
tidy2_b_2$Phase.I.of.the.Clean.Air.Act <- ifelse(tidy2_b_2$Year==90,"Announced",
                                                  ifelse(tidy2_b_2$Year>90,"Already Announced", "Not Announced"))
```

Finally, I change the columns names so they are regularly spaced 
```
tidy2_b_final<-tidy2_b_2

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
```
Using the write.table function the final cleaned dataset was saved as a text file called tidy2_b.txt

```
write.table(tidy2_b_final, file = "tidy2_b.txt")
```

---
#### Author

* **Stefan Jonsson**
---
