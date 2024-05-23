install.packages("funModeling")
library(tidyverse)
library(lubridate)
library(funModeling)
library(readr)

# Veriyi yükleyin
online_retail_listing <- read_delim("C:/Users/.../online_retail_listing.csv", 
                                    delim = ";", escape_double = FALSE, trim_ws = TRUE)
#View(online_retail_listing)

df <- online_retail_listing
head(df)
# Her sütundaki eksik değer sayısını hesapla
missing_values <- colSums(is.na(df))
print(missing_values)

# Veri boyutunu ve özetini göster
print(dim(df))
print(summary(df))

# İlk iki sütunu kaldır
df <- df[-c(1, 2)]

# Eksik değerleri kaldır
df <- na.omit(df)
print(colSums(is.na(df)))

# Price sütunundaki virgülleri noktaya çevir ve sayısal tipe dönüştür
df$Price <- as.numeric(gsub(",", ".", df$Price))
print(class(df$Price))

# Negatif Price ve Quantity değerlerini NA yap ve eksik değerleri kaldır
df$Price <- ifelse(df$Price < 0, NA, df$Price)
df$Quantity <- ifelse(df$Quantity < 0, NA, df$Quantity)
df <- na.omit(df)

# Price sütununda kaç tane sıfır olduğunu say
num_zeros <- sum(df$Price == 0, na.rm = TRUE)
print(num_zeros)

# Price değerlerini 1'den küçükse NA yap ve eksik değerleri kaldır
df$Price <- ifelse(df$Price < 1, NA, df$Price)
df <- na.omit(df)

# Total_Price sütunu ekle
df <- df %>% mutate(Total_Price = Quantity * Price)
head(df)


# InvoiceDate sütununu tarih formatına çevir
df$InvoiceDate <- dmy_hms(df$InvoiceDate)
head(df)

# InvoiceDate sütunundan sadece tarihi al
df$InvoiceDate <- date(df$InvoiceDate)
refDay <- max(df$InvoiceDate)

# Recency hesapla
Recency <- df %>% 
  group_by(`Customer ID`) %>% 
  summarise(Recency = as.numeric(refDay - max(InvoiceDate)))

# Frequency hesapla
Frequency <- df %>% 
  group_by(`Customer ID`) %>% 
  summarise(Frequency = n())

# Monetary hesapla
Monetary <- df %>% 
  group_by(`Customer ID`) %>% 
  summarise(Monetary = sum(Total_Price))
quantile(RFM$Recency)
# Recency quantile değerleri ve skorları
recency_quantiles <- c(0, 21, 45, 104, 353, Inf)
RFM$R_Score <- cut(RFM$Recency, breaks = recency_quantiles, labels = c(5, 4, 3, 2, 1), include.lowest = TRUE)

# Frequency quantile değerleri ve skorları
frequency_quantiles <- c(0, 16, 42, 110, 9760, Inf)
RFM$F_Score <- cut(RFM$Frequency, breaks = frequency_quantiles, labels = c(1, 2, 3, 4, 5), include.lowest = TRUE)

# Monetary quantile değerleri ve skorları
monetary_quantiles <- c(0, 297.475, 764.670, 1983.033, 574281.880, Inf)
RFM$M_Score <- cut(RFM$Monetary, breaks = monetary_quantiles, labels = c(1, 2, 3, 4, 5), include.lowest = TRUE)

head(RFM)

# RFM skorlarını birleştir
#RFM$RF_Scores <- as.numeric(as.character(RFM$R_Score)) * 10 + as.numeric(as.character(RFM$F_Score))
#RFM
#İKİNCİSKOR
RFM$RF_Scores <- as.numeric(as.character(RFM$R_Score))* 10 + as.numeric(as.character(RFM$F_Score)) + as.numeric(as.character(RFM$M_Score))
RFM
is.na(RFM$RF_Scores)

#num_zeros <- sum(RFM$RF_Scores == 0, na.rm = TRUE)
#print(num_zeros)

# Her sütundaki eksik değer sayısını hesapla
# missing_values <- colSums(is.na(RFM))
# print(missing_values)
# length(RFM$RF_Scores)

# RFM <- na.omit(RFM)

# Kütüphane yükleme
# library(stats)

# Veri seti ve küme sayısı
# RFM_scores <- RFM$RF_Scores
# k <- 10  # Örnek olarak 10 küme kullanalım

# K-means algoritmasını uygulama
# kmeans_result <- kmeans(RFM_scores, centers = k)

# Küme merkezlerini ve kümeleme sonuçlarını görüntüleme
# kmeans_result$centers
# kmeans_result$cluster

summary(RFM$RF_Scores)


# Segmentasyon
segments <- list(
  `Kayıp Müşteriler` = seq(22, 31),
  `Risk Altında` = seq(32, 39),
  `Uyuyan` = seq(40, 41),
  `Uyumak Üzere` = seq(42, 43),
  `İlgi Gerekiyor` = seq(44, 45),
  `Sadık Müşteriler` = seq(45, 51),
  `Umut Vadeden` = seq(52, 54),
  `Yeni Müşteri` = 55,
  `Potansiyel Sadık` = seq(56, 57),
  `Şampiyonlar` = 58
)



RFM$Segment <- "Other"
for (segment in names(segments)) {
  RFM$Segment <- ifelse(RFM$RF_Scores %in% segments[[segment]], segment, RFM$Segment)
}

head(RFM)

# Yeni veri çerçevesini oluştur
New_df <- RFM %>% select(`Customer ID`, Segment) %>% rename(Customer = `Customer ID`, Segments = Segment)
head(New_df)

# Eksik değerleri kontrol et
sum(is.na(New_df))
dim(New_df)

#görselleştirmeler
library(ggplot2)

# Segmen için Frekans Bar grafiği %
freq(RFM$Segment)

# Segment dağılımı için bar grafiği
ggplot(New_df, aes(x = Segments)) +
  geom_bar(fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(title = "RFM Segment Dağılımı", x = "Segment", y = "Müşteri Sayısı") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Segment dağılımı için pasta grafiği
segment_counts <- New_df %>%
  group_by(Segments) %>%
  summarise(count = n())

ggplot(segment_counts, aes(x = "", y = count, fill = Segments)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void() +
  labs(title = "RFM Segment Dağılımı") +
  theme(legend.position = "right") +
  scale_fill_brewer(palette = "Set3")


# Her segmentin müşteri sayısı ve ortalama değerini hesapla
segment_summary <- RFM %>%
  group_by(Segment) %>%
  summarise(
    Customer_Count = n(),
    Average_Recency = mean(Recency, na.rm = TRUE),
    Average_Frequency = mean(Frequency, na.rm = TRUE),
    Average_Monetary = mean(Monetary, na.rm = TRUE)
  )

# Müşteri sayısı için bar grafiği
ggplot(segment_summary, aes(x = Segment, y = Customer_Count, fill = Segment)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Segment Başına Müşteri Sayısı", x = "Segment", y = "Müşteri Sayısı") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set3")

# Ortalama değerler için bar grafiği
segment_summary_long <- segment_summary %>%
  pivot_longer(cols = starts_with("Average"), names_to = "Metric", values_to = "Value")

ggplot(segment_summary_long, aes(x = Segment, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Segment Başına Ortalama Değerler", x = "Segment", y = "Ortalama Değer") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set3")




# reshape2 paketini yükle
# install.packages("reshape2")
library(ggplot2)
library(reshape2)

# Korelasyon matrisini hesapla
correlation_matrix <- cor(RFM[, c("Recency", "Frequency", "Monetary")], use = "complete.obs")

# Korelasyon matrisi için ısı haritası grafiği
ggplot(data = melt(correlation_matrix), aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name="Correlation") +
  theme_minimal() +
  labs(title = "Değişkenler Arasındaki Korelasyon", x = "", y = "") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Segmentlere göre Recency, Frequency ve Monetary için kutu grafiği
ggplot(RFM, aes(x = Segment, y = Recency, fill = Segment)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Recency Segmentlerine Göre Kutu Grafiği", x = "Segment", y = "Recency") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(RFM, aes(x = Segment, y = Frequency, fill = Segment)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Frequency Segmentlerine Göre Kutu Grafiği", x = "Segment", y = "Frequency") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(RFM, aes(x = Segment, y = Monetary, fill = Segment)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Monetary Segmentlerine Göre Kutu Grafiği", x = "Segment", y = "Monetary") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Recency dagılımı
ggplot(RFM, aes(x = Recency)) +
  geom_histogram(binwidth = 10, fill = "skyblue", color = "black") +
  labs(title = "Recency Dağılımı", x = "Recency", y = "Frekans") +
  theme_minimal()

# Recency Yogunluk grafiği
ggplot(RFM, aes(x = Recency)) +
  geom_density(fill = "skyblue", color = "black") +
  labs(title = "Recency Yoğunluk Grafiği", x = "Recency", y = "Yoğunluk") +
  theme_minimal()


head(RFM)
freq(RFM$Segment)
