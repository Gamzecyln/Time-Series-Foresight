#betimsel istatistikler
summary(dataset)




##kütüphanelerin yüklenmesi
install.packages("fpp")
install.packages("forecast")
install.packages("rJava")
install.packages("ts")
install.packages("ggplot2")
library(fpp)
library(forecast)
library(ggplot2)
library(rJava)
library(ts)

# Veriyi zaman serisine dönüştürme
dataset_ts<- ts(dataset)
#zaman serisi grafiğinin çizilmesi
dataset_ts <- ts(dataset, start=c(2009,1), frequency=5)
ts.plot(dataset_ts,gpars=list(main="zaman serisi grafiği", xlab="Zaman", ylab="seyahat sayısı"))

#Acf fonksiyonu ile Acf grafiğinin çizilmesi
Acf(dataset_ts,lag.max = 42,  ylim=c(-1,1), lwd=3)
#Pacf Fonksiyonu ile Pacf grafiğinin çizilmesi
Pacf(dataset_ts,lag.max = 42, ylim=c(-1,1), lwd=3)


#serinin durağanlaştırılması

#Serinin mevsimsel farkını alma
seasonal_diff <- diff(dataset_ts,lag=5)

#ACF ve PACF grafikleri
Acf(seasonal_diff,lag.max = 42,  ylim=c(-1,1), lwd=3)
Pacf(seasonal_diff,lag.max = 42, ylim=c(-1,1), lwd=3)



###Toplamsal Ayrıştırma yöntemi
dataset_trent<- tslm(dataset_ts ~ trend)
periyot<- dataset_ts- dataset_trent[["fitted.values"]]
MHO <- ma(dataset_ts, order = 5, centre = TRUE)
mevsim<- dataset_ts-MHO
#hata terimini yok edebilmek amaciyla her periyottaki ortalama deger hesaplanir.
donemort <- t(matrix(data= mevsim, nrow = 12))
endeks <- colMeans(donemort, na.rm = T) - mean(colMeans(donemort, na.rm = T))
colMeans(donemort, na.rm = T)
mean(colMeans(donemort, na.rm = T))
indeks<- matrix(data = endeks, nrow = 72)
trenthata<- dataset_ts - indeks
trent<- tslm(trenthata~trend)
tahmin<- indeks+ trent[["fitted.values"]]
hata<-dataset_ts - indeks - trent[["fitted.values"]]

plot( window(dataset_ts), 
      xlab="Zaman", ylab="",lty=1, col=4, lwd=2, ylim=c(5976,78525) ,
      main="TOPLAMSAL AYRIŞTIRMA İLE")

lines( window(tahmin) ,lty=3,col=2,lwd=3)


###Hatalar akgürültü mü?
Acf(hata,main="hata",lag.max = 42,  ylim=c(-1,1), lwd=3)
Pacf(hata,main="hata",lag.max = 42, ylim=c(-1,1), lwd=3)


###Çarpımsal Ayrıştırma Yöntemi
dataset_ma <- ma(dataset_ts, order = 5, centre = TRUE)
mevsimsel_bilesen <- dataset_ts / dataset_ma
donemort_ca <- t(matrix(data= mevsimsel_bilesen, nrow = 12, 
                        ncol= length(dataset_ts) / 12))
colMeans(donemort_ca , na.rm = T)
sum(colMeans(donemort, na.rm = T))
mean(colMeans(donemort, na.rm = T))
endeks <- colMeans(donemort_ca, na.rm = T) - mean(colMeans(donemort_ca, na.rm = T))
endeks_1 <- rep(endeks, length.out= nrow(dataset))
trent_hata<- dataset_ts - endeks_1
trent<- tslm(trent_hata~trend)
tahmin<- endeks_1 + trent[["fitted.values"]]
hata<-dataset_ts - indeks - trent[["fitted.values"]]

#Orijinal Seri ile Tahmin Serisinin Uyumu
plot( window(dataset_ts), 
      xlab="Zaman", ylab="",lty=1, col=4, lwd=2, ylim=c(5976,78525) ,
      main="ÇARPIMSAL AYRIŞTIRMA İLE")

lines( window(tahmin) ,lty=3,col=2,lwd=3)

#Hatalar akgürültü mü?
Acf(hata,main="hata",lag.max = 42,  ylim=c(-1,1), lwd=3)
Pacf(hata,main="hata",lag.max = 42, ylim=c(-1,1), lwd=3)

#Toplamsal Regresyon Modeli
t<- 1: 1: 72 # t terimini oluşturalım

sin1<-sin(2*3.1416*t/5)
cos1<-cos(2*3.1416*t/5)

veriseti<- as.data.frame(cbind(dataset_ts,t,sin1,cos1))

names(veriseti) <- c("y","t","sin1","cos1")
attach(veriseti)

regresyon.model1<-lm(y~t+sin1+cos1)
summary(regresyon.model1)

# Durbin-Watson testini manuel olarak hesaplayan fonksiyon
durbin_watson_test <- function(model) {
  residuals <- residuals(model)
  numerator <- sum(diff(residuals)^2)
  denominator <- sum(residuals^2)
  DW_statistic <- numerator / denominator
  return(DW_statistic)
}
dwtest(regresyon.model1)
# Fonksiyonu kullanarak Durbin-Watson istatistiğini hesapla
DW_statistic <- durbin_watson_test(regresyon.model1)
print(DW_statistic)

# Toplamsal regresyon modelinin tahminlerini alın
regresyon_tahmin <- predict(regresyon.model1)

# Zaman serisi grafiğini çizin
plot(window(dataset_ts), xlab="Zaman", ylab="", type="l", lty=1, col=4, lwd=2, ylim=c(5976,78525))

# Toplamsal regresyon modelinin tahminlerini çizgi olarak ekleyin
lines(window(regresyon_tahmin), lty=1, col=4, lwd=2)

# Legend ekleyin

veri <- window(dataset_ts)
regresyon_tahmin <- window(regresyon_tahmin)

# Grafiği çiz
plot(veri, xlab="Zaman", ylab="", type="l", lty=1, col=4, lwd=2, ylim=c(5976,78525))
lines(regresyon_tahmin, lty=1, col=2, lwd=2) 

# Legend ekle
legend("topright", legend=c("Veri", "Regresyon Tahmini"),
       lwd=c(2,2), lty=c(1,1), cex=0.7, col=c(4,2), xpd=TRUE, text.width=0.00007, text.height=13)


#Çarpımsal Regresyon Model

s1<-t*sin(2*3.1416*t/5)
c1<-t*cos(2*3.1416*t/5)

veriseti3<- as.data.frame(cbind(dataset_ts,t,s1,c1))
names(veriseti3)<- c("y","t","s1","c1")
attach(veriseti3)

regresyon.model3<-lm(y~t+s1+c1)
summary(regresyon.model3)


durbin_watson_test <- function(model) {
  residuals <- residuals(model)
  numerator <- sum(diff(residuals)^2)
  denominator <- sum(residuals^2)
  DW_statistic <- numerator / denominator
  return(DW_statistic)
}
DW_statistic <- durbin_watson_test(regresyon.model3)
print(DW_statistic)

regresyon_tahmin3 <- predict(regresyon.model3)
hatalar <- residuals(regresyon.model3)
# Box-Ljung Testi
Box.test(hatalar, lag = 20, type = "Ljung-Box")

####düzleştirme
#####################üstel düzlestirme#############################################

# Mevsimsel Basit Düzlestirme Yöntemi
install.packages("forecast")
library(forecast)
# Zaman serisini olusturalim
dataset_ts <- ts(dataset, start=c(2009,1), frequency=5)
# Mevsimsel üstel düzlestirme modelini olusturalim
duzlestirilmis_model <- ets(dataset_ts, model = "ZNZ")  # Model tipini seçebilirsiniz
duzlestirilmis_model <- ets(dataset_ts, model = "ANA")
# Modelin özetini gösterelim
print(summary(duzlestirilmis_model))
# Gelecekteki degerleri tahmin edelim
tahminler <- forecast(duzlestirilmis_model, h = 5)  #5 adet gelecekteki degeri tahmin edelim
# Tahminleri gösterelim
print(tahminler)


# Hata terimlerini elde edelim
hata_terimi<- residuals(duzlestirilmis_model)
# Hata terimlerini görsellestirelim
Box.test (hata_terimi, lag = 42, type = "Ljung")

Acf(hata_terimi,main="Hata", lag.max = 42,  ylim=c(-1,1), lwd=3)
Pacf(hata_terimi,main="Hata",lag.max = 42, ylim=c(-1,1), lwd=3)

#modeller

install.packages("forecast")
library(forecast)
dataset_ts_arıma1 <- Arima(ts(dataset_ts),seasonal=c(0,1,0),include.constant=TRUE) 
coeftest(dataset_ts_arıma1)
summary(dataset_ts_arıma1)

dataset_ts_arıma2 <- Arima(ts(dataset_ts),seasonal=c(1,1,0),include.constant=TRUE) 
coeftest(dataset_ts_arıma2)
summary(dataset_ts_arıma2)

dataset_ts_arıma3 <- Arima(ts(dataset_ts),seasonal=c(0,1,1),include.constant=TRUE) 
coeftest(dataset_ts_arıma3)
summary(dataset_ts_arıma3)

arimaendeks<-auto.arima(dataset_ts)
print(arimaendeks)
tahmin<- dataset_ts_arıma1[["fitted"]]
hata_arima1<-dataset_ts_arıma1[["residuals"]]

plot( window(dataset_ts),
      xlab="Zaman(ay)",ylab="",lty=1,col=4, lwd=2)
lines(window(tahmin), lty=3,col=2, lwd=3)

Acf(hata_arima1,lag.max = 42,  ylim=c(-1,1), lwd=3)
Pacf(hata_arima1,lag.max = 42, ylim=c(-1,1), lwd=3)
#Ljung-Box Testi
Box.test(hata_arima1, lag = 42, type = "Ljung-Box")
