# Monita SDK

Monita SDK provides powerful monitoring and analytics capabilities for your Android applications, including request monitoring, analytics integration, and performance tracking.

## Installation

To integrate Monita SDK into your Android project, follow the steps below.

### Step 1: Add the JitPack Repository

Add the following lines to your root `build.gradle.kts` or `build.gradle` at the end of repositories:

```gradle
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}
```

### Step 2: Add the Dependencies

Include the Monita SDK and the Monita Adapter Library in your module-level `build.gradle.kts` or `build.gradle` file:

```gradle
dependencies {
    implementation 'com.github.rnadigital.monita-android-sdk:monita-android-sdk:v1.10.0'
    implementation 'com.github.rnadigital.monita-android-sdk:monita-adapter-library:v1.10.0'
    byteBuddy 'com.github.rnadigital.monita-android-sdk:monita-adapter-library:v1.10.0'
}
```

### Step 3: Byte Buddy Plugin Integration

Add the Byte Buddy Gradle plugin to your project by including the following in your `build.gradle.kts` or `build.gradle` file:

```gradle
plugins {
    id("net.bytebuddy.byte-buddy-gradle-plugin") version "1.15.5"
}
```

### Step 4: Sync the Project

Once you've added the dependencies, sync your project with Gradle by clicking **"Sync Now"** in Android Studio or running:

```bash
./gradlew build
```

## Usage

After successful integration, you can initialize Monita SDK in your application class:

```kotlin
import android.app.Application
import com.rnadigital.monita_android_sdk.MonitaSDK

class MyApplication : Application() {
    val token = "fe041147-0600-48ad-a04e-d3265becc4eb"

    override fun onCreate() {
        super.onCreate()
        MonitaSDK.Builder(this)
            .enableLogger(true)
            .setToken(token)
            .setBatchSize(10)
            .setCustomerId("123456")
            .setConsentString("Granted")
            .setSessionId("123456")
            .setAppVersion("1.0")
            .build {
                // Callback when initialization is complete
            }
    }
}
```

## Features

- Automatic request monitoring
- Analytics integration (Google, Facebook, Firebase)
- Performance tracking
- Easy to integrate

## Troubleshooting

If you encounter any issues:

1. Ensure that your GitHub repository has public access, or configure private access with a GitHub token.
2. Clear Gradle cache and sync again:
   ```bash
   ./gradlew clean --refresh-dependencies
   ```
3. Visit [JitPack.io](https://jitpack.io) and verify build status for your project.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For any issues or support, please reach out to [support@monita.com](mailto:support@monita.com).

