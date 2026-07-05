# 🚀 GradeAI — Google Play Store Yayınlama Rehberi

> **Son Güncelleme:** 2026  
> **Proje:** GradeAI (Flutter)

---

## Adım 1: Google Play Developer Hesabı (25$)

1. [play.google.com/console](https://play.google.com/console) adresine git
2. Google hesabınla giriş yap
3. **Create account** → **Ödeme yap** (25 USD bir kerelik ücret)
4. **Developer adı:** GradeAI veya senin adın
5. **Contact email:** ali.utku.ismihan@gmail.com

---

## Adım 2: Keystore Oluştur (Uygulama İmzalama)

Terminalde şu komutu çalıştır:

```bash
cd C:\Users\UTKU\Documents\kimi\workspace\grade_ai\android\app

keytool -genkey -v -keystore grade-ai-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias grade-ai
```

**Sorulara cevap ver:**
- Keystore şifresi: *(güçlü bir şifre belirle, unutma!)*
- İsim: Utku Ismihan
- Organizational Unit: GradeAI
- Organization: GradeAI
- City: Istanbul
- State: Turkey
- Country Code: TR

**ÖNEMLİ:** `grade-ai-release-key.jks` dosyasını ve şifresini **GÜVENLİ YERE KAYDET**. Kaybedersen uygulamayı güncelleyemezsin!

---

## Adım 3: build.gradle Yapılandırması

Dosya: `android/app/build.gradle`

Aşağıdaki değişiklikleri yap:

```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services" // Firebase için
}

android {
    namespace = "com.gradeai.app"
    compileSdk = 34
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }

    defaultConfig {
        applicationId "com.gradeai.app"
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName "1.0.0"
    }

    // 🔴 YENİ: Signing config
    signingConfigs {
        release {
            keyAlias 'grade-ai'
            keyPassword 'BURAYA_KESTORE_SIFREN'
            storeFile file('grade-ai-release-key.jks')
            storePassword 'BURAYA_KESTORE_SIFREN'
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

## Adım 4: AndroidManifest.xml Güncelle

Dosya: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.USE_BIOMETRIC"/>

    <application
        android:label="GradeAI"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:allowBackup="false"
        android:usesCleartextTraffic="false">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <!-- AdMob App ID (gerçek ID'ni ekle) -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

---

## Adım 5: Uygulama İkonu

`android/app/src/main/res/` altındaki `mipmap-*` klasörlerine:

| Klasör | Boyut |
|--------|-------|
| `mipmap-mdpi` | 48x48 |
| `mipmap-hdpi` | 72x72 |
| `mipmap-xhdpi` | 96x96 |
| `mipmap-xxhdpi` | 144x144 |
| `mipmap-xxxhdpi` | 192x192 |

İkonlar: [icon.kitchen](https://icon.kitchen) veya Figma'dan oluştur.

---

## Adım 6: App Bundle (AAB) Oluştur

```bash
cd C:\Users\UTKU\Documents\kimi\workspace\grade_ai

flutter clean
flutter pub get

# Release build
flutter build appbundle --release
```

Çıktı: `build/app/outputs/bundle/release/app-release.aab`

---

## Adım 7: Google Play Console'a Yükle

1. [play.google.com/console](https://play.google.com/console) git
2. **Create app** → **App name:** GradeAI
3. **Default language:** English
4. **App or game:** App → **Free or paid:** Free
5. **Declarations:** Hepsini işaretle

### 7.1. App Content
- **Privacy policy URL:** *(İstersen senin web siten: `https://gradeaiwebsite-production.up.railway.app/privacy`)*
- **App access:** All functionality is available without special access
- **Ads:** Yes, my app contains ads (AdMob)
- **Content rating:** Everyone / Teen

### 7.2. Store Listing (Mağaza Sayfası)

| Alan | Metin |
|------|-------|
| **Short description** | AI-powered exam grading for teachers. Scan, upload, get instant results. |
| **Full description** | GradeAI helps teachers grade handwritten exam papers in seconds using AI. Supports 4 languages, curriculum rubrics, instant PDF reports, and offline mode. |
| **Screenshots** | Telefondan ekran görüntüleri al (5-8 adet) |
| **Feature graphic** | 1024x500 banner görseli |
| **App icon** | 512x512 PNG |

### 7.3. Internal Testing (İlk Yayın)

1. Sol menü → **Testing** → **Internal testing**
2. **Create new release** → **Upload** → `app-release.aab` dosyasını seç
3. **Release name:** `1.0.0`
4. **Release notes:** "Initial release of GradeAI"
5. **Review release** → **Start rollout to Internal testing**

### 7.4. Production (Canlı Yayın)

Internal test başarılı olduktan sonra:
1. **Production** sekmesine git
2. **Create new release**
3. Aynı AAB dosyasını yükle
4. **Rollout** → **Review and release**

---

## Adım 8: Güncelleme (Sonraki Versiyonlar)

Her güncellemede:

```bash
# pubspec.yaml'da version değiştir
# version: 1.0.0+1 → version: 1.0.1+2

flutter build appbundle --release
```

Google Play Console → Production → Create new release → Upload → Rollout

---

## ⚠️ Önemli Notlar

1. **Keystore yedekle!** `grade-ai-release-key.jks` dosyasını USB/cloud'a kopyala
2. **Privacy policy** gerekiyor. Web sitende `/privacy` sayfası ekle
3. **AdMob** için gerçek App ID ve Ad Unit ID'leri `.env`'e yaz
4. **Firebase** `google-services.json` dosyası `android/app/` altında olmalı
5. İlk review süresi: **1-7 gün**

---

Hazırlayan: Kimi AI
