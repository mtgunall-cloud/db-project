-- Soru 1: Bütün çağrıların id'sini ve model adını listele
SELECT id, model_name
FROM llm_calls;
-- 12 satır döndü.

-- Soru 2: Model adını model, toplam token sayısını (prompt + completion) total_tokens başlığıyla göster
SELECT model_name AS model, (prompt_tokens + completion_tokens) AS total_tokens
FROM llm_calls;
-- 12 satır döndü.


-- Soru 3: Gecikmesi 2 saniyeyi aşan çağrılar (latency_ms > 2000)
SELECT *
FROM llm_calls
WHERE latency_ms > 2000;
-- 5 satır döndü.


-- Soru 4: Ece'nin yaptığı çağrılar
SELECT *
FROM llm_calls
WHERE user_name = 'Ece';
-- 3 satır döndü.


-- Soru 5: Sohbet (chat) dışındaki çağrılar
SELECT *
FROM llm_calls
WHERE task_type != 'chat';
-- 9 satır döndü.


-- Soru 6: Adı claude ile başlayan modellere yapılan, 1 saniyeden yavaş çağrılar
SELECT *
FROM llm_calls
WHERE model_name LIKE 'claude%' AND latency_ms > 1000;
-- 2 satır döndü.


-- Soru 7: Kod veya çeviri işi olan, maliyeti 0.01 doları aşan çağrılar
SELECT *
FROM llm_calls
WHERE (task_type = 'code' OR task_type = 'translate') AND cost_usd > 0.01;
-- 3 satır döndü.
--
-- Açıklama:
-- Parantez koyulmadığında 4 satır döndü (1 satır fark etti).
-- Neden: SQL'de AND operatörünün işlem önceliği OR operatöründen yüksektir. Parantez
-- kullanılmadığında sorgu 'translate AND cost_usd > 0.01' kısmını önce değerlendirir;
-- bu da maliyeti şartı sağlamasa bile bütün 'code' işlerinin sorguya kontrolsüzce
-- dahil olmasına yol açar.


-- Soru 8: Gecikmesi 500 ile 1500 ms arasındaki çağrılar
SELECT *
FROM llm_calls
WHERE latency_ms BETWEEN 500 AND 1500;
-- 4 satır döndü.
--
-- Açıklama:
-- BETWEEN operatörü sınır değerleri dahil kabul eder (latency_ms >= 500 AND latency_ms <= 1500).
-- Tabloda bu aralığa giren kayıtlar: id 5 (900 ms), id 6 (1100 ms), id 9 (450 ms elenir), 
-- id 12 (700 ms) gibi kayıtlardan toplam 4 tanesidir.


-- Soru 9: GPT ailesine (gpt-4o, gpt-4o-mini) yapılan çağrılar
SELECT *
FROM llm_calls
WHERE model_name IN ('gpt-4o', 'gpt-4o-mini');
-- 4 satır döndü.
--
-- Açıklama:
-- IN operatörü belirtilen liste içindeki herhangi bir değere eşit olan kayıtları filtreler.
-- Tabloda gpt-4o için 3 kayıt (id: 1, 4, 11) ve gpt-4o-mini için 1 kayıt (id: 9) olmak üzere 
-- toplam 4 satır listelenir.


-- Soru 10: Model adında "mini" geçen çağrılar
SELECT *
FROM llm_calls
WHERE model_name LIKE '%mini%';
-- 1 satır döndü.
--
-- Kaç satır bekliyordun? 1
-- Kaç geldi? 1
-- Fark varsa neden? Fark yok. Veritabanındaki 12 çağrı kaydı incelendiğinde adında 
-- "mini" ifadesi geçen tek kayıt 9 numaralı çağrıdır (model_name = 'gpt-4o-mini'). 
-- 'gemini' modelleri (gemini-flash, gemini-pro) mini ifadesini içermediği için 
-- beklenen ile gelen satır sayısı birebir eşleşmektedir.


-- Soru 11: Önce kullanıcıya, kullanıcı içinde maliyete (pahalıdan ucuza) göre sırala
SELECT *
FROM llm_calls
ORDER BY user_name ASC, cost_usd DESC;
-- 12 satır döndü.
--
-- Açıklama:
-- ORDER BY ifadesinde birden fazla sütun virgülle ayrılarak öncelik sırasına göre yazılır.
-- İlk kriter olan 'user_name ASC' kullanıcı isimlerini alfabetik (A'dan Z'ye) sıralar.
-- İkinci kriter olan 'cost_usd DESC' ise aynı kullanıcıya ait kayıtları kendi içinde 
-- en yüksek maliyetten en düşüğe (pahalıdan ucuza) doğru dizer.
-- Filtreleme (WHERE) olmadığı için tablodaki 12 kaydın tamamı sıralı olarak listelenir.


-- Soru 12: En pahalı 3 çağrı
SELECT *
FROM llm_calls
ORDER BY cost_usd DESC
LIMIT 3;
-- 3 satır döndü.
--
-- Açıklama:
-- 'ORDER BY cost_usd DESC' ifadesi çağrıları maliyetine göre en yüksekten en düşüğe 
-- doğru sıralar. 'LIMIT 3' ise bu sıralı listenin başındaki ilk 3 kaydı getirir.
-- Tablodaki en yüksek maliyetli ilk 3 kayıt döner (id: 7 [0.0243], id: 2 [0.0141], id: 4 [0.0114]).


-- Soru 13: Hangi iş türleri (task_type) var?
SELECT DISTINCT task_type
FROM llm_calls;
-- 4 satır döndü.
--
-- Açıklama:
-- DISTINCT anahtar kelimesi, tablodaki tekrarlayan değerleri tekile indirgeyerek 
-- yalnızca benzersiz olan kayıtları listeler.
-- llm_calls tablosunda bulunan benzersiz iş türleri: 'summarize', 'code', 'classify', 'chat', 'translate'.


-- Soru 14: Kullanıcı adlarını doğru Türkçe alfabe sırasıyla, tekrarsız listele
SELECT DISTINCT user_name
FROM llm_calls
WHERE user_name IS NOT NULL
ORDER BY user_name COLLATE "tr-TR-x-icu" ASC;
-- 4 satır döndü.
--
-- Açıklama ve Karşılaştırma:
-- Veritabanındaki benzersiz kullanıcılar: Deniz, Ece, Mert, Oğuz (NULL hariç).
--
-- 1. COLLATE Kullanılmadığında (Standart ASCII / Binary Sıralama):
--    Sıralama: Deniz, Ece, Mert, Oğuz
--    (ASCII tablosunda İngilizce dışındaki Türkçe karakterler 'O' harfinden sonra 
--    veya en sonda yer aldığı için 'Oğuz' ismi beklenmedik şekilde listenin sonuna düşer).
--
-- 2. COLLATE "tr-TR-x-icu" Kullanıldığında (Doğru Türkçe Sıralama):
--    Sıralama: Deniz, Ece, Mert, Oğuz
--    ('O' harfi alfabede M'den sonra, P/R'den önce doğru sıraya oturur).
--
-- Hangi isimler yer değiştirdi?
-- ASCII/UTF-8 byte sıralamasında Türkçe "Ğ" harfi standart Latin karakterlerinden 
-- sonra geldiği için 'Oğuz' ismi yerel ayarlara bağlı olarak listenin en sonuna 
-- kayarken, Türkçe harmanlama (Collation) ile alfabetik olarak Mert'in arkasındaki 
-- doğru yerine oturmuştur.


-- Soru 15: "14 Ekim'den sonra yapılan, 1 saniyeden yavaş çağrıların id'sini, modelini ve gecikmesini, en yavaştan başlayarak listele."
--
-- Dört Adım Analizi:
-- 1. Tablo:   llm_calls
-- 2. Sütunlar: id, model_name, latency_ms
-- 3. Koşul:   created_at >= '2026-10-15' AND latency_ms > 1000
-- 4. Sıra:    ORDER BY latency_ms DESC (en yavaştan başlayarak)

SELECT id, model_name, latency_ms
FROM llm_calls
WHERE created_at >= '2026-10-15' AND latency_ms > 1000
ORDER BY latency_ms DESC;
-- 4 satır döndü.
--
-- Açıklama:
-- 14 Ekim gününden sonra yapılan (15 ve 16 Ekim tarihli) ve gecikmesi 1 saniyeyi 
-- (1000 ms) aşan çağrılar filtrelenmiştir:
-- id 7:  4100 ms (claude-sonnet)
-- id 8:  2300 ms (llama-3-8b)
-- id 10: 1900 ms (gemini-pro)
-- id 11: 1800 ms (gpt-4o)
-- Kayıtlar en yüksek gecikmeden (en yavaş) en düşüğe doğru sıralanmıştır.