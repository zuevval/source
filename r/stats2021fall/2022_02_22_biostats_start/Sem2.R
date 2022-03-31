#Pagani, Chapter3
# тест Стьюдента
# попробуйте сами попробовать разные тесты, посмотреть, что получится

setwd("/Users/malovs/Desktop/Teach/GEO/Pagano2/ASCII/chap03")
# forced expiratory volume
dat<-read.table("fev1.txt",header=T,as.is=T)
x<-dat$fev1
# mean/var
m<-mean(x)
v<-var(x) # unbiased var
# in detals 
y<-data.frame(fev=x,res=x-m,res2=(x-m)^2)
y
v1<-mean(y$res2) # sample var
# plot
hist(dat$fev1)
boxplot(dat$fev1)
# stratified
lv<-levels(as.factor(dat$gender))
m<-mean(dat$fev1[dat$gender==lv[1]])
m<-c(m,mean(dat$fev1[dat$gender==lv[2]]))
v<-var(dat$fev1[dat$gender==lv[1]])
v<-c(v,var(dat$fev1[dat$gender==lv[2]]))  
#
x<-data.frame(gender=lv,mean=m,var=v,MSE=sqrt(v))
# 
boxplot(dat$fev1~dat$gender)
#
dat1<-read.table("heart rates.txt",header=T,as.is=T)
m
v
v1
boxplot()
#
dat2<-read.table("infant mortality rates.txt",header=T,as.is=T)
x<-dat2$rate


