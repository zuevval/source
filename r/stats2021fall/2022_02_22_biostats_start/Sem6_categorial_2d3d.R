#CATEGORICAL DATA ANALYSIS
library(tidyverse)
read_tbl <- function (fname) here::here("r/stats2021fall/2022_02_22_biostats_start/data", fname) %>% read.table(header=T, as.is=T)
# More then 2x2 
f.tbl<-function(d){
  a<-levels(as.factor(d[,1]))
  b<-levels(as.factor(d[,2]))
  la<-length(a)
  lb<-length(b)
  out<-matrix(nrow=la,ncol=lb)
  for (i in 1:la)
  for (j in 1:lb){
    ftr<-d[,1]==a[i] &  d[,2]==b[j]
    out[i,j]<-sum(d[,3][ftr])
  }
  colnames(out)<-b
  rownames(out)<-a
  out
}
# for 2 way data
d.glm<-function(dat){
  a<-levels(as.factor(dat[,1]))
  b<-levels(as.factor(dat[,2]))
  la<-length(a)
  lb<-length(b)
  out<-data.frame(id=c(1:sum(dat$Count)))
  Resp<-NULL
  Exp<-NULL
  for (i in 1:la)
  for (j in 1:lb){
      ftr<-dat[,1]==a[i] &  dat[,2]==b[j]
      Exp<-c(Exp,array(a[i],dim=sum(dat$Count[ftr])))
      Resp<-c(Resp,array(b[j],dim=sum(dat$Count[ftr])))
  }
  out$Exp<-as.numeric(Exp)
  out$Resp<-as.numeric(Resp)
  return(out)
}
# use: glm.d<-d.glm(dat)
# for 3 way data
d.glm3<-function(dat){
  a<-levels(as.factor(dat[,1]))
  b<-levels(as.factor(dat[,2]))
  c<-levels(as.factor(dat[,3]))
  la<-length(a)
  lb<-length(b)
  lc<-length(c)
  out<-data.frame(id=c(1:sum(dat[,4])))
  v1<-NULL
  v2<-NULL
  v3<-NULL
  for (i in 1:la)
  for (j in 1:lb)
  for(k in 1:lc){
      ftr<-dat[,1]==a[i] &  dat[,2]==b[j] & dat[,3]==c[k]
      d.count<-dat[,4]
      v1<-c(v1,array(a[i],dim=sum(d.count[ftr])))
      v2<-c(v2,array(b[j],dim=sum(d.count[ftr])))
      v3<-c(v3,array(c[k],dim=sum(d.count[ftr])))
  }
  out$v1<-v1
  out$v2<-v2
  out$v3<-v3
  return(out)
}

# 3 way contingency tables
# Table 3.3, page 60
dat<-read_tbl("Chinese_lung_cuncer.csv")
datt<-d.glm3(dat)
names(datt)<-c("id","city","smoking","cancer")
city<-datt$city
smoking<-datt$smoking
cancer<-datt$cancer
q<-mantelhaen.test(cancer,smoking,city)
q$estimate
# OR - отношения шансов
city.u<-unique(city)
or<-array(dim=length(city.u))
for (i in 1:length(city.u)){
	#dat.c<-dat[dat[,1]==city.u[i],]
	dat.c<-datt[datt$city==city.u[i],]
	#tab<-f.tbl(dat.c[,c(2:4)])
	tab<-table(dat.c$cancer,dat.c$smoking)
	or[i]<-tab[1,1]*tab[2,2]/tab[1,2]/tab[2,1]
}
#
tab3<-array(dim=c(2,2,length(city.u)))
for (i in 1:length(city.u)){
	dat.c<-dat[dat[,1]==city.u[i],]
	tab<-f.tbl(dat.c[,c(2:4)])
	tab3[,,i]<-tab
}
library("DescTools")
# mantelhaen.test()
BreslowDayTest(tab3) # классический критерий нахождения отношения шансов

# GLM
dat$smoking.f<-as.factor(dat$smoking)
dat$cancer.f<-as.factor(dat$cancer)
dat$city.f<-as.factor(dat$city)
g.res<-glm(count~smoking.f*cancer.f*city.f,data=dat,family="poisson")
g.res.inter<-glm(count~cancer.f*smoking.f+smoking.f*city.f+cancer.f*city.f,data=dat,family="poisson") # модель однородности отношения шансов
# Theta_{SC|City} - все отношения
g.res.nul<-glm(count~smoking.f*city.f+cancer.f*city.f,data=dat,family="poisson") # модель условной независимости: ?? при условии фиксированного города зависимость фиксированная (всегда одна и та же)
g.res.ind<-glm(count~smoking.f+cancer.f+city.f,data=dat,family="poisson") # гипотеза полной независимости!
# LR-test
lrs<-g.res.nul$deviance-g.res$deviance
df<-g.res.nul$df.residual-g.res$df.residual
pval<-pchisq(lrs,df,lower.tail=FALSE)
lrs<-g.res.inter$deviance-g.res$deviance
df<-g.res.inter$df.residual-g.res$df.residual
pval1<-pchisq(lrs,df,lower.tail=FALSE)

# то же самое можно получить с помощью ANOVA
aci <- anova(g.res.nul, g.res.inter, test="LRT")
aci2 <- anova(g.res.ind, g.res, test="LRT")

datt$city.f <- as.factor(datt$city)
datt$smoking.f <- as.factor(datt$smoking)
datt$cancer <- as.numeric(datt$cancer)
g.res.lr <- glm(cancer~smoking.f*city.f, data=datt, family = "binomial")
# следующая по иерархии -- аддитивная модель
g.add.lr <- glm(cancer~smoking.f+city.f, data=datt, family = "binomial") # TODO подумать: чему соответствует такая модель, если используем логистическую регрессию?
g.smk.lr <- glm(cancer~smoking.f, data=datt, family = "binomial")
g.nul.lr(cancer)

anova(g.add.lr, g.res.lr, test="LRT")
anova(g.smk.lr, g.res.lr, test="LRT")

#
AIC(g.res)
AIC(g.res.inter)
AIC(g.res.nul)



