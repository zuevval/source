#ANOVA
library(tidyverse)
read_tbl <- function (fname) here::here("r/stats2021fall/2022_02_22_biostats_start/data", fname) %>% read.table(header=T, as.is=T)
# blood pressure
dat<-read_tbl("Klienbaum_EX0502.DAT")
min(dat$AGE)
breaks<-c(40,45,50,55,60,65)
dat$AGE.CAT_SYMBOLIC<-NA
dat$AGE.CAT_NUMERIC<-NA
nm<-c("<=45","46-50","51-55","56-60",">61")
for (i in seq_along(nm)){
	ftr<-dat$AGE>breaks[i] & dat$AGE<=breaks[i+1]
	dat$AGE.CAT_SYMBOLIC[ftr]<-nm[i]
	dat$AGE.CAT_NUMERIC[ftr]<-i
}
# 
r0<-lm(SBP~AGE,data=dat) # линейная регрессия # SBP = Systolic Blood Pressure
plot(dat$AGE,dat$SBP,xlab="AGE",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure")
x<-c(min(dat$AGE),max(dat$AGE))
y<-r0$coefficients[1]+r0$coefficients[2]*x
points(x,y,"l",col="red",lwd=2)
# ONE WAY ANOVA
r1<-lm(SBP~AGE.CAT_NUMERIC,data=dat)
r1.coeff<-r1$coefficients
r2<-lm(SBP~as.factor(AGE.CAT_NUMERIC),data=dat)
plot(dat$AGE.CAT_NUMERIC,dat$SBP,xlab="AGE",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure")
x<-1:5
y<-r1$coefficients[1]+r1$coefficients[2]*x 
points(x,y,"l",col="red",lwd=2) # linear regression plot
# 
y1<-(r2$coefficients[1]+c(0,r2$coefficients[2:5]))
points(x,y1,"l",col="green",lwd=2) # ANOVA
points(x,y1,col="purple",cex=3,pch=15) # ANOVA
#
r1s<-summary(r1) # помним, что гипотезы об отдельных параметрах не несут информации об отдельных событиях
r2s<-summary(r2)
r2ss<-summary(r2,correlation = TRUE)
r2a<-anova(r2)
r2c<-confint(r2)
# monotonicity (multiple comparison)
# метод Шеффе. Идея: показать, что все главные эффекты имеют один знак
C<-matrix(c(0,1,0,0,0,0,-1,1,0,0,0,0,-1,1,0,0,0,0,-1,1),nrow=5,ncol=4) # intercept: неинтересно, остальные 4 параметра сравниваются
vr<-t(C)%*%r2ss$cov.unscaled %*%C # матрица ковариации
psi<-as.numeric(t(C)%*%as.matrix(as.numeric(r2$coefficients)))
v.psi<-diag(vr)
xal<-sqrt(qf(0.95,4,r2a$Df[2]))
CCINT<-data.frame(LW=psi-xal*sqrt(v.psi),UP=psi+xal*sqrt(v.psi)) # не удаётся выявить методом Шеффе статистически значимое монотонное повышение среднего значения систолического давления

# Двухфакторный анализ!
r2.a<-lm(SBP~as.factor(AGE.CAT_NUMERIC)+as.factor(SMK),data=dat) # additive
r2<-lm(SBP~as.factor(AGE.CAT_NUMERIC)*as.factor(SMK),data=dat) # multiplicative
r2s<-summary(r2)
r2.as<-summary(r2.a)
r2a<-anova(r2)
plot(dat$AGE.CAT_NUMERIC[dat$SMK==0],dat$SBP[dat$SMK==0],xlab="AGE",ylab="Blood pressure",col="blue",main="Systolic Blood Pressure",ylim=c(min(dat$SBP),max(dat$SBP)))
points(dat$AGE.CAT_NUMERIC[dat$SMK==1],dat$SBP[dat$SMK==1],col="green",pch=2)
# SMK=0
dat0<-dat[dat$SMK==0,]
r2.0<-lm(dat0$SBP~as.factor(dat0$AGE.CAT_NUMERIC))
r2.0s<-summary(r2.0)
x<-c(1:5)
y<-r2.0$coefficients[1]+c(0,r2.0$coefficients[2:5])
points(x,y,"l",col="purple",pch=2)
# SMK=1
dat1<-dat[dat$SMK==1,]
r2.1<-lm(dat1$SBP~as.factor(dat1$AGE.CAT_NUMERIC))
r2.1s<-summary(r2.0)
x<-c(1:5)
y<-r2.1$coefficients[1]+c(0,r2.1$coefficients[2:5])
points(x,y,"l",col="orange",pch=2)
# ANOVA
r2a<-anova(r2) # по сути - последовательная проверка гипотез (отсутствие взаимодействий - модель общая с моделью аддитивной)
r2smk<-lm(SBP~as.factor(SMK),data=dat) # AGE=0
r2age<-lm(SBP~as.factor(AGE.CAT_NUMERIC),data=dat) # SMK=0
r2no<-lm(SBP~1,data=dat) # No effects
int.a<-anova(r2.a,r2)
smk.a<-anova(r2smk,r2)
age.a<-anova(r2age,r2)
no.a<-anova(r2no,r2)
# Results
t.aov<-rbind(int.a[2,],smk.a[2,],age.a[2,],no.a[2,])
SSE<-t.aov$RSS
DfR<-t.aov$Res.Df
SSH<-t.aov$"Sum of Sq"
Df<-t.aov$Df
SSE.m<-SSE/DfR
SSH.m<-SSH/Df
Fst<-SSH.m/SSE.m
pv<-pf(Fst,Df,DfR,lower.tail=FALSE)
xal<-qf(0.95,Df,DfR)
sse<-sum(r2$residual^2)
df<-r2$df.residual
sse.m<-sse/df
#
aic<-c(AIC(r2),AIC(r2.a),AIC(r2smk),AIC(r2age),AIC(r2no))
bic<-c(BIC(r2),BIC(r2.a),BIC(r2smk),BIC(r2age),BIC(r2no))
#
res.t<-data.frame(Hypothesis=c("Saturated","No interaction","No SMK effect","No AGE effect","No effects"),Model=c("SBP~AGE2*SMK","SBP~AGE2+SMK","SBP~AGE2","SBP~SMK","SBP~1"),AIC=aic,BIC=bic,SSE=c(sse,SSE),DF.res=c(df,DfR),SSE.m=c(sse.m,SSE.m),SSH=c(NA,SSH),DF=c(NA,Df),SSH.m=c(NA,SSH.m),x.alpha=c(NA,xal),PV=c(NA,pv))

confint(r2.a)

# исследование докторов по разным городам. Score -- средний балл, который ставили докторам в городе.
# # HWK ANOVA
# dat<-read.table("Klienbaum_EX1902.DAT",header=T,as.is=T)
# SCORE<-dat$SCORE
# CITY<-as.factor(dat$CITY)
# SPEC<-as.factor(dat$SPEC)
# a1<-lm(SCORE~SPEC+CITY,data=dat)
# # HWK
# dat<-read.table("EX1909.DAT",header=T,as.is=T)
# #

