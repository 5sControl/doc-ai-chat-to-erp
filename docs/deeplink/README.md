# Публикация deep links для `lmnotebook.pro`

## Что лежит в этой папке

| Файл | Куда выложить на сервере |
|------|---------------------------|
| `.well-known/assetlinks.json` | `https://lmnotebook.pro/.well-known/assetlinks.json` |
| `.well-known/apple-app-site-association` | `https://lmnotebook.pro/.well-known/apple-app-site-association` |

Скопируйте каталог **`.well-known`** в корень сайта домена `lmnotebook.pro` (как показано в колонке URL).

Требования: **HTTPS**, ответ **200**, без обязательной авторизации, желательно `Content-Type: application/json`.

Проверка:

```bash
curl -sI "https://lmnotebook.pro/.well-known/assetlinks.json"
curl -sI "https://lmnotebook.pro/.well-known/apple-app-site-association"
```

## Android (`assetlinks.json`)

- Поле `package_name` должно совпадать с `applicationId` в `android/app/build.gradle` (`com.englishingames.summishare`).
- В `sha256_cert_fingerprints` должен быть **SHA-256 ключа App signing** из Google Play Console (или дополнительно upload key, если используете).
- Второе отношение `delegate_permission/common.get_login_creds` нужно только если вы осознанно связываете приложение с **Credential Manager / Smart Lock**; для обычных App Links достаточно `delegate_permission/common.handle_all_urls`. Лишнее отношение обычно не мешает проверке ссылок.

## iOS (`apple-app-site-association`)

В AASA указаны Team ID и bundle id из проекта Xcode. В **Associated Domains** должны быть `applinks:lmnotebook.pro` (и другие домены при необходимости).

## Репозиторий

В `android/app/src/main/AndroidManifest.xml` должны быть те же HTTPS-хосты и префикс пути (`/invite`), что и на сайте, плюс `android:autoVerify="true"` для проверки App Links.
