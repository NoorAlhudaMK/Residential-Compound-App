plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

import org.jetbrains.kotlin.gradle.dsl.JvmTarget

        android {
            namespace = "com.example.residential_compound_app"
            compileSdk = flutter.compileSdkVersion
            ndkVersion = flutter.ndkVersion

            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }

            defaultConfig {
                applicationId = "com.example.residential_compound_app"
                minSdk = flutter.minSdkVersion
                targetSdk = flutter.targetSdkVersion
                versionCode = flutter.versionCode
                versionName = flutter.versionName
            }

            buildTypes {
                release {
                    signingConfig = signingConfigs.getByName("debug")
                }
            }
        }

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}