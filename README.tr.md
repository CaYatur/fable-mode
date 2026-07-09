# ⚡ FABLE MODE

> **Herhangi bir Claude modelini maksimum titizlikte çalıştırır. Tek tetik kelimesi: `fable`.**

**Sürüm: 1.0.1** · MIT · **[🇬🇧 English](README.md)**

## Bu nedir?

Bir Claude modeline (Sonnet, Opus, Haiku…) *"fable"* dediğinizde devreye giren maksimum titizlik sistemi. İki katmandan oluşur:

1. **Protokol** (`FABLE-MODE.md` FULL / `FABLE-MODE-MINI.md` MINI) — modelin *nasıl çalıştığını* değiştirir: cevaplamadan önce anlama, yazmadan önce okuma, sistematik debug (yeniden üret → katmanlar arası hipotezler → mekanizmayı düzelt → kanıtla), edge-case matrisi, "bitti" demeden doğrulama, kalibre dil ("doğruladım" ≠ "çalışması lazım" ≠ "sanıyorum").
2. **Uzmanlık paketleri** (`FABLE-PACKS/`) — uzman sezgisi büyük ölçüde örüntü kataloğudur: *bu belirtiyi görürsen şu 5 sebebe bak.* Kataloglar yazıya dökülüp bağlama konunca model onları hatırlamaya çalışmak yerine **okur** — ve bağlamdan okumak, ağırlıklardan hatırlamaktan daha güvenilirdir. Kapasitenin veriye dönüşen kısmı budur (ayrıntı: `FABLE-RESEARCH.md`).

## Dürüst bir not

Hiçbir prompt bir modeli olduğundan daha zeki yapamaz. Akışkan muhakeme derinliği, çalışma belleği genişliği ve yenilik karşısında sağduyu ağırlıklarda yaşar — dosyayla taşınmaz. Ama pratikte kalite farkının büyük kısmı **atlanan süreçten** ve **geri çağrılamayan bilgiden** gelir; bunlar taşınır. Söze de güvenmeyin: `FABLE-EVAL.md` kör A/B testi içindir — kendi modelinizde çalıştırın.

## Dosyalar

| Dosya | Ne işe yarar |
|---|---|
| `FABLE-MODE.md` | Tam protokol (FULL) — 12 bölüm; tek başına paylaşılabilir |
| `FABLE-MODE-MINI.md` | Özet protokol (MINI) — küçük/hızlı modeller ve karakter limitli yerler için |
| `FABLE-PACKS/` | 9 uzmanlık paketi (8 alan + 1 deep-research eskalasyonu, aşağıda) |
| `FABLE-EXAMPLES/` | 3 altın örnek: debug seansı, mimari karar, kod incelemesi — modeller örneği taklit eder |
| `FABLE-EVAL.md` | Kör A/B değerlendirme: 6 görev, puanlama cetveli, cevap anahtarları |
| `FABLE-RESEARCH.md` | Araştırma notu: kapasite transferi nasıl çalışır, sınırları, yol haritası |
| `CLAUDE.md` | Bu klasörde Claude Code'un tetikleyicileri otomatik tanımasını sağlar |
| `.claude/skills/fable/SKILL.md` | Claude Code'da `/fable` komutu |
| `claude-web-skill/` | claude.ai'ye yüklenebilir skill paketinin kaynağı + derleme scriptleri (`dist/fable-skill.zip` üretir) |
| `GITHUB-PUBLISH.md` | GitHub'a yükleme kiti: repo adı, açıklama, etiketler, komutlar |
| `CONTRIBUTING.md` / `LICENSE` | Katkı kuralları / MIT lisansı |
| `README.md` / `README.tr.md` | İngilizce (GitHub vitrini) / bu rehber |

## Kullanım

| Yazdığın | Ne olur |
|---|---|
| `fable` | Model kendini tanıtır, hangi sürümü **kendisinin** daha güvenilir uygulayabildiğini dürüstçe söyler ve sorar: *"FULL mü, MINI mi?"* — son söz senin |
| `fable full` | Soru sorulmaz, FULL açılır |
| `fable mini` | Soru sorulmaz, MINI açılır |
| `fable debugging` (veya başka paket adı) | Modelin önerdiği sürüm + o paket açılır |
| `fable deep` | **Araştırma modu** — senin de modelin de normalde çözemediği, sebebi bilinmeyen problemler için. Çıktı hızlı cevap değil, araştırma günlüğü olur (kanıtlı gerçekler / elenenler / sıralı hipotezler / denetlenmemiş varsayımlar) ve oturumlar arası devredilebilir |
| `fable off` | Mod kapanır |

Onay satırı her zaman sabit ve İngilizce kalır (protokolün rozeti gibi, kod/commit mesajları gibi): `⚡ Fable Mode active (FULL|MINI + pack) — <model adı>`. FULL modda model işe uyan paketi kendiliğinden okur. Tetikleyiciler tek bir sabit ifadeyle sınırlı değil — "Fable 5 gibi davran / analiz et" gibi doğal Türkçe cümleler de, anlamından tanınarak tetikler. Onay satırı dışındaki her şeyi model senin dilinde yazar.

**Kurulum testi:** yeni bir sohbet açın, sadece `fable` yazın — model kendini tanıtıp FULL/MINI sorusunu soruyorsa kurulum çalışıyor demektir.

## Paketler

| Paket | İçerik |
|---|---|
| `debugging` | 12 belirti sınıfı için belirti→şüpheli kataloğu, ikili arama taktikleri, hata öncelik sıralaması |
| `performance` | Gecikme sayıları tablosu (bütçe aritmetiği), belirti→hastalık→tedavi kataloğu, optimizasyon merdiveni |
| `architecture` | Tek/çift yönlü kapı kararları, önce-veri ilkesi, önce-hata tasarımı, bağlaşım kokuları |
| `security` | Kod kokusu→zafiyet→çözüm tablosu, web özelleri, değişiklik başına kontrol listesi |
| `code-quality` | Uzman reviewer'ın yakaladıkları, test doktrini, refactor güvenliği |
| `data-sql` | NULL tuzakları, index kuralları, sorgu kokuları, transaction yarışları, EXPLAIN okuma |
| `design` | Tasarım token'ları, hiyerarşi, boşluk/renk sistemleri, dark mode, grafik kuralları, "amatör işareti→düzeltme" tablosu, cila kontrol listesi |
| `general` | Kod dışı akıl yürütme: say-seç, taslak→eleştiri→revizyon, Fermi tahmini, kalibrasyon |
| `deep-research` | **Eskalasyon modülü** — sebebi bilinmeyen problemler: varsayım denetimi, iki-dünya kıyası, hipotez kafesi, araştırma günlüğü disiplini; "henüz bilmiyorum"un titiz hali |

Yeni paket üretme talimatı `FABLE-RESEARCH.md`'nin sonunda.

## Kurulum

### 0) Bu klasör (hazır ✅)

Bu dizinde Claude Code ile çalışırken hiçbir şey yapmanıza gerek yok — `CLAUDE.md` sistemi her modele tanıtır. Sadece `fable` yazın.

### 1) Claude Code — tüm projelerde (önerilen)

**Windows (PowerShell):**

```powershell
Copy-Item .\FABLE-MODE.md, .\FABLE-MODE-MINI.md "$env:USERPROFILE\.claude\"
Copy-Item -Recurse -Force .\FABLE-PACKS "$env:USERPROFILE\.claude\FABLE-PACKS"
Add-Content -Encoding utf8 "$env:USERPROFILE\.claude\CLAUDE.md" @'

## Fable Mode
If the user says "fable", "fable mode", "act like Fable", or "/fable" (any casing, any language):
- Bare trigger: state your real model name, say honestly which version YOU can execute more reliably (Opus/Sonnet-class -> FULL at ~/.claude/FABLE-MODE.md; Haiku-class/fast tier -> MINI at ~/.claude/FABLE-MODE-MINI.md), then ask "FULL or MINI?" (in the user's own language) and list the packs in ~/.claude/FABLE-PACKS. The user's choice wins.
- "fable full" -> FULL; "fable mini" -> MINI; "fable <pack>" -> recommended version + that pack. Read the chosen file(s) and follow them for the rest of the session; in FULL, auto-read the pack matching the task.
- Announce with one line: "Fable Mode active (FULL|MINI) — <your real model name>" prefixed with a lightning emoji. Deactivate only on "fable off". Always reply and generate content in whatever language the user addresses you in.
'@
```

**macOS / Linux:** aynı bloğu `README.md`'deki (İngilizce) bash komutlarıyla uygulayın.

İsteğe bağlı — `/fable` komutunu tüm projelerde kullanmak için:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\skills\fable" | Out-Null
Copy-Item .\.claude\skills\fable\SKILL.md "$env:USERPROFILE\.claude\skills\fable\SKILL.md"
```

### 2) claude.ai (web ve mobil)

**Yöntem A — Skill olarak yükleme (önerilen: her sohbette çalışır, proje gerektirmez):**

1. Zip paketini üretin (hazır değilse) — bu klasörde:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File claude-web-skill\build.ps1
   ```
   (macOS/Linux: `bash claude-web-skill/build.sh`) → çıktı: `dist\fable-skill.zip`
2. claude.ai → **Settings → Capabilities → Skills → Upload skill** → `fable-skill.zip`'i seçin. (Menü adları arayüz güncellemeleriyle biraz değişebilir; "Skills" bölümünü Settings altında arayın. Ücretli plan + Skills/kod çalıştırma özelliğinin açık olması gerekir.)
3. Artık **her sohbette** `fable` yazmanız yeterli — paket protokolü, 9 paketi ve altın örnekleri içinde taşır.

**Yöntem B — Project olarak:**

1. claude.ai → **Projects** → yeni proje ("Fable Mode").
2. Projenin **Instructions** alanına `FABLE-MODE.md`'nin **tamamını** yapıştırın.
3. `FABLE-PACKS/` ve `FABLE-EXAMPLES/` dosyalarını projenin **knowledge** bölümüne yükleyin.
4. Bu projedeki her sohbet Fable Mode'da çalışır.

Alternatifler: tek sohbet için dosyayı yapıştırıp "fable full" yazın · Settings → Profile tercihlerine `FABLE-MODE-MINI.md` · Custom Style olarak MINI.

### 3) API

```python
import anthropic

protocol = open("FABLE-MODE.md", encoding="utf-8").read()
pack = open("FABLE-PACKS/debugging.md", encoding="utf-8").read()
client = anthropic.Anthropic()
msg = client.messages.create(
    model="claude-sonnet-5",  # veya claude-opus-4-8
    max_tokens=4096,
    system=protocol + "\n\n" + pack,
    messages=[{"role": "user", "content": "fable full — şu bug'ı analiz et: ..."}],
)
print(msg.content[0].text)
```

## GitHub'a yükleme

Hazır kit: `GITHUB-PUBLISH.md` — önerilen repo adı (`fable-mode`), açıklama, etiketler ve kopyala-yapıştır komutlar.

## İpuçları

- **En iyi sonuç:** Opus + FULL + extended thinking. Günlük işler için Sonnet + FULL çok güçlü bir ikili.
- **Haiku için:** `fable` deyin — dürüstçe MINI önerecektir. Haiku'da MINI + işe uyan tek paket, tam protokolden daha tutarlı uygulanır; uzun oturumda ara ara `fable` yazıp yeniden hizalayın.
- Protokol ve paketler **İngilizce** çünkü modeller arası en güvenilir talimat dili İngilizce; cevaplar her zaman sizin dilinizde gelir (FULL §10.5 garanti eder).
- Protokolü değiştirirseniz üç kopyayı senkron tutun: `FABLE-MODE.md` (kaynak), `FABLE-MODE-MINI.md`, `SKILL.md` fallback. Paketler ve örnekler bağımsızdır — serbestçe ekleyin.
