# Ödev Raporu


---

**Ödev no:** Ödev 01      **Hafta:** 5      **Tarih:** 22 / 10 / 2026

**Ad Soyad:** ___Muhammet Günal  **Öğrenci No:** 202607131022
**Program:**  ☑ Yapay Zeka Operatörlüğü  ☐ Robotik ve Yapay Zeka

**Kullandığım veritabanı:** ☑ `llm_ops`  ☐ `robot_fleet`

**PR bağlantısı:** https://github.com/mtgunall-cloud/db-project/pull/1

**Commit sayısı:** 5

---

## 1. Ne yaptım

Bu ödev kapsamında `llm_calls` tablosu üzerinde filtreleme, çoklu sıralama ve toplulaştırma (aggregation) fonksiyonlarını pratik ederek yapay zeka operasyon metriklerini analiz etmeyi öğrendim. `GROUP BY` ve `HAVING` yapılarıyla modellerin çağrı yüklerini, maliyet dağılımlarını ve filtreleme sırası (WHERE vs HAVING) mantığını pekiştirdim. Ayrıca SQL'de `NULL` değerlerin üç değerli mantık (Three-Valued Logic) yapısını, eksik verilerin ortalama hesaplamalarındaki saptırıcı etkisini ve `CASE WHEN` kullanarak ham sayısal verileri işlevsel performans segmentlerine dönüştürmeyi deneyimledim.

---

## 2. Sonuçlar

Çözdüğüm soru sayısı: 30 / 30     Bonus: ☐ denedim ☑ denemedim

En zorlandığım soru: **Bölüm 4 - Soru 10**

Neden zorlandım:
Gruplama öncesi satır bazlı filtreleme (`WHERE latency_ms > 500`) ile gruplama sonrası kümeleme filtrelemesinin (`HAVING COUNT(*) >= 2`) birlikte kullanımında işlem önceliği sırasını ve koşulların birbirini nasıl etkilediğini kurgulamakta başlangıçta tereddüt yaşadım.

Nasıl çözdüm:
SQL çalıştırma mantığını adım adım inceledim: Önce `WHERE` ile hızlı kayıtların elendiğini, ardından kalan kayıtların `GROUP BY model_name` ile kümelendiğini ve son olarak `HAVING` ile çağrı adedi 2'den az olan modellerin filtrelendiğini test ederek doğru sonuca ulaştım.

---

## 3. Beklemediğim bir sonuç

Bir sorgu beklediğinden farklı sayıda satır döndürdü mü? Hangisi ve neden?

**Soru no:** Bölüm 4 - Soru 8

**Beklediğim:** 4 satır   **Gelen:** 5 satır

**Sebebi:**
Sadece sistemde kayıtlı 4 kullanıcının (Deniz, Ece, Mert, Oğuz) sonuç getireceğini düşünmüştüm. Ancak 12 numaralı çağrıda `user_name` değeri `NULL` olduğu ve SQL'de `GROUP BY` NULL değerleri yok saymayıp ayrı bir kategori olarak ele aldığı için sonuç tablosuna `NULL | code | 1` şeklinde fazladan bir satır eklendi.

---

## 4. Aldığım bir hata ve çözümü

Dönem boyunca hata mesajı okumayı öğreniyoruz. Bu hafta aldığın bir hatayı yaz.

**Hata mesajı:**
`ERROR: aggregate functions are not allowed in WHERE` (veya `misuse of aggregate function COUNT()`)

**Sebebi ve çözümü:**
Soru 9'da ikiden fazla çağrısı olan modelleri listelerken koşulu yanlışlıkla `WHERE COUNT(*) > 2` şeklinde yazdım. `WHERE` bloğunun gruplamadan önce satır satır çalıştığını ve toplulaştırma (aggregate) fonksiyonlarını kabul etmediğini fark edip, kümeleme koşulunu `HAVING COUNT(*) > 2` bloğuna taşıyarak hatayı giderdim.

---

## 5. Yapay zeka kullanım beyanı

☐ Bu ödevde yapay zeka aracı **kullanmadım.**

☑ Kullandım, aşağıda belirttim:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
|---|---|---|---|
| B4 - S12 | LLM (Claude / Gemini) | `cost_usd = NULL` neden sonuç vermez de `IS NULL` gerekir? | Veritabanında her iki sorguyu çalıştırdım; ilki 0 satır verirken mantıksal üç değerli yapıyı inceleyerek doğruladım. |
| B4 - S13 | LLM (Claude / Gemini) | Ortalama gecikmede COALESCE ile 0 vermenin sakıncası nedir? | Sorgu çıktısındaki iki ortalamayı karşılaştırdım; eksik ölçümü 0 saymanın ortalamayı yapay düşürdüğünü matematiksel olarak gördüm. |
| B4 - S15 | LLM (Claude / Gemini) | CASE WHEN aralıklarının GROUP BY içinde gruplanma sözdizimi | Yazılan sorguyu terminalde çalıştırdım; dönen satır sayısı ve kategori gecikmelerini tablodaki ham verilerle eşleştirdim. |

---

## 6. Öz değerlendirme

Rubriğe ([RUBRIK.md](../RUBRIK.md)) göre kendine bir seviye ver. Bu puanını etkilemez.

| Ölçüt | 4 Tam | 3 İyi | 2 Gelişmeli | 1 Yetersiz |
|---|---|---|---|---|
| A, Doğruluk | ☑ | ☐ | ☐ | ☐ |
| B, SQL kalitesi | ☑ | ☐ | ☐ | ☐ |
| C, Yorum ve analiz | ☑ | ☐ | ☐ | ☐ |
| D, Git ve PR disiplini | ☐ | ☑ | ☐ | ☐ |
| E, Dürüstlük ve beyan | ☑ | ☐ | ☐ | ☐ |

Bir dahaki ödevde daha iyi yapacağım şey:
Git commit mesajlarımı her soruyu çözdükçe daha sık, atomik ve açıklayıcı formatta atmaya özen göstereceğim.

---

## 7. Bana sorun

Anlamadığın, merak ettiğin ya da derste tekrar görmek istediğin bir konu:
Büyük veri tabanlarında milyonlarca satır içeren tablolarda `GROUP BY` ve `HAVING` filtrelerinin indeks kullanımı (B-Tree/Hash Index) ile performans optimizasyonunun pratikte nasıl yapıldığını derste görmeyi çok isterim.

---

**İmza:** ________________________

---

*Doğruluk beyanı: Bu çalışmayı kendim yaptım. Kullandığım tüm yardımcı kaynakları ve yapay zeka araçlarını yukarıda beyan ettim.*