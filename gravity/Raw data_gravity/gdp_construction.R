library("readxl")
setwd("D:/BIAN CE/BRI_paper/gravity/Raw data_gravity")
rm(list=ls())
dataset<-read_excel("gravity_raw_for_r.xlsx")
country<-as.data.frame(dataset[1])
iso3<-as.data.frame(dataset[2])
gdp<-as.data.frame(dataset[3])
year<-as.data.frame(rep(2010,264))

colnames(country)<-c("country")
colnames(iso3)<-c("iso3")
colnames(gdp)<-c("gdp")
colnames(year)<-c("year")

for(i in 1:8){
  temp1<-as.data.frame(dataset[1])
  temp2<-as.data.frame(dataset[2])
  temp3<-as.data.frame(dataset[i+3])
  temp4<-as.data.frame(rep(2010+i,264))
  colnames(temp1)<-c("country")
  colnames(temp2)<-c("iso3")
  colnames(temp3)<-c("gdp")
  colnames(temp4)<-c("year")
  
  country<-rbind(country,temp1)
  iso3<-rbind(iso3, temp2)
  gdp<-rbind(gdp,temp3)
  year<-rbind(year,temp4)
}

total<-cbind(year,country,iso3,gdp)
write.csv(total,"D:/BIAN CE/BRI_paper/gravity/Raw data_gravity/gdp.csv")