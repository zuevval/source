# 2022 Mar 29th
#Regression

library(tidyverse)
read_tbl <- function (filename) here::here("r/stats2021fall/2022_02_22_biostats_start/data", filename) %>% read.table(header=T, as.is=T) # TODO maybe load `utils`? (still requires a path component?)
# blood pressure
dat<-read_tbl("Klienbaum_EX0502.DAT")
plot(dat$QUET,dat$SBP,xlab="Body index",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure")
    # by smoke
f1<-dat$SMK==1
plot(dat$QUET[f1],dat$SBP[f1],xlab="Body index",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure",xlim=c(min(dat$QUET),max(dat$QUET)), ylim=c(min(dat$SBP),max(dat$SBP)))
f2<-dat$SMK==0
points(dat$QUET[f2],dat$SBP[f2],col="red",pch=2)
legend("bottomright",legend=c("Smoker","Non smoker"),col=c("blue","red"),pch=c(1,2))
   # by age
min(dat$AGE)
breaks<-c(40,45,50,55,60,65)
ftr<-list()
for (i in 1:(length(breaks)-1)){
	ftr[[i]]<-dat$AGE>breaks[i] & dat$AGE<=breaks[i+1]	
}
nm<-c("<=45","46-50","51-55","56-60",">61")
clr<-c(1:5)
sym<-c(0:4)
#
plot(NULL,NULL,"n",xlab="Body index",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure",xlim=c(min(dat$QUET),max(dat$QUET)), ylim=c(min(dat$SBP),max(dat$SBP)))
for (i in 1:5){
	points(dat$QUET[ftr[[i]]],dat$SBP[ftr[[i]]],col=clr[i],pch=sym[i])
}
legend("bottomright",legend=nm,col=clr,pch=sym)
# Index vs AGE
plot(dat$QUET,dat$AGE,xlab="Body index",ylab="AGE",col="blue",main="Systolic Blood Pressure Project")
# BP vs. AGE
plot(dat$AGE,dat$SBP,xlab="AGE",ylab="Blood pressure",col="red",main="Systolic Blood Pressure Project")
# Regression simple model
r1<-lsfit(dat$QUET,dat$SBP)
r1$coeff                  # coefficients
r1$residuals            # residuals
SSE<-sum(r1$residuals^2)
#
r2<-lm(dat$SBP~dat$QUET)
r2.coeff<-r2$coefficients
x<-c(min(dat$QUET),max(dat$QUET))
y<-r2$coefficients[1]+r2$coefficients[2]*x
plot(dat$QUET,dat$SBP,xlab="Body index",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure")
points(x,y,"l",col="red",lwd=2)
#
r2$residuals
r2$fitted.values
ff<-order(dat$QUET)
x1<-dat$QUET[ff]
y1<-r2$fitted.values[ff]
#
r2s<-summary(r2)
r2a<-anova(r2)
r2c<-confint(r2)
# plot
#x<-c(min(dat$QUET),max(dat$QUET))
#y<-r2$coefficients[1]+r2$coefficients[2]*x
#y1<-r2c[1,1]+r2c[2,1]*x
#y2<-r2c[1,2]+r2c[2,2]*x
#plot(dat$QUET,dat$SBP,xlab="Body index",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure")
#points(x,y,"l",col="red",lwd=2)
#points(x,y1,"l",col="blue",lwd=2)
#points(x,y2,"l",col="green",lwd=2)
#
r2ss<-as.data.frame(r2s$coefficients)
CIbeta<-c(r2ss$Estimate[2]-qt(0.975,r2a$Df[2])*r2ss[2,2],r2ss$Estimate[2]+qt(0.975,r2a$Df[2])*r2ss[2,2])
###################### Polynomial ####################
dat$QUET2<-dat$QUET^2
r02<-lm(SBP~QUET+QUET2,data=dat)
r2<-lm(SBP~QUET,data=dat)
r0<-lm(SBP~1,data=dat)
r02e<-r02$coefficients
r02s<-summary(r02)
r02a<-anova(r02)
r02c<-confint(r02)
anova(r2,r02)
anova(r0,r02)
x1<-min(x)+c(0:1000)/1000*(max(x)-min(x))
y1<-r02e[1]+r02e[2]*x1+r02e[3]*x1^2
# residuals 
er<-r02$residuals
h<-hist(er)
brk<-c(-20,-5,0,10,15)
# brk1<-c(-Inf,-5,0,10,Inf)
nu<-hist(er,breaks=brk)$counts # 
n<-length(er)
fnorm<-function(s){
	a<-c(-Inf,brk[2:4])
	b<-c(brk[2:4],Inf)
	return(pnorm(b,0,s)-pnorm(a,0,s))	
}
#
f<-function(s){
	f1<-fnorm(s)
	sum((nu-n*f1)^2/n/f1)
}
#
csq<-nlm(f,p=sqrt(var(er)))$minimum
pv.csq<-pchisq(csq,4-2,lower.tail=FALSE)
#
plot(dat$QUET,dat$SBP,xlab="Body index",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure")
x<-c(min(dat$QUET),max(dat$QUET))
y<-r2$coefficients[1]+r2$coefficients[2]*x 
x1<-min(dat$QUET)+c(0:1000)/1000*(max(dat$QUET)-min(dat$QUET))
y1<-r02e[1]+r02e[2]*x1+r02e[3]*x1^2
points(x,y,"l",col="red",lwd=2)
points(x1,y1,"l",col="blue",lwd=2)
#
#r021<-lm(SBP~QUET,data=dat)
AIC(r0)
AIC(r2)
AIC(r02)
#
BIC(r0)
BIC(r2)
BIC(r02)
############### SBP-AGE
r22<-lm(SBP~AGE,data=dat)
r22.coeff<-r2$coefficients
x<-c(min(dat$AGE),max(dat$AGE))
y<-r22$coefficients[1]+r22$coefficients[2]*x 
plot(dat$AGE,dat$SBP,xlab="AGE",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure")
points(x,y,"l",col="red",lwd=2)
#
r22s<-summary(r22)
r22a<-anova(r22)
r22c<-confint(r22)
# Regression complex model SBP ~ AGE*QUET
r3<-lm(SBP~AGE*QUET,data=dat)
r3s<-summary(r3)
r3a<-anova(r3)
r3c<-confint(r3)
r311<-lm(SBP~AGE+QUET,data=dat)
r310<-lm(SBP~AGE,data=dat)
r301<-lm(SBP~QUET,data=dat)
r300<-lm(SBP~1,data=dat)
r333 <- lm(SBP~I(AGE^2)+AGE*QUET+I(QUET^2), data=dat)
#
AIC(r311)
AIC(r333)

BIC(r311)
BIC(r333)

# here outlier removal might have been useful
# более сложные доверительные интервалы, кроме как для параметров, строить неинтересно, да и сами
# доверительные интеравлы для параметров не очень интересны

#
anova(r311,r3) # no multicative term
anova(r310,r3) # AGE only
anova(r301,r3) # QUET only
anova(r300,r3) # independence 
# 
r4<-lm(dat$SBP~dat$AGE+as.factor(dat$SMK)+dat$QUET)
r4s<-summary(r4)
r4a<-anova(r4)
r4c<-confint(r4)
r4i<-AIC(r4)   # Akaike information criteria
r4b<-BIC(r4)   # Baysean informaton criteria
# H_QUET
r4.1<-lm(dat$SBP~dat$AGE+as.factor(dat$SMK))
r4.2 <- lm(dat$SBP~dat$QUET+as.factor(dat$SMK))
r4.3 <- lm(dat$SBP~dat$AGE*as.factor(dat$SMK)*dat$QUET)

AIC(r4.1)
AIC(r4b)

# TODO дома рассмотреть квадратичную зависимость с фактором курения
# скорее всего, это ничего не даст, но те два outlier'а по индексу массы тела, скорее всего, мешают линейной аппроксимации
# и, возможно, квадратичная аппроксимация даже лучше линейной
# попробуйте также убрать outlier'ы и посмотреть, насколько результаты улучшатся или ухудшатся

r4.1a<-anova(r4.1)
SSE<-sum((r4$residuals^2))
dfH<-r4.1a$Df[3]-r4a$Df[4]
SSH<-sum(r4.1$residuals^2)-SSE
df<-r4a$Df[4]
FST<-df*SSH/dfH/SSE
Pval<-pf(FST,dfH,df,lower.tail=F)
#
# r4b<-lm(dat$SBP~dat$AGE+as.factor(dat$SMK)+dat$QUET)
r4b <- lm(dat$SBP~dat$AGE*as.factor(dat$SMK))
r4ba<-anova(r4b)
#
r5<-lm(dat$SBP~dat$QUET*as.factor(dat$SMK)+dat$AGE*as.factor(dat$SMK))
r5s<-summary(r5)
r5a<-anova(r5)
r5c<-confint(r5)
# 
r5.1<-lm(dat$SBP~dat$QUET+dat$AGE+as.factor(dat$SMK))
r55.1a<-anova(r5.1,r5)
#
r6<-lm(dat$SBP~dat$QUET*dat$AGE*as.factor(dat$SMK))
r6s<-summary(r6)
r6a<-anova(r6)
r6c<-confint(r6)
AIC(r6)-AIC(r5.1)
#
r7<-lm(dat$SBP~dat$QUET*dat$AGE+as.factor(dat$SMK))
AIC(r7)-AIC(r5.1)




