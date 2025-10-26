# 🐾 PetCare+ iOS Application

<div align="center">

**Modern, AI-destekli evcil hayvan bakım ve sağlık takip uygulaması**

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-black.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0+-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 📖 Proje Hakkında

**PetCare+**, evcil hayvan sahiplerinin günlük bakım, sağlık ve eğitim süreçlerini kolaylaştıran, yapay zekâ destekli kapsamlı bir iOS uygulamasıdır. Uygulama, kullanıcıların kendi evcil hayvanlarının rutinlerini yönetmelerini sağlarken, AI teknolojisi sayesinde davranış analizi ve bilgilendirme hizmetleri sunar.

### 🎯 Vizyon
Evcil hayvan sahipleri için "hepsi bir arada" dijital asistan olmak ve pet care sürecini modern teknoloji ile kolaylaştırmak.

---

## ✨ Ana Özellikler

### 🐾 1. Günlük Rutin Takip
- Yemek, su, tuvalet, egzersiz ihtiyaçlarının kontrolü
- Akıllı checklist ve hatırlatıcı sistemi
- Otomatik günlük bakım raporu oluşturma
- Haftalık/aylık aktivite istatistikleri

### 🚶 2. GPS Destekli Egzersiz Takibi
- Gerçek zamanlı yürüyüş ve egzersiz izleme
- Süre, mesafe ve yakılan kalori hesaplama
- Günlük egzersiz hedefleri ve başarı rozetleri
- Rota geçmişi ve favori rotalar

### 🤖 3. AI Destekli Pet Chat Assistant
- Evcil hayvan davranış analizi
- Fotoğraf, ses veya metin açıklamasıyla sorgu
- Kişiselleştirilmiş öneriler ve açıklamalar
- Örnek: "Kediniz şu an korkmuş olabilir, sakin bir ortam sağlayın"

### 📷 4. AI Görsel Tanıma (Image Recognition)
- Fotoğraftan tür, ırk, yaş ve cinsiyet tahmini
- Golden Retriever, British Shorthair gibi detaylı ırk bilgisi
- Irk karakteristikleri ve bakım önerileri
- İlerleyen versiyonlarda video analizi desteği

### 📅 5. Hatırlatma Takvimi
- Veteriner randevuları yönetimi
- İlaç ve aşı takvimleri
- Özelleştirilebilir bildirim sistemi
- Randevu sonrası değerlendirme ve notlar

### 💉 6. Dijital Sağlık Kimliği
- Geçmiş hastalık ve tedavi kayıtları
- Aşı takip sistemi
- Kilo ve büyüme grafikleri
- PDF formatında dışa aktarılabilir sağlık dosyası
- Veteriner geçmişi arşivi

### 🗺️ 7. Harita Entegrasyonu
- Konum bazlı en yakın veteriner ve petshop bulma
- Apple Maps entegrasyonu
- Rota oluşturma ve navigasyon
- Açık saat bilgisi ve favorilere ekleme

### 🧠 8. AI Bilgi Botu (Pet Info Assistant)
- Genel hayvan bakımı soruları
- Örnek: "Köpeğime ne sıklıkla banyo yaptırmalıyım?"
- Veteriner kaynaklı güncel bilgiler
- Tür ve ırka özel öneriler

---

## 🛠 Teknoloji Stack

### Frontend
- **Dil:** Swift 5.9+
- **UI Framework:** SwiftUI
- **Minimum iOS:** 16.0+
- **Xcode:** 15.0+

### Apple Frameworks
| Framework | Kullanım Alanı |
|-----------|----------------|
| SwiftUI | Modern UI geliştirme |
| Swift Concurrency | Async/await, Task, Actor |
| Combine | Reaktif programlama |
| SwiftData | Lokal veri saklama |
| CoreLocation | Konum servisleri |
| MapKit | Harita ve rota |
| UserNotifications | Push notification |
| Vision Framework | Görsel tanıma |
| PDFKit | PDF oluşturma |

### Backend & Services (TBD)
- **Database:** Supabase *(henüz kesinleşmedi)*
- **AI Provider:** Google Gemini API *(henüz kesinleşmedi)*
- **Analytics:** Apple Analytics

> **Not:** Backend ve AI servisleri proje ilerledikçe kesinleşecektir.

---

## 🏗 Mimari & Kod Yapısı

### Mimari Pattern: MVVM
PetCare+ **Model-View-ViewModel** mimarisini kullanır.

```
Model ←→ ViewModel ←→ View
  ↓         ↓           ↓
Data     Business    UI Layer
Layer     Logic
```

### Proje Klasör Yapısı

```
PetCare+/
│
├── 📱 App/
│   ├── PetCareApp.swift          # App entry point
│   └── AppDelegate.swift         # Lifecycle events
│
├── 🎯 Core/
│   ├── Models/                   # Data models (Pet, User, Routine, etc.)
│   ├── Services/                 # API, Location, Notification services
│   ├── Managers/                 # Singleton managers (Auth, AI, Data)
│   └── Utilities/                # Helpers, Extensions
│
├── 🎨 Features/                  # Feature-based modüller
│   ├── DailyRoutine/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Components/
│   ├── ExerciseTracking/
│   ├── PetChat/
│   ├── AIImageRecognition/
│   ├── Calendar/
│   ├── HealthID/
│   ├── Map/
│   └── InfoAssistant/
│
├── 🧩 Shared/
│   ├── Components/               # Reusable UI components
│   ├── Styles/                   # AppColors, AppFonts, Themes
│   └── Extensions/               # Swift extensions
│
├── 📦 Resources/
│   ├── Localization/             # TR & EN strings
│   ├── Assets.xcassets/          # Images, icons
│   └── Fonts/                    # Custom fonts (opsiyonel)
│
└── 🧪 Tests/
    ├── UnitTests/
    └── UITests/
```

### Kod Örnekleri

#### MVVM Pattern
```swift
// MODEL
struct Pet: Identifiable, Codable {
    let id: UUID
    var name: String
    var species: PetSpecies
    var birthDate: Date
}

// VIEW
struct PetProfileView: View {
    @StateObject private var viewModel = PetProfileViewModel()

    var body: some View {
        VStack {
            Text(viewModel.pet.name)
            // UI code...
        }
        .task {
            await viewModel.loadPet()
        }
    }
}

// VIEWMODEL
@MainActor
class PetProfileViewModel: ObservableObject {
    @Published var pet: Pet
    @Published var isLoading = false

    func loadPet() async {
        // Business logic
    }
}
```

---

## 🎨 Tasarım Sistemi

### Renk Paleti

**Tasarım Dili:** Modern, minimal, glassmorphism estetiği

| Renk Kategorisi | Kullanım |
|----------------|----------|
| **🧡 Turuncu** | Vurgu rengi (Primary Accent) |
| **⚪ Beyaz-Gri Tonları** | Arka plan, kartlar (Glass morphism) |
| **🌓 System Colors** | Dark mode uyumu |

```swift
struct AppColors {
    // Vurgu Rengi - Ana Kimlik
    static let accent = Color.orange

    // Glass Morphism
    static let glassBackground = Color.white.opacity(0.7)
    static let glassBorder = Color.white.opacity(0.3)

    // iOS System Colors
    static let background = Color(.systemBackground)
    static let gray1 = Color(.systemGray)
}
```

### Tipografi
- **Font Family:** SF Pro (Apple San Francisco)
- **Dynamic Type:** Erişilebilirlik desteği
- **Font Weights:** Regular, Medium, Semibold, Bold

### UI Prensipleri
✅ **SF Symbols** kullanımı zorunlu
✅ **Dark Mode** desteği
✅ **Glass morphism** efektleri
✅ **Native iOS components** (List, NavigationStack, TabView)
✅ **Haptic feedback** kritik etkileşimlerde

---

## 🚀 Geliştirme Süreci

### Faz 1: UI/UX Tasarımları ⏳ **(ŞU AN AKTİF)**
**Öncelik:** YÜKSEK

**Hedefler:**
- [ ] Tüm sayfa tasarımlarının SwiftUI ile oluşturulması
- [ ] Shared component library hazırlanması
- [ ] Navigasyon yapısının kurulması
- [ ] Mock data ile çalışır demo

**Süre:** ~4-6 hafta

### Faz 2: Authentication & Onboarding ⏸️ **(BEKLİYOR)**
**Öncelik:** ORTA

**Özellikler:**
- Login/Signup ekranları
- **Misafir Giriş (Guest Mode)** - ZORUNLU
- Kullanıcı profil yönetimi
- Onboarding akışı

**Başlangıç:** Faz 1 tamamlandıktan sonra

### Faz 3: Backend Entegrasyonu ⏸️ **(PLANLANMIŞ)**
**Öncelik:** DÜŞÜK

- Supabase/backend entegrasyonu
- Gemini AI API bağlantısı
- Cloud sync özellikleri
- Real-time data

**Not:** Backend teknolojileri değişebilir.

---

## 🌍 Dil Desteği

### Desteklenen Diller
- 🇹🇷 **Türkçe** (Ana dil)
- 🇬🇧 **İngilizce** (İkincil dil)

### Lokalizasyon
Tüm metinler `Localizable.strings` dosyasında saklanır.

```swift
// Türkçe (tr.lproj/Localizable.strings)
"daily_routine_title" = "Günlük Rutin";

// İngilizce (en.lproj/Localizable.strings)
"daily_routine_title" = "Daily Routine";
```

Kullanıcı uygulama içinden dil değiştirebilir.

---

## 🔐 Authentication Stratejisi

### Misafir Giriş (Guest Mode) - ZORUNLU ÖZELLİK

**Kullanıcı Akışı:**

```
İlk Açılış
    ↓
Onboarding
    ↓
┌─────────────────────┐
│ Misafir Giriş      │  ← Prominent buton
│ Kayıt Ol           │
│ Giriş Yap          │
└─────────────────────┘
    ↓
Misafir → Tüm özellikler, lokal data
Kayıtlı → Cloud sync + çoklu cihaz
```

**Misafir Özellikleri:**
- ✅ Tüm özelliklere tam erişim
- ✅ SwiftData ile lokal veri
- ✅ İsteğe bağlı hesap oluşturma
- ❌ Cloud sync yok

---

## 📊 Data Yönetimi

### Lokal Database: SwiftData
```swift
@Model
class Pet {
    @Attribute(.unique) var id: UUID
    var name: String
    var species: String

    @Relationship(deleteRule: .cascade)
    var routines: [DailyRoutine]

    @Relationship(deleteRule: .cascade)
    var healthRecords: [HealthRecord]
}
```

### Cloud Database: Supabase (TBD)
Kayıtlı kullanıcılar için:
- Multi-device sync
- Backup & restore
- Collaborative features

---

## 🤖 AI Entegrasyonu

### Kullanım Alanları

| Özellik | AI Modeli | Kullanım |
|---------|-----------|----------|
| Pet Chat | Gemini Pro | Davranış analizi |
| Image Recognition | Gemini Vision | Tür/ırk tanıma |
| Info Assistant | Gemini Pro | Bilgi sorgulama |

### AI Service Architecture (Protocol-based)

```swift
protocol AIServiceProtocol {
    func analyzeImage(_ image: UIImage) async throws -> PetAnalysisResult
    func chatCompletion(messages: [ChatMessage]) async throws -> String
}

class GeminiAIService: AIServiceProtocol {
    // Implementation
}
```

> **Esneklik:** Protocol-based mimari sayesinde AI provider kolayca değiştirilebilir (OpenAI, Anthropic, vb.)

---

## 📝 Kod Standartları

### Naming Conventions
```swift
✅ class UserProfileViewModel { }
✅ struct PetHealthRecord { }
✅ let maxRetryCount = 3

❌ class userProfile { }
❌ struct pet_health { }
```

### Code Organization (MARK)
```swift
// MARK: - Properties
// MARK: - Initialization
// MARK: - Lifecycle
// MARK: - Public Methods
// MARK: - Private Methods
```

### Swift Modern Practices
- ✅ `async/await` (completion handler yerine)
- ✅ `@MainActor` UI işlemleri için
- ✅ Protocol-oriented design
- ✅ SwiftUI composition pattern
- ❌ Force unwrap (`!`) kullanma

---

## 🧪 Testing Stratejisi

### Unit Tests
- ViewModels business logic
- Service layer
- Utility functions
- Model validations

### UI Tests
- Critical user flows
- Navigation paths
- Form submissions

### Test Coverage Hedefi
- **Minimum:** %70
- **Hedef:** %85+

---

## 📦 Bağımlılıklar

### SPM (Swift Package Manager)
Proje bağımlılıkları:

```swift
// Package.swift dependencies (gelecekte eklenecek)
- Supabase Swift Client (TBD)
- Gemini Swift SDK (TBD)
```

> **Not:** Şu an için harici bağımlılık yok. Native iOS frameworks kullanılıyor.

---

## 🚧 Kurulum & Çalıştırma

### Gereksinimler
- macOS 13.0+
- Xcode 15.0+
- iOS 16.0+ Simulator veya Device
- Swift 5.9+

### Adımlar
```bash
# 1. Repo'yu clone et
git clone <repository-url>
cd PetCare+

# 2. Xcode ile aç
open PetCare+.xcodeproj

# 3. Build & Run
# Xcode'da Cmd+R
```

### İlk Kurulum Notları
- API keys henüz gerekli değil (Faz 3'te eklenecek)
- Mock data ile çalışır
- Simulator veya gerçek cihazda test edilebilir

---

## 📋 Feature Checklist

Her yeni feature için kontrol edilmesi gerekenler:

- [ ] MVVM mimarisine uygun
- [ ] Reusable component'ler kullanılmış
- [ ] TR/EN lokalizasyon eklenmiş
- [ ] Dark mode desteği
- [ ] iOS HIG standartlarına uygun
- [ ] `async/await` kullanılmış
- [ ] Error handling yapılmış
- [ ] Unit test yazılmış
- [ ] Accessibility (VoiceOver) düşünülmüş
- [ ] Code review tamamlanmış

---

## 🎯 Performans Hedefleri

| Metrik | Hedef |
|--------|-------|
| Uygulama açılış süresi | < 2 saniye |
| View render süresi | < 16ms (60 FPS) |
| AI response time | < 3 saniye |
| Memory kullanımı (idle) | < 150 MB |
| Battery efficiency | Background'da minimal |

---

## 📚 Dokümantasyon

### İlgili Dosyalar
- [`Temel.md`](./Temel.md) - Ana özellikler detaylı açıklama
- [`PROJECT_RULES.md`](./PROJECT_RULES.md) - Kod standartları ve kurallar
- `README.md` - Bu dosya (genel bakış)

### Faydalı Kaynaklar
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

---

## 🤝 Katkıda Bulunma

### Git Workflow
```bash
# Feature branch oluştur
git checkout -b feature/gunluk-rutin-ekrani

# Commit et (conventional commits)
git commit -m "feat: Günlük rutin ekranı eklendi"

# Push et
git push origin feature/gunluk-rutin-ekrani

# Pull Request aç
```

### Commit Message Formatı
```
feat: Yeni özellik eklendi
fix: Bug düzeltildi
refactor: Kod yeniden yapılandırıldı
docs: Dokümantasyon güncellendi
test: Test eklendi
```

---

## 📄 License

MIT License - detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

## 👥 İletişim & Destek

**Proje Durumu:** 🟢 Aktif Geliştirme (Faz 1)
**Versiyon:** 0.1.0-alpha
**Son Güncelleme:** 2025-10-25

---

<div align="center">

**🐾 PetCare+ ile evcil hayvan bakımı artık daha kolay! 🐾**

Made with ❤️ using SwiftUI

</div>
