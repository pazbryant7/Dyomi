# Repository Instructions

## Project Shape

- This is a Gradle 9.6.1 Android/Kotlin multi-module app; `app` is the executable Android application and the other included projects are libraries, shared logic, sources, UI, translations, or the baseline-profile test project.
- `source-api`, `source-local`, `i18n`, and `i18n-sy` are Kotlin Multiplatform modules. Keep shared code in `commonMain` and Android-only code in `androidMain`.
- `data/src/main/sqldelight` is the SQLDelight schema/query source. Database interfaces and schema outputs are generated; edit `.sq` files rather than generated build output.
- `gradle/build-logic` is an included Gradle build containing the convention plugins used by the root and modules. Changes there can affect the whole repository.
- This fork marks downstream changes in upstream-shared code with `// SY -->` and `// SY <--`; preserve those markers when editing such regions.

## Toolchain And Checks

- Use `./gradlew`; the configured toolchain is JDK 17, Android compile SDK 37, target SDK 36, minimum SDK 26, and NDK 29.
- Gradle needs a valid Android SDK through `ANDROID_HOME` or `local.properties` (`sdk.dir`); `local.properties` is ignored.
- Pull-request CI runs `./gradlew spotlessCheck assembleDebug`. Release CI runs `spotlessCheck`, then `assembleRelease`, then `test`; run the relevant focused test locally because the pull-request build does not run unit tests.
- Apply formatting with `./gradlew spotlessApply`; check it with `./gradlew spotlessCheck`. Spotless covers Kotlin, Kotlin Gradle scripts, and XML using the repository `.editorconfig`.
- Run all JVM unit tests with `./gradlew test`. Run one test with, for example, `./gradlew :domain:testDebugUnitTest --tests 'tachiyomi.domain.manga.interactor.FetchIntervalTest'`.
- After SQLDelight changes, use `./gradlew :data:generateSqlDelightInterface` to regenerate interfaces and `./gradlew :data:verifySqlDelightMigration` to verify migrations.
- Baseline profile generation is an instrumented managed-device task: `./gradlew :app:generateBaselineProfile` uses the configured Pixel 6 API 34 device.

## Build Inputs

- Release tasks apply Google Services and Crashlytics. CI injects the ignored `app/google-services.json` and `app/src/main/assets/client_secrets.json`; do not commit either file or fabricate credentials.
