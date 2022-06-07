library(lme4) # lme4, nlme -- два пакета для линейных моделей, выбираем любой. lmerTest работает с lme4. lmer из пакета lme4, lme - nlme
library(nlme)
library(joineR)
#library(gee)
#library(geepack)
library(cAIC4) # позволяет вычислять условный Акаике для выбора наилучшей модели в усовии смешанной модели
library(lmerTest)
library(mratios)
library(RLRsim)
library(ggplot2)
library(gee) # не рассказали на занятии, но запуск стандартный
library(geepack)
require(graphics)
#
base.dir<-here::here("r/stats2021fall/homework4")
#
setwd(base.dir)
dd<-read.table("IDZ4_Data_504020121.csv",sep=",",header = T,as.is=T)
d16<-dd[dd$Variant==4,-1] # почему такое название? Изначальный код -- для варианта 16
# test dataset
d16T<-d16
d16T$Y<-d16$Y+1/2*d16$Visit
d16T$Y[d16T$A==1]<-d16T$Y[d16T$A==1]+1+1/2*d16T$Visit[d16T$A==1]
# A,B-? - time dependent?
ATD<-FALSE
BTD<-FALSE
for (i in d16$ID){
	d.i<-d16[d16$ID==i,]
	if (var(d.i$A)>0){
		ATD<-ATD | TRUE
	}
	if (var(d.i$B)>0){
		BTD<-BTD | TRUE
	}
}
# to original data 
d16.t1<-d16[(d16$Visit==4 & d16$A==1),]
d16.t2<-d16[(d16$Visit==4 & d16$A==0),]
#
ks.test(d16.t1$Y,d16.t2$Y)
# 2 - No time analysis (corrected data)
pdf("NoTime.pdf",width=9, height=6)
plot(d16T$B,d16T$Y,"n")
ftr<-d16T$A==0
points(d16T$B[ftr],d16T$Y[ftr],col="red")
ftr<-d16T$A==1
points(d16T$B[ftr],d16T$Y[ftr],col="blue")
#
dim(d16T)
names(d16T)
#
q<-lm(Y~A*B,data=d16T)
qc<-q$coefficients
x<-c(0,1)
y<-qc[1]+qc[3]*x
points((x+1),y,"l",col="red",lwd=3)
x<-c(0,1)
y<-qc[1]+qc[2]+qc[3]*x+qc[4]*x
points((x+1),y,"l",col="blue",lwd=3)
dev.off()
q.a<-anova(q) # задача ничем не отличается от дисперсионного анализа.
# 3 - time effect // вводим дополнительную переменную Visit (~время)
pdf("All.pdf",width=9, height=6)
plot(d16T$Visit,d16T$Y,"n")
for (i in d16T$ID){
  ftr<-d16T$ID==i
  d16.i<-d16T[ftr,]
  points(d16.i$Visit,d16.i$Y,"l")
}
m<-NULL
for (i in 0:4){
  m<-c(m,mean(d16T$Y[d16T$Visit==i]))
}
points(0:4, m, "l", col="red", lwd=3)
dev.off()
#
id<-unique(d16T$ID)
lv<-levels(as.factor(d16T$A))
lvB<-levels(as.factor(d16T$B))
lvV<-levels(as.factor(d16T$Visit))
# plot no B effect
for (ii in lv){ # можно было выбрать не так много траекторий!
d161<-d16T[d16T$A==ii,]
nnm<-paste0()
pdf(paste0("A=",ii),width=9, height=6)
plot(d161$Visit,d161$Y,"n",main=paste0("Trajectories A=",ii),xlab="Visit",ylab="Y")
for (i in d161$ID){
  ftr<-d161$ID==i
  d16.i<-d161[ftr,]
  points(d16.i$Visit,d16.i$Y,"l")
}
m<-NULL
for (i in 0:4){
  m<-c(m,mean(d161$Y[d161$Visit==i]))
}
points(0:4, m, "l", col="red", lwd=3)
dev.off() # Можно ли сказать, что при А=0 разброс меньше? Наверное, нет
# при выполнении это лишь некое руководство к действию, его можно улучшать!
# Фактор B не изобразить.
}
# data reconstruction
#d16A<-d16[,c(1,3,4,2,5)]
#lv<-levels(as.factor(d16$Visit))
#d16a<-d16A[d16A$Visit==lv[1],-5]
#names(d16a)[3]<-paste0("B_Visit",lv[1])
#names(d16a)[4]<-paste0("Y_Visit",lv[1])
#for (i in 2:length(lv)){
#	d16.i<-d16A[d16A$Visit==lv[i],-c(2,5)]
#	names(d16.i)[2]<-paste0("B_Visit",lv[i])
#	names(d16.i)[3]<-paste0("Y_Visit",lv[i])
#	d16a<-merge(d16a,d16.i,by="ID")
#}
# TO DATA TABLE
# устанавливаем факторы: количество наблюдений для каждого индивида
# набор имён  ID, A... поскольку факторы B и Y меняются со временем
f.tab<-function(dd){
  id<-unique(dd$ID)
  nd<-names(dd)
  lvVis<-levels(as.factor(dd$Visit))
  ftb<-matrix(nrow=length(id),ncol=2+2*length(lvVis))
  nms<-c("ID","A")
  for (j in lvVis){
    nms<-c(nms,c(paste0("B_V",j),paste0("Y_V",j)))
  }
  colnames(ftb)<-nms
  for (ii in seq_along(id)){
    i<-id[ii]
    dd.i<-dd[dd$ID==i,]
    if (dim(dd.i)[1]>0){
      rw<-c(i,dd.i$A[1])
      for (k in lvVis){
        dd.ik<-dd.i[dd.i$Visit==k,]
        if (dim(dd.ik)[1]>0){
          rw<-c(rw,c(dd.ik$B,dd.ik$Y))
        } else {
          rw<-c(rw,c(NA,NA))
        }
      }
    }
    ftb[ii,]<-rw
  }
  return(as.data.frame(ftb))
}
# Correlation no effects
dd16<-f.tab(d16T)  # теперь число строк соответствует числу индивидов, каждая строчка -- соответствующая траектория.
# Так удобнее считать корреляции наблюдений (Y) в разные моменты времени.
# Если разбивать на группы по факторам, то корреляции *по идее* должны уменьшаться (если есть влияние факторов).
# Если нет влияния факторов, корреляции будут такие же.
nms<-paste0("Y_V",lvV)
COR.ALL<-var(dd16[,names(dd16)%in%nms])
# Correlation Unstructured A effect only
for (ii in lv){
  vnm<-paste0("COR_A",ii)
  vnm_corr <- paste0("corr", ii)
  d16.ii<-d16T[d16T$A==ii,]
  dd16.ii<-f.tab(d16.ii)
  nms<-paste0("Y_V",lvV)
  assign(vnm,var(dd16.ii[,names(dd16.ii)%in%nms]))
  assign(vnm_corr, cor(dd16.ii[, names(dd16.ii) %in% nms]))
}
COR_A0
COR_A1
corr0
corr1
# возможно, также имело смысл построить корреляционную матрицу
# ковариации... не все посчитаются, поскольку нужно рассматривать все комбинации B.
# Если есть биологические соображения, можно посчитать ковариации локально,
# но в общем случае слишком затратно, оценки слишком ненадёжные.
# Мы же здесь рассматриваем узкую задачу: при фиксированном А и при фиксированном B

# Correlation Unstructured A and B effects
for (ii in lv)
for (jj in lvB){
  vnm<-paste0("COR_A",ii,"_B",jj)
  d16.ii<-d16T[d16T$A==ii,]
  d16.ii$Y[d16.ii$B!=jj]<-NA
  dd16.ii<-f.tab(d16.ii)
  nms<-paste0("Y_V",lvV)
  assign(vnm,var(dd16.ii[,names(dd16.ii)%in%nms],use="pairwise.complete.obs"))
}
# ковариационные характеристики при усилении группировки не должны быть больше:
# чем в большее количество групп группируем, тем меньше должен быть разброс
COR_A0_B1
COR_A1_B1

# Correlation sub-stationary (Variogram)
# по всей видимости, встроенная функция "variogram" запрограммирована неэффективно и на таком большом наборе данных не работает.
# Если данные урезать, работает, но нам не очень подходит

#v<-variogram(d16T$ID,d16T$Visit,d16T$Y)

# Строим вариограмму вручную. Вариограмма строится на остатках (residuals) модели.
# Может быть вариограмма и на сырых данных. Кому удастся запустить вариограмму на сырых игреках -- здорово!!
# LME не работает без случайного эффекта
m0<-lme(Y~Visit,random=~1|ID,data=d16T)
v0<-Variogram(m0,form =~ Visit | ID) # переменная группироваки - ID (при разных ID переменные считаются независимыми)
v1<-Variogram(m0,form =~ Visit | ID,resType = "response") # предполагается стационарность: расстояние от 1 до 2 такое же, как от 2 до 3
plot(v0) # сглаживание на графике не получилось. Ну и ладно. Главное, что сама вариограмма есть.
# v1 - это без нормировки.
# Давайте попробуем объяснить вариацию по этой вариограмме.
#
s2<-NULL
for (i in lvV){
  s2<-c(s2,var(d16T$Y[d16T$Visit==i]))
}
s1<-sqrt(s2)
#
lvVL<-length(lvV)
vgr<-v0$variog
VARR<-matrix(nrow=lvVL,ncol=lvVL)
for (i in 1:lvVL)
for (j in 1:lvVL){
  if (i!=j){ 
    VARR[i,j]<-s1[i]*s1[j]*(1-vgr[abs(i-j)])
  } else {
    VARR[i,j]<-s2[i]
    }
}
# Add random effect
vv<-levels(as.factor(d16A$ID))
yy<-rnorm(length(vv))
#for (i in 1:length(vv)){
#	Y<-d16A$Y
#	ftr<-d16A$ID==vv[i]
#	Y[ftr]<-Y[ftr]+yy[i]
#	d16A$Y<-Y
#}
#
qn<-lm(Y~Visit,data=d16T)
q1<-lmer(Y~Visit+(1|ID),data=d16T,REML=FALSE) # ML обычно даёт более маленькие значения
re<-ranef(q1)
#
q1a<-lme(fixed=Y~Visit,random=~1|ID,data=d16T,method="ML")
q2a<-lme(fixed=Y~Visit,random=~Visit|ID,data=d16T,method="ML")
q1a.cAIC<-cAIC(q1a)
q2a.cAIC<-cAIC(q2a)
# Alternative form
q1x<-lmer(Y~Visit+(1|ID),data=d16T,REML=FALSE) 
q2x<-lmer(Y~Visit+(1|ID)+(0+Visit|ID),data=d16T,REML=FALSE) 
q2x<-lmer(Y~Visit+(1|ID)+(0+Visit|ID),data=d16T,REML=FALSE)
#
anova.lme(q1a)
ranova(q2x,reduce.terms = FALSE)
# 




















# GLM
qn<-lm(Y~Visit,data=d16)



############## GLM ########################









































#
xl<-xlab("Visit")
yl<-ylab("Y")
ggplot(dd,aes(x=Visit,y=Y,color=factor(ID)))+geom_line()+xl+yl+facet_grid(A~B)+guides(color=FALSE)

xl <- xlab("Week")
yl <- ylab("TWSTRS-total score")
ggplot(cdystonia, aes(x = week, y = twstrs, color = factor(id))) + geom_line() + xl + yl + facet_grid(treat ~ site) + guides(color = FALSE) 



# Read data
names(d1)[c(2:9)]<-paste0("ID_",c(1:8))
# mean
d1[,2:9]<-log(d1[,2:9])
mean1<-colMeans(d1[,c(2:9)])
y<-data.frame(id=names(d1)[c(2:9)],HML2=mean1)
pdf(paste0("Barplot_2_",tpe,".pdf"),width=10,height=6)
barplot(t(as.matrix(y[,2])), main="Genes expression", xlab="Normal                                                                                                           Tumor",names.arg=y$id,beside=T,col=c("blue","blue","blue","blue","red","red","red","red"),legend=TRUE)
dev.off()
# boxplot
pdf(paste0("Boxplot_2_",tpe,".pdf"),width=10,height=6)
boxplot(d1[,c(2:9)], main="Genes expression", xlab="Normal                                                                                                           Tumor",col=c("blue","blue","blue","blue","red","red","red","red"))
legend("topleft",fill=c("blue","red"),legend=c("Normal","Tumor"),col=c("blue","red"))
dev.off()
# ecdf
dd<-d1[,c(2:9)]
clr<-c("darkgreen","green","blue","violet","red","brown","orange","pink")
x.l<-c(min(dd),max(dd))
pdf("Ecdf.pdf",width=10,height=6)
plot(ecdf(dd[,1]),verticals=TRUE, do.points=FALSE,xlim=x.l,lwd=3,col=clr[1],main="Ecdf classes",ylab = "Ecdf")
for (i in 2:dim(dd)[2]){
  plot(ecdf(dd[,i]),verticals=TRUE, do.points=FALSE,xlim=x.l,col=clr[i],add=TRUE,lwd=2)
  legend("bottomright",col=clr,lwd=2,legend=c("Normal","Normal","Normal","Normal","Tumor","Tumor","Tumor","Tumor"))
}
dev.off()
# Student's t-test
x<-as.numeric(as.matrix(dd[,c(1:4)]))
y<-as.numeric(as.matrix(dd[,c(5:8)]))
q<-t.test(x,y)
q$statistic
q$parameter
q$p.value
q$conf.int
q$estimate
q$null.value
q$stderr
q1<-ttestratio(y,x)
# Mann-Witney test
q2<-wilcox.test(x,y,conf.int=TRUE)
# ties
#table(y)
#which(y==90.40843139)



# To GLM
gene<-array(d1$Gene,dim=dim(dd)[1]*dim(dd)[2])
id<-as.character(t(matrix(names(dd),nrow=dim(dd)[2],ncol=dim(dd)[1])))
expr<-as.numeric(as.matrix(dd))
d.glm<-data.frame(gene=gene,id=id,class=NA,expr=expr)
d.glm$class[d.glm$id %in% c("ID_1","ID_2","ID_3","ID_4")]<-"normal"
d.glm$class[d.glm$id %in% c("ID_5","ID_6","ID_7","ID_8")]<-"tumor"
d.glm$class<-as.factor(d.glm$class)
d.glm$gene<-as.factor(d.glm$gene)
# Model 3 ( both random )
q3<-lmer(expr~class+(class|gene)+(1|id),data=d.glm,REML=FALSE) 
q3r<-lmer(expr~class+(class|gene)+(1|id),data=d.glm) 
q30<-lmer(expr~(1|id)+(class|gene),data=d.glm)
q31<-lmer(expr~class+(1|gene)+(1|id),data=d.glm)
# 
a3<-anova(q3)
coef<-summary(q3)$coefficients
a30<-anova(q3,q30)
a3$"Pr(>F)"[1]
# confint for main effect
L3<-c(0,1)
bb3<-contest1D(q3,L=L3,confint=TRUE) # 
bb33<-contest1D(q3r,L=L3,confint=TRUE,ddf="Kenward-Roger")
# confint for means 
L1<-c(1,1) # tumor
bb1<-contest1D(q3,L=L1,confint=TRUE) # 
bb11<-contest1D(q3r,L=L1,confint=TRUE,ddf="Kenward-Roger")
L2<-c(1,0) # normal
bb2<-contest1D(q3,L=L2,confint=TRUE) # 
bb22<-contest1D(q3r,L=L2,confint=TRUE,ddf="Kenward-Roger")
# Random effect
q3<-lmer(expr~class+(1|id)+(class|gene),data=d.glm,REML=FALSE) 
q3r<-lmer(expr~class+(1|id)+(class|gene),data=d.glm) 
q31<-lmer(expr~class+(1|id)+(1|gene),data=d.glm,REML=FALSE) 
q31<-lm(expr~class,data=d.glm)
r2<-anova(q3,q31)
ranova(q3)
# ratio #fixef(lmefit)
cof <-fixef(q3) 
cofr <-fixef(q3r) 
vcm <-vcov(q3)
vcmr <-vcov(q3r)
Num<-t(as.matrix(c(1,0)))
Den<-t(as.matrix(c(1,1)))
rci<-gsci.ratio(cof, vcm, Num, Den, alternative="less",degfree=bb1$df) #, degfree=d.f)
rcir<-gsci.ratio(cofr, vcm, Num, Den,alternative="less",degfree=bb11$df)
bw<-1/as.numeric(rci$conf.int)
bwrx<-1/as.numeric(rcir$conf.int)
# Appendix other models 
# MODEL SELECT
ll<-c("0","01","02","1","11","21","2","31","3")
m.n<-c("LM_class","LM_class|gene","LM_class|gene-r","LMM_class:id","LMM_class|gene:id","LMM_class:gene","LMM_class:class|gene","LMM_class:gene-id","LMM_class:class|gene-id")
f.lst<-list()
f.lst$f0<-formula(expr~class)
f.lst$f01<-formula(expr~class/gene)
f.lst$f02<-formula(expr~gene%in%class)
f.lst$f1<-formula(expr~class+(1|id))
f.lst$f11<-formula(expr~class/gene+(1|id))
f.lst$f21<-formula(expr~class+(1|gene))
f.lst$f2<-formula(expr~class+(class|gene))
f.lst$f31<-formula(expr~class+(1|id)+(1|gene))
f.lst$f3<-formula(expr~class+(1|id)+(class|gene))
#
assign("last.warning", NULL, envir = baseenv())
res.t<-list(mod=NULL,warning=NULL,AIC=NULL,BIC=NULL,cAIC=NULL)
for (i in 1:length(ll)){
  f.name<-paste0("f",ll[i])
  frm<-f.lst[[f.name]]
  if (ll[i]%in%c("0","01","02")){
    q<-lm(frm,data=d.glm)
    res.t$AIC<-c(res.t$AIC,AIC(q))
    res.t$BIC<-c(res.t$BIC,BIC(q))
    res.t$cAIC<-c(res.t$cAIC,NA)
  } else {
    q<-lmer(frm,data=d.glm,REML=FALSE)
    res.t$AIC<-c(res.t$AIC,AIC(q))
    res.t$BIC<-c(res.t$BIC,BIC(q))
    res.t$cAIC<-c(res.t$cAIC,cAIC(q)$caic)
  }
  res.t$mod<-c(res.t$mod,f.name)
  l.v<-length(warnings())
  res.t$warning<-c(res.t$warning,l.v)
  assign("last.warning", NULL, envir = baseenv())
}
res.t<-as.data.frame(res.t)
res.t$model<-m.n
write.table(res.t,file=paste0("IC_",tpe,".csv"),dec=",",sep=";",row.names = FALSE)




