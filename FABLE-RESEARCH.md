# FABLE Araştırma Notu 01 — Kapasite Transferi

**Tarih: 7 Temmuz 2026 · Yazan: Claude Fable 5 · Durum: bulgular v1.0'da uygulandı**

## Soru

Bir modelin kapasitesi başka bir modele ne kadar taşınabilir? "Kopyalanamaz" cevabı doğru ama eksik — kapasitenin *katmanları* var ve bazı katmanlar veriye dönüştürülebilir.

## Bulgular: üç taşınabilir katman

**Katman 1 — Süreç/disiplin** *(uygulandı: `FABLE-MODE.md` + `FABLE-MODE-MINI.md`)*
Kalite kaybının en büyük kaynağı atlanan adımlardır: okunmayan dosya, doğrulanmayan iddia, üretilmeden yamalanan bug. Protokol atlamayı yasaklar. Taşıma oranı: yüksek — çünkü disiplin zekâ gerektirmez, itaat gerektirir.

**Katman 2 — Bilgi/sezgi** *(uygulandı: `FABLE-PACKS/` — 8 alan paketi + `deep-research` eskalasyon modülü)*
"Uzman sezgisi" büyük ölçüde örüntü kataloğudur: *bu belirtiyi gördüm → şu 5 sebepten biridir.* Mekanizma şu: bir modelin **bağlamından okuduğu** bilgi, **ağırlıklarından hatırladığı** bilgiden daha güvenilirdir (in-context > parametric recall). Büyük modelin avantajlarından biri bu katalogların daha zengini ve daha güvenilir geri çağrılanıdır — kataloğu yazıya döküp küçük modelin bağlamına koyunca, o avantajın bir kısmı *veri olarak* taşınır. Paketler tam olarak budur: Fable 5'in alan sezgilerinin katalog hali.

**Katman 3 — İskelet ve örnekler** *(uygulandı: `general.md` iskeletleri + `FABLE-EXAMPLES/` altın örnekleri)*
İki mekanizma: (a) **iskeletler** — "3 aday üret → eleştir → seç", "taslak → düşman gözüyle eleştiri → revizyon" gibi şablonlar, modelin tek geçişte açığa çıkaramadığı gizli kapasitesini çok geçişte açığa çıkarır; (b) **altın örnekler** — modeller örneği güçlü taklit eder; `FABLE-EXAMPLES/` içindeki üç tam çözüm (debug seansı, mimari karar, kod incelemesi) bu yüzden var: sürecin *uygulanmış hali* davranışı yukarı çeker.

## Taşınamayanlar (dürüstlük sınırı)

- **Akışkan muhakeme derinliği:** hiç görülmemiş, çok katmanlı problemlerde zincirin kopmadan uzaması.
- **Çalışma belleği genişliği:** uzun bir oturumda çok sayıda kısıtı aynı anda tutabilme. (Küçük modelde belirti: protokolün ruhu kaybolur, ritüeli kalır.)
- **Yenilik karşısında zevk/sağduyu:** kural listesi olmayan durumlarda doğru içgüdü.
Bunlar ağırlıklarda yaşar; hiçbir dosya bunları eklemez. Paketlerin işi bu açığı *kapatmak* değil, *daraltmak*tır.

## Beklenen etki (modele göre)

| Model | Beklenen kazanç |
|---|---|
| Opus | En yüksek mutlak kalite — protokolü ve paketleri tam derinlikte uygular |
| Sonnet | En iyi fiyat/performans — günlük iş için önerilen ikili |
| Haiku | En büyük *göreli* sıçrama (en çok disiplin hatasını o yapar) ama en düşük tavan; MINI + tek paket önerilir |

## Ölçüm

İddiaya değil teste güven: `FABLE-EVAL.md` — 6 sabit görev, puanlama cetveli ve cevap anahtarlarıyla kör A/B protokolü (aynı model, mod açık/kapalı). Farkın en büyük görünmesi beklenen yerler: debug (T1), inceleme (T2) ve eksiksizlik (T5).

## Yol haritası — v1.1

1. **Stack'e özel paketler:** kullandığın teknolojilere göre (ör. React, Python, belirli framework'ler) belirti→neden katalogları.
2. **Örnek kütüphanesini büyütme:** her pakete eşlik eden bir altın örnek (şu an 3 örnek var).
3. **Topluluk katkıları ve çeviriler:** GitHub'da yayınlandıktan sonra (`GITHUB-PUBLISH.md`) eval sonuçları toplamak — olumsuz sonuçlar da veri.

## Yeni paket nasıl üretilir

Herhangi bir güçlü Claude modeline şunu de: *"`FABLE-PACKS/` içindeki dosyaların formatında, X alanı için bir paket yaz: belirti→neden kataloğu, sayısal referans değerleri, uzman kontrol listesi — genel tavsiye değil, uzman örüntü belleği."* Sonra `FABLE-PACKS/` klasörüne koy; `CLAUDE.md` kuralı onu otomatik kapsar. Format kuralları: `CONTRIBUTING.md`.
