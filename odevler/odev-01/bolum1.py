# Soru 1.1 - İz Sürme

numbers = [4, 7, 2, 9, 5, 1, 8]
total = 0
result = []

for i in range(len(numbers)):
    if numbers[i] % 2 == 0:
        total = total + numbers[i]
    else:
        result.append(numbers[i])

print(total)
print(result)

# Tablo:
# i = 0 -> sayı: 4 (çift) -> total = 4,  result = []
# i = 1 -> sayı: 7 (tek)  -> total = 4,  result = [7]
# i = 2 -> sayı: 2 (çift) -> total = 6,  result = [7]
# i = 3 -> sayı: 9 (tek)  -> total = 6,  result = [7, 9]
# i = 4 -> sayı: 5 (tek)  -> total = 6,  result = [7, 9, 5]
# i = 5 -> sayı: 1 (tek)  -> total = 6,  result = [7, 9, 5, 1]
# i = 6 -> sayı: 8 (çift) -> total = 14, result = [7, 9, 5, 1]
#
# Sonuç: Kodu çalıştırdığımda total 14, result ise [7, 9, 5, 1] çıktı. Tahminim tuttu.


# =====================================================================
# Soru 1.2 - En Uzun Seri
# =====================================================================

# Sözde Kod (Pseudocode):
# 1. current_streak = 0  (mevcut kesintisiz seri sayacı)
# 2. max_streak = 0      (en uzun seri rekoru)
# 3. readings listesindeki her bir 'val' elemanı için:
# 4.     Eğer val > threshold ise:
# 5.         current_streak'i 1 artır
# 6.         Eğer current_streak > max_streak ise:
# 7.             max_streak = current_streak
# 8.     Değilse (val <= threshold):
# 9.         current_streak'i 0 yap (seri kesintiye uğradı)
# 10. Döngü bittiğinde max_streak değerini ekrana yazdır.

readings = [18, 21, 23, 25, 24, 26, 27, 19, 20, 22, 23, 24, 25, 26]
threshold = 22

current_streak = 0
max_streak = 0

for val in readings:
    if val > threshold:
        current_streak = current_streak + 1
        if current_streak > max_streak:
            max_streak = current_streak
    else:
        current_streak = 0

print(max_streak)

# İzleme Tablosu:
# val = 18 -> (18 > 22 False) -> current_streak = 0, max_streak = 0
# val = 21 -> (21 > 22 False) -> current_streak = 0, max_streak = 0
# val = 23 -> (23 > 22 True)  -> current_streak = 1, max_streak = 1
# val = 25 -> (25 > 22 True)  -> current_streak = 2, max_streak = 2
# val = 24 -> (24 > 22 True)  -> current_streak = 3, max_streak = 3
# val = 26 -> (26 > 22 True)  -> current_streak = 4, max_streak = 4
# val = 27 -> (27 > 22 True)  -> current_streak = 5, max_streak = 5  (1. seri bitti: 5)
# val = 19 -> (19 > 22 False) -> current_streak = 0, max_streak = 5
# val = 20 -> (20 > 22 False) -> current_streak = 0, max_streak = 5
# val = 22 -> (22 > 22 False) -> current_streak = 0, max_streak = 5  (eşik dahil değil)
# val = 23 -> (23 > 22 True)  -> current_streak = 1, max_streak = 5
# val = 24 -> (24 > 22 True)  -> current_streak = 2, max_streak = 5
# val = 25 -> (25 > 22 True)  -> current_streak = 3, max_streak = 5
# val = 26 -> (26 > 22 True)  -> current_streak = 4, max_streak = 5
#
# Sonuç: Kod çalıştırıldığında ekrana 5 basar. En uzun kesintisiz seri [23, 25, 24, 26, 27] grubudur.



# =====================================================================
# Soru 1.3 - Elle Gruplama
# =====================================================================

records = [
    {"student": "Ece", "course": "VTYS"},
    {"student": "Ali", "course": "Yapay Zeka"},
    {"student": "Ece", "course": "Yapay Zeka"},
    {"student": "Can", "course": "VTYS"},
    {"student": "Ali", "course": "VTYS"},
    {"student": "Ece", "course": "Robotik"},
]

course_counts = {}

for row in records:
    c = row["course"]
    if c in course_counts:
        course_counts[c] = course_counts[c] + 1
    else:
        course_counts[c] = 1

print(course_counts)

# İzleme Tablosu:
# 1. Kayıt: {'student': 'Ece', 'course': 'VTYS'}       -> 'VTYS' sözlükte yok       -> course_counts = {'VTYS': 1}
# 2. Kayıt: {'student': 'Ali', 'course': 'Yapay Zeka'} -> 'Yapay Zeka' sözlükte yok -> course_counts = {'VTYS': 1, 'Yapay Zeka': 1}
# 3. Kayıt: {'student': 'Ece', 'course': 'Yapay Zeka'} -> 'Yapay Zeka' var (+1)     -> course_counts = {'VTYS': 1, 'Yapay Zeka': 2}
# 4. Kayıt: {'student': 'Can', 'course': 'VTYS'}       -> 'VTYS' var (+1)           -> course_counts = {'VTYS': 2, 'Yapay Zeka': 2}
# 5. Kayıt: {'student': 'Ali', 'course': 'VTYS'}       -> 'VTYS' var (+1)           -> course_counts = {'VTYS': 3, 'Yapay Zeka': 2}
# 6. Kayıt: {'student': 'Ece', 'course': 'Robotik'}    -> 'Robotik' sözlükte yok    -> course_counts = {'VTYS': 3, 'Yapay Zeka': 2, 'Robotik': 1}
#
# Sonuç: {'VTYS': 3, 'Yapay Zeka': 2, 'Robotik': 1}
#
# Rapor Cümlesi (SQL GROUP BY Benzerliği):
# Python'da sözlük anahtarları üzerinden if/else ile yaptığımız frekans sayımı işlemi, SQL'deki "GROUP BY course" ifadesinin her benzersiz ders grubunu kümeleyip "COUNT(*)" ile o grubun satır adedini toplaması mantığıyla birebir aynı çalışır.