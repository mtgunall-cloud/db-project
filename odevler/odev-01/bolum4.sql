-- Soru 1: Kaç çağrı kaydedilmiş?
SELECT COUNT(*) AS total_calls
FROM llm_calls;
-- 12
--
-- Yorum:
-- Sistemde şu ana kadar kaydedilmiş toplam 12 adet LLM çağrısı bulunmaktadır;
-- bu sayı veri tabanında izlenen tüm operasyonel hareketlerin eksiksiz tabanını oluşturur.


-- Soru 2: Kaç çağrı 2 saniyeden yavaş? (latency_ms > 2000)
SELECT COUNT(*) AS slow_call_count
FROM llm_calls
WHERE latency_ms > 2000;
-- 5
--
-- Yorum:
-- Toplam 12 çağrıdan 5 tanesinin (%41.7) yanıt süresi 2 saniyenin üzerinde kalmıştır;
-- bu durum sistemdeki çağrıların belirgin bir kısmında kullanıcı deneyimini etkileyebilecek 
-- yüksek gecikmeler yaşandığını göstermektedir.


-- Soru 3: Toplam maliyet ve toplam token sayısı
SELECT 
    SUM(cost_usd) AS total_cost_usd,
    SUM(prompt_tokens + completion_tokens) AS total_tokens
FROM llm_calls;
--
-- Yorum:
-- Sistem genelinde tüketilen toplam girdi ve çıktı token hacmi ile buna karşılık gelen 
-- kümülatif harcama miktarını gösterir; böylece operasyonun toplam bütçe tüketimi ve model 
-- kullanım yoğunluğu doğrudan takip edilebilir.


-- Soru 4: Ortalama gecikme (bir ondalık basamağa yuvarlanmış)
SELECT ROUND(AVG(latency_ms), 1) AS avg_latency
FROM llm_calls;
--
-- Yorum:
-- Sistemdeki tüm LLM çağrılarının yanıt verme sürelerinin ortalamasını tek ondalık 
-- hassasiyetle sunarak servis sağlayıcıların genel hız performansını özetler. 
-- Bu referans değer, özellikle gecikmesi kabul edilebilir sınırların üzerinde kalan 
-- uç değerleri (outlier) ve yavaş çalışan modelleri tespit etmek için temel eşik olarak kullanılır.


-- Soru 5: En hızlı ve en yavaş çağrı
SELECT 
    MIN(latency_ms) AS fastest_ms,
    MAX(latency_ms) AS slowest_ms
FROM llm_calls;
--
-- Yorum:
-- Sistemdeki çağrıların gecikme süresi aralığını (en iyi ve en kötü durum sınırlarını) gösterir; 
-- en hızlı yanıt ile en yavaş yanıt arasındaki farkın büyüklüğü, model karmaşıklığı ya da 
-- ağ/üretim kaynaklı performans dalgalanmalarının boyutunu ortaya koyar.


-- Soru 6: Her iş türünde (task_type) kaç çağrı var?
SELECT 
    task_type,
    COUNT(*) AS call_count
FROM llm_calls
GROUP BY task_type;
--
-- Kaç satır döndü? 5
-- Neden o kadar? Tabloda tekrarsız 5 farklı iş türü (summarize, code, classify, chat, translate) 
-- bulunmaktadır; GROUP BY her benzersiz task_type değerini tek bir satırda topladığı için 
-- tam olarak benzersiz kategori sayısı kadar satır dönmüştür.
--
-- Yorum:
-- Bu sorgu sistemdeki çağrı yükünün görev türlerine göre dağılımını gösterir; en çok hangi 
-- amaçla LLM kullanıldığını belirleyerek kaynak ve maliyet optimizasyonuna odaklanılacak 
-- kritik iş kollarını ortaya çıkarır.


-- Soru 7: Her model için çağrı sayısı ve toplam maliyet, pahalıdan ucuza
SELECT 
    model_name,
    COUNT(*) AS call_count,
    SUM(cost_usd) AS total_cost_usd
FROM llm_calls
GROUP BY model_name
ORDER BY total_cost_usd DESC;
--
-- Yorum:
-- Hangi yapay zeka modelinin ne sıklıkla tercih edildi