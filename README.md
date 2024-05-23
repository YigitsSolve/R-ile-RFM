RFM Analysis with Customer Segmentation
This project performs RFM (Recency, Frequency, Monetary) analysis on an online retail dataset to segment customers based on their purchasing behavior. The steps include data preprocessing, calculation of RFM scores, and customer segmentation. Visualization of the results is also provided to better understand the customer segments.

Libraries Used
tidyverse: For data manipulation and visualization.
lubridate: For date handling.
funModeling: For data exploration.
readr: For data reading.
ggplot2: For data visualization.
reshape2: For reshaping data for visualization.
Steps
Data Loading and Preprocessing: The dataset is loaded and initial preprocessing steps are performed including handling missing values and removing invalid data.

RFM Calculation:

Recency: Number of days since the last purchase.
Frequency: Total number of purchases.
Monetary: Total spending by the customer.
RFM Scoring: Each customer is scored based on quantiles of Recency, Frequency, and Monetary values. The scores are combined to create a final RFM score.

Customer Segmentation: Customers are segmented into different groups based on their RFM scores, such as "Champions", "Loyal Customers", "At Risk", etc.

Visualization: Several visualizations are created to understand the distribution of segments and the characteristics of each segment, including:

Bar and pie charts for segment distribution.
Heatmap for correlation between RFM variables.
Box plots for Recency, Frequency, and Monetary values across segments.
Histograms and density plots for Recency distribution.
Visualizations
Bar and Pie Charts: Show the distribution of customers across different segments.
Heatmap: Displays the correlation between Recency, Frequency, and Monetary values.
Box Plots: Compare Recency, Frequency, and Monetary values across different segments.
Histograms and Density Plots: Provide a detailed view of the distribution of Recency values.
Usage
To run this analysis, ensure you have the necessary libraries installed and load the dataset. Execute the provided R script to preprocess the data, calculate RFM scores, segment the customers, and visualize the results.

Conclusion
This project provides a comprehensive approach to customer segmentation using RFM analysis. The visualizations help in understanding the distribution and characteristics of different customer segments, enabling better decision-making for targeted marketing strategies.




Turkish

RFM Analizi ile Müşteri Segmentasyonu
Bu proje, bir çevrimiçi perakende veri seti üzerinde RFM (Recency, Frequency, Monetary) analizi gerçekleştirerek müşterileri satın alma davranışlarına göre segmentlere ayırır. Veri ön işleme, RFM skorlarının hesaplanması ve müşteri segmentasyonu adımlarını içerir. Sonuçların daha iyi anlaşılması için görselleştirmeler de sağlanmıştır.

Kullanılan Kütüphaneler
tidyverse: Veri manipülasyonu ve görselleştirme için.
lubridate: Tarih işlemleri için.
funModeling: Veri keşfi için.
readr: Veri okuma için.
ggplot2: Veri görselleştirme için.
reshape2: Veriyi görselleştirme için şekillendirme.
Adımlar
Veri Yükleme ve Ön İşleme: Veri seti yüklenir ve eksik değerlerin yönetilmesi ve geçersiz verilerin kaldırılması gibi ön işleme adımları gerçekleştirilir.

RFM Hesaplama:

Recency (Güncellik): Son satın alma tarihinden bu yana geçen gün sayısı.
Frequency (Sıklık): Toplam satın alma sayısı.
Monetary (Monetary Değer): Müşteri tarafından yapılan toplam harcama.
RFM Skorlama: Her müşteri, Recency, Frequency ve Monetary değerlerinin çeyrekliklerine göre puanlanır. Bu puanlar birleştirilerek nihai RFM skoru oluşturulur.

Müşteri Segmentasyonu: Müşteriler, RFM skorlarına dayanarak "Şampiyonlar", "Sadık Müşteriler", "Risk Altında" gibi farklı segmentlere ayrılır.

Görselleştirme: Segmentlerin dağılımını ve her segmentin özelliklerini anlamak için çeşitli görselleştirmeler oluşturulur, bunlar arasında:

Segment dağılımı için bar ve pasta grafikleri.
RFM değişkenleri arasındaki korelasyon için ısı haritası.
Segmentler arasında Recency, Frequency ve Monetary değerlerini karşılaştırmak için kutu grafikleri.
Recency dağılımı için histogramlar ve yoğunluk grafikleri.
Görselleştirmeler
Bar ve Pasta Grafikleri: Farklı segmentler arasındaki müşteri dağılımını gösterir.
Isı Haritası: Recency, Frequency ve Monetary değerleri arasındaki korelasyonu gösterir.
Kutu Grafikler: Farklı segmentler arasında Recency, Frequency ve Monetary değerlerini karşılaştırır.
Histogramlar ve Yoğunluk Grafikler: Recency değerlerinin dağılımını detaylı bir şekilde gösterir.
Kullanım
Bu analizi çalıştırmak için gerekli kütüphanelerin yüklü olduğundan emin olun ve veri setini yükleyin. Sağlanan R betiğini çalıştırarak veriyi ön işleyin, RFM skorlarını hesaplayın, müşterileri segmentlere ayırın ve sonuçları görselleştirin.

Sonuç
Bu proje, RFM analizi kullanarak müşteri segmentasyonuna kapsamlı bir yaklaşım sunar. Görselleştirmeler, farklı müşteri segmentlerinin dağılımını ve özelliklerini anlamaya yardımcı olur ve hedefli pazarlama stratejileri için daha iyi karar vermeyi sağlar.
