# Bölüm 2: Veritabanı Kavramları

### 1. Excel vs Veritabanı (Üç Somut Sorun ve Çözümü)
Excel'de veri boyutu yüz binlerce satıra ulaştığında dosya aşırı yavaşlar ve kilitlenirken, veritabanları indeksleme ve disk optimizasyonu sayesinde milyonlarca satırı saniyeler içinde işler. Birden fazla çalışan aynı Excel dosyasını eşzamanlı düzenlemeye çalıştığında veri çakışması ve kayıplar yaşanır; veritabanları ise eşzamanlılık (concurrency) mekanizmalarıyla bu işlemi güvenle yönetir. Ayrıca Excel'de bir hücreye yanlış veri tipi girilmesini veya mükerrer kayıtları engellemek zordur; veritabanları kısıtlamalar (constraints, primary key, foreign key) ile veri bütünlüğünü garanti altına alır.

### 2. Birincil Anahtar (Primary Key)
Birincil anahtar, tablodaki her bir satırı benzersiz biçimde tanımlayan, asla boş (NULL) olamayan ve tekrarlanamayan tekil alandır. Öğrenci numarası her öğrenciye özel ve değişmez olarak tanımlandığı için mükemmel bir birincil anahtardır. Ad-soyad ise aynı okulda aynı isim ve soyisme sahip birden fazla öğrenci bulunabileceğinden ve zamanla isim/soyisim değişiklikleri olabileceğinden birincil anahtar olarak kullanılamaz.

### 3. DBMS (Veritabanı Yönetim Sistemi) ile Veritabanı Farkı
Veritabanı, birbiriyle ilişkili verilerin disk üzerinde organize şekilde depolandığı yapılandırılmış koleksiyondur. Veritabanı Yönetim Sistemi (DBMS) ise bu verilere güvenli erişim sağlayan, sorguları çalıştıran, yedekleme ve kullanıcı yetkilendirmelerini yöneten yazılım motorudur. PostgreSQL, bu verileri yönetmek, işlemek ve korumak için kullanılan ilişkisel bir Veritabanı Yönetim Sistemi'dir (RDBMS).

### 4. Eşzamanlı Değişiklik Çakışması
Aynı anda iki kişi aynı kaydı değiştirmeye kalktığında, bir veritabanı kilit (lock) ve işlem (transaction) mekanizmaları sayesinde bu istekleri sıraya koyarak verinin bozulmasını veya son yazanın diğerinin verisini ezmesini (lost update) önler.