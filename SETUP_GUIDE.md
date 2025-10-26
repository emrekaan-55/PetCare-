# 🚀 PetCare+ Kurulum Rehberi

Bu rehber, PetCare+ projesini sıfırdan başlatmak için gereken tüm adımları içerir.

---

## 📋 Ön Gereksinimler

✅ **macOS:** 13.0 veya üstü
✅ **Xcode:** 15.0 veya üstü
✅ **Xcode Command Line Tools:** Yüklü olmalı
✅ **iOS Simulator:** 16.0+ veya fiziksel cihaz

### Xcode Kontrolü
```bash
# Xcode versiyonunu kontrol et
xcodebuild -version

# Command Line Tools kontrol
xcode-select -p
```

---

## 🏗 Adım 1: Xcode Projesi Oluşturma

### 1.1 Xcode'u Aç
```bash
open -a Xcode
```

### 1.2 Yeni Proje Oluştur

1. **Create a new Xcode project** seç
2. **iOS** → **App** seç → **Next**
3. Aşağıdaki ayarları yap:

```
Product Name:        PetCare+
Team:                (Senin Apple Developer Team'in)
Organization ID:     com.yourname (örn: com.mustafa)
Bundle Identifier:   com.yourname.PetCarePlus
Interface:           SwiftUI
Language:            Swift
Storage:             SwiftData
Include Tests:       ✅ (işaretle)
```

4. **Next** → Kaydetmek istediğin konumu seç:
   - `/Applications/Project/Pet/` klasörünü seç
   - **Create** butonuna tıkla

### 1.3 Proje Ayarları

Proje oluştuktan sonra:

1. **Project Navigator** (sol panel) → **PetCare+** projesine tıkla
2. **TARGETS** → **PetCare+** seç
3. **General** sekmesinde:

```
Display Name:         PetCare+
Bundle Identifier:    com.yourname.PetCarePlus
Version:              0.1.0
Build:                1
Deployment Target:    iOS 16.0
Supported Destinations: iPhone, iPad
```

4. **Signing & Capabilities** sekmesinde:
   - **Automatically manage signing** işaretle
   - Team'ini seç

---

## 📁 Adım 2: Klasör Yapısını Oluşturma

### 2.1 Xcode'da Grup Oluşturma

Proje navigatorında **PetCare+** klasörüne sağ tıkla → **New Group** seç.

Aşağıdaki klasör yapısını oluştur:

```
PetCare+/
├── App/
├── Core/
│   ├── Models/
│   ├── Services/
│   ├── Managers/
│   └── Utilities/
├── Features/
│   ├── DailyRoutine/
│   ├── ExerciseTracking/
│   ├── PetChat/
│   ├── AIImageRecognition/
│   ├── Calendar/
│   ├── HealthID/
│   ├── Map/
│   └── InfoAssistant/
├── Shared/
│   ├── Components/
│   ├── Styles/
│   └── Extensions/
└── Resources/
```

**Not:** Xcode'da grup oluştururken klasör sistemiyle senkronize olmaz. Gerçek klasörler oluşturmak için:
- Sağ tık → **New Group** yerine
- Sağ tık → **New Group with Folder** seç

### 2.2 Mevcut Dosyaları Taşı

Xcode'un otomatik oluşturduğu dosyaları uygun klasörlere taşı:

| Dosya | Hedef Klasör |
|-------|--------------|
| `PetCare_App.swift` | `App/` |
| `ContentView.swift` | `Features/` (geçici) |
| `Assets.xcassets` | `Resources/` |
| `Preview Content` | Sil (ihtiyaç yok) |

**Dosya taşıma:** Drag & drop yap, Xcode referansları otomatik güncelleyecek.

---

## 🎨 Adım 3: Temel Dosyaları Oluşturma

### 3.1 Shared/Styles/AppColors.swift

**Sağ tık** `Shared/Styles/` → **New File** → **Swift File** → `AppColors.swift`

```swift
import SwiftUI

struct AppColors {
    // VURGU RENGİ - TURUNCU (Ana kimlik rengi)
    static let accent = Color.orange
    static let accentLight = Color.orange.opacity(0.7)
    static let accentDark = Color(red: 1.0, green: 0.55, blue: 0.0) // #FF8C00

    // ARKA PLAN RENKLERİ - Glass Morphism
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)

    // GLASS EFEKTİ
    static let glassBackground = Color.white.opacity(0.7)
    static let glassBorder = Color.white.opacity(0.3)

    // GRİ TONLARI
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
```

### 3.2 Shared/Styles/AppFonts.swift

```swift
import SwiftUI

struct AppFonts {
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title = Font.title.weight(.semibold)
    static let title2 = Font.title2.weight(.semibold)
    static let title3 = Font.title3.weight(.medium)
    static let headline = Font.headline
    static let subheadline = Font.subheadline
    static let body = Font.body
    static let callout = Font.callout
    static let caption = Font.caption
    static let caption2 = Font.caption2
    static let footnote = Font.footnote
}
```

### 3.3 Shared/Styles/AppSpacing.swift

```swift
import Foundation

struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}
```

### 3.4 Shared/Extensions/View+Extensions.swift

```swift
import SwiftUI

extension View {
    /// Glass morphism efekti uygular
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

    /// Kart görünümü uygular
    func cardStyle(padding: CGFloat = AppSpacing.md) -> some View {
        self
            .padding(padding)
            .background(AppColors.secondaryBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}
```

---

## 🔧 Adım 4: App Entry Point Düzenleme

### 4.1 App/PetCare_App.swift Güncelle

Xcode'un oluşturduğu `PetCare_App.swift` dosyasını aç ve şöyle güncelle:

```swift
import SwiftUI
import SwiftData

@main
struct PetCarePlusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            // SwiftData modelleri buraya eklenecek
            // Örnek: Pet.self, DailyRoutine.self
        ])
    }
}
```

---

## 🌍 Adım 5: Lokalizasyon Kurulumu

### 5.1 String Catalog Oluştur (Xcode 15+)

1. Sağ tık **Resources** klasörü → **New File**
2. **Resource** → **String Catalog** seç
3. İsim: `Localizable` → **Create**
4. String Catalog'u aç
5. Sağ üst **+** butonuna bas → **Add Locale**
6. **Turkish** ve **English** ekle

### 5.2 İlk String'leri Ekle

| Key | Turkish | English |
|-----|---------|---------|
| `app_name` | PetCare+ | PetCare+ |
| `welcome_message` | Hoş geldiniz! | Welcome! |
| `daily_routine_title` | Günlük Rutin | Daily Routine |

---

## 🎯 Adım 6: İlk Component Oluşturma

### 6.1 Shared/Components/PrimaryButton.swift

```swift
import SwiftUI

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
            HStack(spacing: AppSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(AppFonts.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isEnabled ? AppColors.accent : AppColors.gray3)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton("Kaydet", icon: "checkmark.circle") {
            print("Kaydedildi")
        }

        PrimaryButton("Devam Et") {
            print("Devam edildi")
        }
        .disabled(true)
    }
    .padding()
}
```

---

## ✅ Adım 7: İlk Build & Run

### 7.1 Build Et
```
Cmd + B
```

Hata olmamalı. Tüm dosyalar derlenmeli.

### 7.2 Run Et
```
Cmd + R
```

Simulator açılacak ve ContentView gösterilecek.

### 7.3 Test Et

`ContentView.swift` dosyasını şu şekilde güncelle:

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Text("🐾 PetCare+")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.accent)

            Text("Evcil Hayvan Bakım Asistanı")
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textSecondary)

            PrimaryButton("Başlayalım", icon: "pawprint.fill") {
                print("Proje başarıyla kuruldu!")
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
```

**Run Et** → Turuncu renkli buton ve başlık göreceksin! 🎉

---

## 🧪 Adım 8: Test Ayarları

### 8.1 Test Hedefleri Oluştur

Xcode zaten otomatik oluşturmuş olmalı:
- `PetCare+Tests` (Unit Tests)
- `PetCare+UITests` (UI Tests)

### 8.2 İlk Test Yaz

`PetCare+Tests/PetCare_Tests.swift` dosyasını aç:

```swift
import XCTest
@testable import PetCare_

final class PetCare_Tests: XCTestCase {
    func testAppColorsExist() {
        // Test: AppColors tanımlı mı?
        XCTAssertNotNil(AppColors.accent)
        XCTAssertNotNil(AppColors.background)
    }

    func testAppSpacing() {
        // Test: Spacing değerleri doğru mu?
        XCTAssertEqual(AppSpacing.sm, 8)
        XCTAssertEqual(AppSpacing.md, 16)
    }
}
```

**Test Et:**
```
Cmd + U
```

✅ Testler başarılı olmalı!

---

## 🎨 Adım 9: Assets & SF Symbols

### 9.1 App Icon Ekleme

1. `Resources/Assets.xcassets` aç
2. **AppIcon** seç
3. Farklı boyutlarda icon'lar sürükle-bırak (opsiyonel, şimdilik gerek yok)

### 9.2 SF Symbols Preview

ContentView'de test et:

```swift
HStack(spacing: 20) {
    Image(systemName: "pawprint.fill")
        .foregroundColor(AppColors.accent)
    Image(systemName: "heart.fill")
        .foregroundColor(AppColors.error)
    Image(systemName: "bell.fill")
        .foregroundColor(AppColors.warning)
}
.font(.largeTitle)
```

---

## 🔒 Adım 10: .gitignore Oluştur

Proje kök dizininde `.gitignore` dosyası oluştur:

```bash
# Xcode
*.xcuserstate
*.xcworkspace/xcuserdata/
DerivedData/
build/

# Swift Package Manager
.build/
Packages/

# CocoaPods (şimdilik kullanmıyoruz)
Pods/

# Secrets
*.xcconfig
.env

# macOS
.DS_Store
```

---

## 📦 Adım 11: Git Başlatma

```bash
cd /Applications/Project/Pet

# Git init
git init

# İlk commit
git add .
git commit -m "feat: Initial project setup with SwiftUI and SwiftData"

# Branch oluştur
git branch -M main
```

---

## 🎉 Kurulum Tamamlandı!

Artık projen hazır!

### Sonraki Adımlar:

1. ✅ **Feature Branch Oluştur**
   ```bash
   git checkout -b feature/daily-routine-ui
   ```

2. ✅ **İlk Sayfayı Tasarla**
   - `Features/DailyRoutine/Views/DailyRoutineView.swift`
   - Mock data kullan
   - Component'leri oluştur

3. ✅ **PROJECT_RULES.md'ye Uy**
   - MVVM pattern
   - Reusable components
   - TR/EN lokalizasyon

---

## 🆘 Sorun Giderme

### Build Hatası
```bash
# Clean build folder
Cmd + Shift + K

# Delete derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Rebuild
Cmd + B
```

### Simulator Açılmıyor
```bash
# Simulator'ı manuel aç
open -a Simulator

# Xcode'dan tekrar run et
Cmd + R
```

### SwiftData Hatası
- iOS Deployment Target'in 16.0+ olduğundan emin ol
- `import SwiftData` satırı olmalı

---

## 📚 Ek Kaynaklar

- [README.md](./README.md) - Proje genel bakış
- [PROJECT_RULES.md](./PROJECT_RULES.md) - Kodlama standartları
- [Temel.md](./Temel.md) - Özellik detayları

---

**Başarılar! 🚀 Artık kodlamaya başlayabilirsin!**
