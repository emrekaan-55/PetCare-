# PetCare+ Proje Kuralları ve Standartları

## 📋 İçindekiler
1. [Geliştirme Öncelikleri](#geliştirme-öncelikleri)
2. [Teknoloji Stack](#teknoloji-stack)
3. [Dil Desteği](#dil-desteği)
4. [Tasarım Prensipleri](#tasarım-prensipleri)
5. [Kod Yapısı ve Mimari](#kod-yapısı-ve-mimari)
6. [Component Yapısı](#component-yapısı)
7. [Kodlama Standartları](#kodlama-standartları)
8. [AI/ML Entegrasyonu](#aiml-entegrasyonu)
9. [Data Yönetimi](#data-yönetimi)
10. [Authentication ve Kullanıcı Yönetimi](#authentication-ve-kullanıcı-yönetimi)
11. [Güvenlik ve Gizlilik](#güvenlik-ve-gizlilik)

---

## ⚠️ ÖNEMLİ: Proje Geçmişi

**Tüm konuşma geçmişi, kararlar ve önemli notlar [`PROMPTS.md`](./PROMPTS.md) dosyasında saklanır.**

Bu dosya projenin "hafızası"dır. Her önemli istek, yanıt ve karar buraya kaydedilir. Proje boyunca referans olarak kullanılmalıdır.

---

## 🎯 Geliştirme Öncelikleri

### Geliştirme Sırası
Bu proje aşağıdaki sırayla geliştirilecek:

#### Faz 1: UI/UX Tasarımları (ŞU AN AKTİF)
**Öncelik: YÜKSEK**
- Tüm sayfa tasarımlarının SwiftUI ile oluşturulması
- Component library hazırlanması
- Navigasyon yapısının kurulması
- Mock data ile çalışır demo hazırlanması

**Hedef:** Uygulama akışının ve tasarımının tamamlanması

#### Faz 2: Authentication & Onboarding
**Öncelik: ORTA**
- Login/Signup ekranları
- **Misafir Giriş (Guest Mode)** - ZORUNLU özellik
- Kullanıcı profil yönetimi
- Onboarding flow

**Not:** Bu faz, sayfa tasarımları tamamen bitene kadar başlatılmayacak.

#### Faz 3: Backend Entegrasyonu
**Öncelik: DÜŞÜK**
- Supabase entegrasyonu (henüz kesinleşmedi)
- Gemini AI API entegrasyonu (henüz kesinleşmedi)
- Real-time sync özellikleri

**Not:** Backend teknolojileri değişebilir, kesin karar henüz verilmedi.

---

## 🛠 Teknoloji Stack

### Ana Teknolojiler
- **Programlama Dili:** Swift 5.9+
- **UI Framework:** SwiftUI
- **Minimum iOS Versiyon:** iOS 16.0+
- **Xcode Versiyon:** Xcode 15.0+

### Kullanılacak Swift Teknolojileri
- **SwiftUI** - Modern, deklaratif UI geliştirme
- **Swift Concurrency** - async/await pattern ile asenkron işlemler
- **Combine Framework** - Reaktif programlama ve data binding
- **CoreData / SwiftData** - Lokal veri saklama
- **CoreLocation** - Konum servisleri (harita, egzersiz takibi)
- **MapKit** - Harita görünümü ve rota oluşturma
- **UserNotifications** - Hatırlatıcılar ve bildirimler
- **Vision Framework** - Görsel tanıma için yerel AI desteği
- **PDFKit** - Sağlık raporu PDF oluşturma
- **HealthKit (opsiyonel)** - Gelecekte kullanıcı-evcil hayvan ortak aktivite takibi

### Harici Servisler (Henüz Kesinleşmedi)
- **AI Provider:** Google Gemini API (TBD - To Be Determined)
- **Backend:** Supabase (TBD - To Be Determined)
- **Analytics:** Apple Analytics (opsiyonel)

**Not:** Backend ve AI servisleri henüz kesinleşmemiştir. Proje ilerledikçe bu kararlar netleşecektir.

---

## 🌍 Dil Desteği

### Desteklenen Diller
- **Türkçe (TR)** - Ana dil
- **İngilizce (EN)** - İkincil dil

### Lokalizasyon Kuralları
1. Tüm metinler `Localizable.strings` dosyasında saklanmalı
2. Her string için anlamlı key kullanılmalı:
   ```swift
   // ✅ Doğru
   "daily_routine_title" = "Günlük Rutin";

   // ❌ Yanlış
   "screen1_text" = "Günlük Rutin";
   ```

3. String interpolation için String Catalog kullanılmalı (Xcode 15+)
4. Tarih ve sayı formatları locale'e göre ayarlanmalı:
   ```swift
   let formatter = DateFormatter()
   formatter.locale = Locale.current
   formatter.dateStyle = .medium
   ```

5. Varsayılan dil: Türkçe
6. Kullanıcı dil değiştirme seçeneği uygulama içinde olmalı

---

## 🎨 Tasarım Prensipleri

### Apple Human Interface Guidelines (HIG) Uyumluluğu
Uygulama, iOS'un resmi tasarım dili olan **Human Interface Guidelines**'a tam uyumlu olmalıdır.

#### Temel Prensipler
1. **Clarity (Açıklık)**
   - Temiz, okunabilir tipografi
   - SF Symbols kullanımı
   - Yeterli boşluk ve padding

2. **Deference (Saygı)**
   - İçerik odaklı tasarım
   - Minimal dekorasyon
   - Native iOS kontrolleri kullanımı

3. **Depth (Derinlik)**
   - Hierarchy ile öncelik gösterme
   - Natural animasyonlar
   - Contextual feedback

#### Tasarım Detayları

### Renk Paleti - Glass Morphism & Turuncu Vurgu

**Tasarım Dili:** Modern, minimal, glassmorphism estetiği

```swift
// Renk Paleti
struct AppColors {
    // VURGU RENGİ - TURUNCU (Ana kimlik rengi)
    static let accent = Color.orange
    static let accentLight = Color.orange.opacity(0.7)
    static let accentDark = Color(hex: "#FF8C00") // Dark Orange

    // ARKA PLAN RENKLERİ - Glass Morphism
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)

    // GLASS EFEKTİ
    static let glassBackground = Color.white.opacity(0.7)
    static let glassBorder = Color.white.opacity(0.3)

    // GRİ TONLARı
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let gray1 = Color(.systemGray)
    static let gray2 = Color(.systemGray2)
    static let gray3 = Color(.systemGray3)
    static let gray4 = Color(.systemGray4)
    static let gray5 = Color(.systemGray5)
    static let gray6 = Color(.systemGray6)

    // SEMANTIC COLORS
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    static let info = Color.blue
}

// Glass Morphism Modifiers
extension View {
    func glassEffect() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.glassBorder, lineWidth: 1)
            )
    }
}

// Typography - San Francisco Font
struct AppFonts {
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title = Font.title.weight(.semibold)
    static let headline = Font.headline
    static let body = Font.body
    static let caption = Font.caption
}

// Spacing - iOS Standart Aralıklar
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}
```

#### UI Elemanları
- **SF Symbols** kullanımı zorunlu (kendi icon'lar yerine)
- **Native iOS Components** tercih edilmeli (List, NavigationStack, TabView, etc.)
- **Dark Mode** desteği zorunlu
- **Dynamic Type** desteği (erişilebilirlik için)
- **Haptic Feedback** kritik etkileşimlerde kullanılmalı

---

## 🏗 Kod Yapısı ve Mimari

### Proje Dizin Yapısı
```
PetCare+/
├── App/
│   ├── PetCareApp.swift          # Ana app entry point
│   └── AppDelegate.swift          # App lifecycle
├── Core/
│   ├── Models/                    # Data modeller
│   ├── Services/                  # API, Location, Notification servisleri
│   ├── Utilities/                 # Helper'lar, Extension'lar
│   └── Managers/                  # Data Manager, AI Manager
├── Features/
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
├── Shared/
│   ├── Components/                # Reusable UI bileşenleri
│   ├── Styles/                    # Renk, font, tema tanımları
│   └── Extensions/                # Swift extension'lar
├── Resources/
│   ├── Localization/
│   │   ├── en.lproj/
│   │   └── tr.lproj/
│   ├── Assets.xcassets/
│   └── Fonts/
└── Tests/
    ├── UnitTests/
    └── UITests/
```

### Mimari Pattern: MVVM (Model-View-ViewModel)

```swift
// MODEL - Core/Models/Pet.swift
struct Pet: Identifiable, Codable {
    let id: UUID
    var name: String
    var species: PetSpecies
    var breed: String
    var birthDate: Date
    var weight: Double
}

// VIEW - Features/DailyRoutine/Views/DailyRoutineView.swift
struct DailyRoutineView: View {
    @StateObject private var viewModel = DailyRoutineViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.routines) { routine in
                RoutineRow(routine: routine)
            }
            .navigationTitle("daily_routine_title")
        }
        .task {
            await viewModel.loadRoutines()
        }
    }
}

// VIEWMODEL - Features/DailyRoutine/ViewModels/DailyRoutineViewModel.swift
@MainActor
class DailyRoutineViewModel: ObservableObject {
    @Published var routines: [Routine] = []
    @Published var isLoading = false

    private let service: RoutineService

    init(service: RoutineService = .shared) {
        self.service = service
    }

    func loadRoutines() async {
        isLoading = true
        do {
            routines = try await service.fetchRoutines()
        } catch {
            // Error handling
        }
        isLoading = false
    }
}
```

---

## 🧩 Component Yapısı

### Component Prensipleri
1. **Single Responsibility** - Her component tek bir işe odaklanmalı
2. **Reusability** - Tekrar kullanılabilir olmalı
3. **Composition** - Küçük component'lerden büyükler oluşturulmalı
4. **Testability** - Test edilebilir olmalı

### Component Örneği
```swift
// Shared/Components/PrimaryButton.swift
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isEnabled ? AppColors.primary : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

// Kullanım
PrimaryButton("Kaydet", icon: "checkmark.circle") {
    save()
}
```

### Shared Components Listesi
- `PrimaryButton`, `SecondaryButton` - Butonlar
- `CardView` - Kart container
- `LoadingView` - Yüklenme göstergesi
- `EmptyStateView` - Boş durum ekranı
- `ErrorView` - Hata gösterimi
- `PetProfileCard` - Evcil hayvan profil kartı
- `RoutineCheckbox` - Rutin checklist item
- `StatCard` - İstatistik kartı
- `CustomTextField` - Özelleştirilmiş text input

---

## 📝 Kodlama Standartları

### Swift Kod Kuralları

#### 1. Naming Conventions
```swift
// ✅ Doğru
class UserProfileViewModel { }
struct PetHealthRecord { }
enum NetworkError { }
let maxRetryCount = 3
func calculateDailyCalories() -> Double { }

// ❌ Yanlış
class userProfile { }
struct pet_health { }
let MaxRetryCount = 3
func Calculate_calories() -> Double { }
```

#### 2. Code Organization
```swift
// MARK: - Properties
// MARK: - Initialization
// MARK: - Lifecycle
// MARK: - Public Methods
// MARK: - Private Methods
```

#### 3. SwiftUI Best Practices
```swift
// ✅ Extract subviews
struct ProfileView: View {
    var body: some View {
        VStack {
            headerView
            contentView
            footerView
        }
    }

    private var headerView: some View {
        // Complex header code
    }
}

// ✅ Use @ViewBuilder
@ViewBuilder
func conditionalContent() -> some View {
    if condition {
        ContentView()
    } else {
        AlternativeView()
    }
}

// ✅ Prefer composition
struct PetCard: View {
    let pet: Pet

    var body: some View {
        CardView {
            PetAvatarView(pet: pet)
            PetInfoView(pet: pet)
        }
    }
}
```

#### 4. Async/Await Kullanımı
```swift
// ✅ Modern concurrency
func fetchPetData() async throws -> Pet {
    let data = try await networkService.fetch()
    return try decoder.decode(Pet.self, from: data)
}

// View'de kullanım
.task {
    await viewModel.loadData()
}

// ❌ Eski completion handler yaklaşımı kullanma
func fetchPetData(completion: @escaping (Pet) -> Void) { }
```

#### 5. Error Handling
```swift
enum PetCareError: LocalizedError {
    case invalidInput
    case networkFailure
    case aiProcessingFailed(reason: String)

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return NSLocalizedString("error_invalid_input", comment: "")
        case .networkFailure:
            return NSLocalizedString("error_network", comment: "")
        case .aiProcessingFailed(let reason):
            return "AI Error: \(reason)"
        }
    }
}
```

#### 6. Code Comments
```swift
// Türkçe veya İngilizce yorum yazılabilir, tutarlı olmalı
// Complex logic için yorum ekle

/// Pet'in günlük kalori ihtiyacını hesaplar
/// - Parameters:
///   - weight: Kilogram cinsinden ağırlık
///   - activityLevel: Aktivite seviyesi (1-5)
/// - Returns: Günlük kalori ihtiyacı
func calculateDailyCalories(weight: Double, activityLevel: Int) -> Double {
    // Formül: (30 * weight) + 70 * activity multiplier
    let baseCalories = (30 * weight) + 70
    let multiplier = Double(activityLevel) * 0.2
    return baseCalories * (1 + multiplier)
}
```

---

## 🤖 AI/ML Entegrasyonu

### AI Kullanım Alanları
1. **Pet Chat Assistant** - Davranış analizi ve öneriler
2. **Image Recognition** - Tür/ırk/yaş tanıma
3. **Info Assistant** - Genel bilgi sağlama

### AI Service Architecture

**AI Provider:** Google Gemini API (TBD - henüz kesinleşmedi)

```swift
// Core/Services/AIService.swift
protocol AIServiceProtocol {
    func analyzeImage(_ image: UIImage) async throws -> PetAnalysisResult
    func chatCompletion(messages: [ChatMessage]) async throws -> String
    func getInfoResponse(question: String) async throws -> String
}

// Gemini AI Service Implementation
class GeminiAIService: AIServiceProtocol {
    private let apiKey: String
    private let session: URLSession
    private let baseURL = "https://generativelanguage.googleapis.com/v1/models"

    init(apiKey: String) {
        self.apiKey = apiKey
        self.session = URLSession.shared
    }

    func analyzeImage(_ image: UIImage) async throws -> PetAnalysisResult {
        // Gemini Vision API implementation
        // Model: gemini-pro-vision
    }

    func chatCompletion(messages: [ChatMessage]) async throws -> String {
        // Gemini Chat API implementation
        // Model: gemini-pro
    }

    func getInfoResponse(question: String) async throws -> String {
        // Gemini Text API implementation
    }
}

// Core/Managers/AIManager.swift
@MainActor
class AIManager: ObservableObject {
    static let shared = AIManager()
    private let service: AIServiceProtocol

    @Published var isProcessing = false

    init(service: AIServiceProtocol = GeminiAIService(apiKey: Configuration.geminiAPIKey)) {
        self.service = service
    }

    func analyzePetBehavior(_ description: String) async -> String {
        // Business logic
    }

    func analyzePetImage(_ image: UIImage) async throws -> PetAnalysisResult {
        isProcessing = true
        defer { isProcessing = false }
        return try await service.analyzeImage(image)
    }
}
```

**Not:** Gemini API henüz kesinleşmedi. OpenAI veya başka bir provider'a geçilebilir. Protocol-based architecture sayesinde değişim kolay olacak.

### AI Güvenlik Kuralları
- API key'ler **asla** kod içinde hardcode edilmemeli
- `.xcconfig` veya Keychain kullanılmalı
- Rate limiting uygulanmalı
- Kullanıcı verileri AI'ye gönderilmeden önce anonimleştirme yapılmalı

---

## 💾 Data Yönetimi

### Database Stratejisi
- **Lokal Database:** SwiftData (kesin)
- **Cloud Database:** Supabase (TBD - henüz kesinleşmedi)

### Lokal Veri: SwiftData
```swift
import SwiftData

@Model
class Pet {
    @Attribute(.unique) var id: UUID
    var name: String
    var species: String
    var birthDate: Date

    @Relationship(deleteRule: .cascade)
    var routines: [DailyRoutine]

    @Relationship(deleteRule: .cascade)
    var healthRecords: [HealthRecord]

    init(name: String, species: String, birthDate: Date) {
        self.id = UUID()
        self.name = name
        self.species = species
        self.birthDate = birthDate
        self.routines = []
        self.healthRecords = []
    }
}

// App entry point'de
@main
struct PetCareApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Pet.self, DailyRoutine.self, HealthRecord.self])
    }
}
```

### Network Layer
```swift
// Core/Services/NetworkService.swift
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?
    ) async throws -> T
}
```

---

## 🔐 Authentication ve Kullanıcı Yönetimi

### Auth Özellikleri

#### Misafir Giriş (Guest Mode) - ZORUNLU
**Önemli:** Uygulama, kullanıcıların kayıt olmadan deneyimlemesine izin vermelidir.

```swift
// Core/Models/User.swift
enum UserType {
    case registered(User)
    case guest(guestID: UUID)
}

struct User: Identifiable, Codable {
    let id: UUID
    var email: String?
    var displayName: String
    var profileImageURL: String?
    var createdAt: Date
    var isGuest: Bool
}

// Misafir kullanıcı oluşturma
extension User {
    static func createGuest() -> User {
        User(
            id: UUID(),
            email: nil,
            displayName: "Misafir Kullanıcı",
            profileImageURL: nil,
            createdAt: Date(),
            isGuest: true
        )
    }
}
```

#### Auth Flow
1. **İlk Açılış:**
   - Onboarding ekranları
   - "Misafir Olarak Devam Et" butonu (prominent)
   - "Kayıt Ol / Giriş Yap" seçenekleri

2. **Misafir Kullanıcı:**
   - Tüm özelliklere erişim
   - Lokal veri saklama (SwiftData)
   - Profil oluşturabilir ama sync yok
   - İsteğe bağlı dönüşüm: Misafir → Kayıtlı kullanıcı

3. **Kayıtlı Kullanıcı:**
   - Email/Password ile kayıt
   - Apple Sign In (opsiyonel)
   - Cloud sync (Supabase - TBD)
   - Birden fazla cihazda kullanım

### Auth State Management
```swift
// Core/Managers/AuthManager.swift
@MainActor
class AuthManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var isGuest: Bool = true

    func continueAsGuest() {
        currentUser = User.createGuest()
        isGuest = true
        isAuthenticated = true
    }

    func signUp(email: String, password: String) async throws {
        // Supabase integration - TBD
    }

    func signIn(email: String, password: String) async throws {
        // Supabase integration - TBD
    }

    func convertGuestToRegistered(email: String, password: String) async throws {
        // Migrate local data to cloud
    }
}
```

### Data Migration (Misafir → Kayıtlı)
Misafir kullanıcı kayıt olduğunda, lokal verileri cloud'a taşınmalı:
- Pet profilleri
- Sağlık kayıtları
- Rutinler
- Hatırlatıcılar

**Not:** Auth implementasyonu Faz 2'de yapılacak (UI tasarımları bittikten sonra)

---

## 🔒 Güvenlik ve Gizlilik

### Veri Gizliliği
1. Kullanıcı onayı olmadan veri paylaşılmamalı
2. Hassas veriler (sağlık kayıtları) şifrelenmeli
3. KVKK/GDPR uyumluluğu sağlanmalı

### App Permissions
```swift
// Info.plist açıklamaları zorunlu
NSLocationWhenInUseUsageDescription
NSCameraUsageDescription
NSPhotoLibraryUsageDescription
NSUserNotificationsUsageDescription
```

### Best Practices
- User defaults için hassas veri kullanma
- Keychain kullan (şifreler, API keys)
- SSL pinning (production için)
- Input validation her zaman yap

---

## 📦 Versiyonlama ve Git

### Branch Strategy
- `main` - Production ready kod
- `develop` - Development branch
- `feature/*` - Yeni özellikler
- `bugfix/*` - Bug fix'ler
- `release/*` - Release hazırlık

### Commit Messages (Türkçe veya İngilizce)
```
feat: Günlük rutin takip ekranı eklendi
fix: Hatırlatıcı bildirim sorunu düzeltildi
refactor: AI service mimarisi iyileştirildi
docs: README güncellendi
test: ExerciseViewModel unit testleri eklendi
```

---

## ✅ Checklist: Her Feature için

- [ ] MVVM mimarisine uygun mu?
- [ ] Component'ler reusable mı?
- [ ] TR/EN lokalizasyon eklenmiş mi?
- [ ] Dark mode desteği var mı?
- [ ] iOS HIG'e uygun mu?
- [ ] Async/await kullanılmış mı?
- [ ] Error handling yapılmış mı?
- [ ] Unit test yazılmış mı?
- [ ] Accessibility (VoiceOver) düşünülmüş mü?
- [ ] Code review yapılmış mı?

---

## 🎯 Performans Hedefleri

- Uygulama açılış süresi: < 2 saniye
- View render süresi: < 16ms (60 FPS)
- AI response time: < 3 saniye
- Memory usage: < 150 MB (idle)
- Battery efficient: Background'da minimal işlem

---

---

## 📝 Değişiklik Geçmişi

### Versiyon 1.1 - 2025-10-25
- ✅ Geliştirme öncelikleri eklendi (Faz 1, 2, 3)
- ✅ Renk paleti güncellendi (Turuncu vurgu + Glass morphism)
- ✅ Backend: Supabase (TBD) eklendi
- ✅ AI Provider: Google Gemini API (TBD) eklendi
- ✅ Authentication bölümü eklendi
- ✅ Misafir giriş (Guest Mode) zorunluluğu eklendi

### Versiyon 1.0 - 2025-10-25
- İlk versiyon oluşturuldu

---

**Son Güncelleme:** 2025-10-25
**Güncel Versiyon:** 1.1
