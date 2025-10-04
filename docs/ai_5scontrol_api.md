# Summify Mobile API Reference (ai.5scontrol.com)

This document describes the HTTP endpoints that the Summify Flutter mobile client calls on `https://ai.5scontrol.com`. Implementing these routes with the specified interfaces will allow the mobile app to function against a custom backend.

All requests use HTTPS. Unless noted otherwise, requests send and receive JSON with UTF-8 encoding. Error payloads are expected to be JSON objects containing a human-readable `detail` field.

## Common Concepts

- **Summary type** – When summarization is requested the client sets `type_summary` to either `short` or `long`.
- **Context length** – Successful summary responses include `context_length` (integer) describing the length of the processed source in tokens/characters, as returned by the existing service.
- **Error handling** – On failures the client attempts to parse the body as `{ "detail": string }` and surfaces that message to the user.

## Endpoints

### 1. Summarize Web Content

`POST /summarizer/application_by_summarize/`

Summarizes either a remote article (by URL) or raw text supplied by the user.

#### Request

```json
{
  "url": "https://example.com/article",   // required when summarizing by link; otherwise empty string
  "context": "",                          // raw text to summarize; required when url is empty
  "type_summary": "short"                 // "short" or "long"
}
```

The mobile app always includes both `url` and `context`, but populates only one. When summarizing text the client sends an empty string for `url` and inserts the text into `context`.

#### Response (200 OK)

```json
{
  "summary": "...shortened article...",
  "context_length": 523
}
```

#### Error Response

```json
{
  "detail": "Unable to fetch the provided URL"
}
```

### 2. Ask Questions About Web or Text Content

`POST /summarizer/application_by_summarize/`

The same route also supports follow-up questions about previously summarized content.

#### Request

```json
{
  "url": "https://example.com/article",   // provide the original URL or "" when using user text
  "context": "",                          // provide the original user text or "" when using a URL
  "user_query": "What is the main argument?",
  "type_summary": ""                      // client currently sends empty string
}
```

#### Response (200 OK)

```json
{
  "answer": "The article argues that ..."
}
```

### 3. Summarize Uploaded Files

`POST /summarizer/application_by_summarize/uploadfile/`

Processes an uploaded document and returns a summary.

#### Request

- **Headers**: `Content-Type: multipart/form-data`
- **Query parameters**: `type_summary` = `short` or `long`
- **Body parts**:
  - `file` – binary file to summarize. The mobile client uses the local filename when populating the multipart payload.

#### Response (200 OK)

```json
{
  "summary": "...shortened file contents...",
  "context_length": 2048
}
```

#### Error Response

```json
{
  "detail": "Unsupported file type"
}
```

### 4. Ask Questions About Uploaded Files

`POST /summarizer/application_by_summarize/uploadfile/`

The same upload endpoint supports answering questions about an uploaded document.

#### Request

- **Headers**: `Content-Type: multipart/form-data`
- **Query parameters**: `user_query` = question string
- **Body parts**:
  - `file` – binary file to analyze

#### Response (200 OK)

```json
{
  "answer": "The report concludes that ..."
}
```

### 5. Translate Text

`POST /ai-translator/ai-translator/translate-to/`

Provides machine translation for arbitrary text.

#### Request

```json
{
  "text": "Hello, world!",
  "language": "es"    // ISO code representing the destination language
}
```

#### Response (200 OK)

```json
{
  "translated_text": "¡Hola, mundo!"
}
```

### 6. Submit a Rating for a Generated Summary

`POST /ai-summarizer/django-api/applications/reviews/`

Records user feedback about a generated summary.

#### Request

```json
{
  "comment": "Really helpful",
  "device": "ios",            // arbitrary device identifier supplied by the app
  "grade": 5,                  // integer rating
  "summary": "...",           // the summary text being rated
  "source": "https://..."     // original source URL
}
```

#### Response (200 OK)

Empty body expected; the client treats HTTP 200 as success.

### 7. Request a New Feature

`POST /django-api/applications/function-reports/`

Collects feature requests and general feedback from users.

#### Request

```json
{
  "getMoreSummaries": true,
  "addTranslation": false,
  "askAQuestions": true,
  "readBook": false,
  "addLang": "de",          // free-form text describing additional languages
  "name": "Alex",
  "email": "alex@example.com",
  "message": "Offline mode would be great."
}
```

#### Response (201 Created)

Empty body expected; the client interprets HTTP 201 as success.

### 8. Research Endpoint (Reserved)

`POST /fastapi/application_by_summarize/`

The current mobile build defines this route but does not invoke it. Historically it appears intended for question-answering flows similar to endpoint 2. If re-enabled, follow the same conventions: JSON payload containing `url`, `context`, `user_query`, and optional `type_summary`, with responses shaped as `{ "answer": string }` on success.

## Implementation Notes

- Responses are parsed as plain text first by the Dio client, then decoded from JSON. Ensure the service returns raw JSON strings (not already compressed or wrapped) to maintain compatibility.
- Maintain consistent casing for JSON keys exactly as shown; the client expects snake_case fields (e.g., `type_summary`, `context_length`).
- When returning errors, prefer descriptive `detail` messages to surface actionable feedback in the UI.

