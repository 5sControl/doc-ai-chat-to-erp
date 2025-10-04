# Summify Server API (FastAPI deployment)

This reference describes the FastAPI service located in the `API/` directory. Implementing the documented endpoints and behaviors allows the Summify mobile client to interact with the backend without modifications.

All routes are served over HTTPS in production. Unless noted otherwise, the service accepts and returns JSON encoded as UTF-8. Error payloads follow the shape `{ "detail": string }`.

## Health Check

`GET /`

Returns a simple status object confirming that the service is reachable.

#### Response (200 OK)

```json
{
  "message": "Your app is up",
  "root_path": ""    // root path override if set in configuration
}
```

## Summaries by URL (Quick Mode)

`POST /quick_sum`

Generates a short summary for a publicly accessible URL.

#### Request Body

```json
{
  "url": "https://example.com/article"
}
```

#### Response (200 OK)

```json
{
  "summary": "...concise summary...",
  "context_length": 523,    // number of words extracted from the source
  "response_length": 108    // number of words in the generated summary
}
```

#### Validation & Errors

- Invalid or unreachable URLs → `404` with `"detail": "Link processing error."`
- Image URLs (extensions such as `.jpg`, `.png`, etc.) → `400` with `"detail": "Image link is not supported."`

## Summaries by URL (Long Mode / Transcript)

`POST /url_to_summarize/`

Summarizes the content of a URL. Optionally switches to transcript mode for YouTube links.

#### Request Body

```json
{
  "url": "https://example.com/article",    // required
  "transcript": false                        // when true and URL is a YouTube link, returns timestamped key points
}
```

#### Response (200 OK)

When `transcript` is `false` (default):

```json
{
  "summary": "...detailed summary...",
  "context_length": 945,
  "response_length": 240
}
```

When `transcript` is `true` for YouTube links, the service returns the raw string produced by the LLM (expected to be JSON with `key_point`/`start` pairs).

#### Validation & Errors

Same URL validation rules as `/quick_sum`.

## Application Summaries (URL or User Text)

`POST /application_by_summarize/`

Backs the main mobile workflow. Accepts either a URL or raw text and can optionally answer follow-up questions.

#### Request Body

```json
{
  "url": "https://example.com/article",   // optional when sending context
  "context": "",                          // required when url is empty; must be >= 500 characters
  "type_summary": "short",                // "short", "long", or "quick_sum"
  "user_query": ""                        // optional follow-up question
}
```

#### Responses (200 OK)

- Summaries:

  ```json
  {
    "summary": "...",
    "context_length": 1024,
    "response_length": 256
  }
  ```

- Question answering (`user_query` provided):

  ```json
  {
    "answer": "The article argues that ..."
  }
  ```

#### Validation & Errors

- Invalid URL or image URL → same errors as `/quick_sum`.
- `context` provided but shorter than 500 characters → `400` with `"detail": "Text must be min. 500 char."`
- Neither `url` nor `context` supplied → `400` with `"detail": "URL/context not provided."`
- After preprocessing, contexts shorter than 100 words → `400` with `"detail": "The context is too short for a summary."`
- Cancelled background work → `400` with `"detail": "Task was cancelled"`.

## File Summaries and Q&A

`POST /application_by_summarize/uploadfile/`

Accepts an uploaded document, produces a summary, and optionally answers questions.

#### Request

- **Content-Type**: `multipart/form-data`
- **Query parameters**:
  - `type_summary` (`short` by default)
  - `user_query` (optional question string)
- **Body parts**:
  - `file` – binary payload. Supported extensions: `.docx`, `.doc`, `.rtf`, `.pdf`, `.txt`, `.epub`.

#### Responses (200 OK)

- Summary response:

  ```json
  {
    "summary": "...",
    "context_length": 2048,
    "response_length": 312
  }
  ```

- Question answering response (when `user_query` is supplied):

  ```json
  {
    "answer": "The report concludes that ..."
  }
  ```

#### Validation & Errors

- Unsupported file types → `415` with `"detail": "Unsupported file format"`
- File processed but resulting context < 100 words → `400` with `"detail": "The context is too short for a summary."`
- YouTube loading failures → `400` with `"detail": "This YouTube link is not supported."`

## Cross-Cutting Behavior

- Every request is logged and mirrored to the statistics service at `STATS_SERVICE_URL`. Failures to reach that service do not affect the API response.
- Responses include a `response_length` field (word count) in addition to `summary` and `context_length` so clients can display output size.
- The backend trims extremely long documents before summarization, reporting the percentage of original content retained (`process_text` keeps roughly the first 3,800 tokens).
- YouTube URLs are supported for both transcript (timestamped key points) and regular summarization flows.

## Unsupported Mobile Endpoints

The mobile client also references translation (`/ai-translator/...`), rating (`/ai-summarizer/django-api/applications/reviews/`), feature requests (`/django-api/applications/function-reports/`), and research (`/fastapi/application_by_summarize/`) endpoints. These routes are **not** implemented in the FastAPI service under `API/`; they are handled by separate services and must be provided independently if you are replacing the full backend.

