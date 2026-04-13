# Phase 3: PostgreSQL + API v2 — Backend Modification Plan

## Current Backend State

- **Framework:** FastAPI (Python 3.11), served by Uvicorn
- **Location:** `api.lmnotebookpro.com/python-api/app/`
- **Database:** None (only Qdrant vector DB for RAG)
- **Auth:** Single shared API key (`X-API-Key`) — no per-user auth
- **Architecture:** Fully stateless — no persistent user data

## What Needs to Change

### 1. Add PostgreSQL

Add PostgreSQL as a Docker service in `docker-compose.yml` and create the schema.

**docker-compose.yml** — add service:
```yaml
  postgres:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: lmnotebook
      POSTGRES_USER: ${POSTGRES_USER:-lmnotebook}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
```

**Dependencies** — add to `python-api/requirements.txt`:
```
asyncpg==0.30.0
sqlalchemy[asyncio]==2.0.36
alembic==1.14.1
firebase-admin==6.6.0
```

### 2. Database Schema

Create via Alembic migration in `python-api/app/db/`:

```sql
-- users: linked to Firebase Auth
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    firebase_uid TEXT UNIQUE NOT NULL,
    email TEXT,
    display_name TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- documents: the central entity, one per URL/file/text
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    source_type TEXT NOT NULL CHECK (source_type IN ('url', 'text', 'file')),
    source_url TEXT,
    title TEXT NOT NULL,
    image_url TEXT,
    original_text TEXT,
    file_storage_key TEXT,
    short_summary TEXT,
    long_summary TEXT,
    short_summary_status TEXT DEFAULT 'initial',
    long_summary_status TEXT DEFAULT 'initial',
    context_length INT,
    is_blocked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE knowledge_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID REFERENCES documents(id) ON DELETE CASCADE NOT NULL,
    card_type TEXT NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    explanation TEXT,
    is_saved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE quizzes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID REFERENCES documents(id) ON DELETE CASCADE NOT NULL,
    questions JSONB NOT NULL DEFAULT '[]',
    user_answers JSONB DEFAULT '[]',
    status TEXT DEFAULT 'initial',
    score INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE research_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID REFERENCES documents(id) ON DELETE CASCADE NOT NULL,
    sort_order INT NOT NULL,
    question TEXT NOT NULL,
    answer TEXT,
    status TEXT DEFAULT 'loading',
    is_liked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID REFERENCES documents(id) ON DELETE CASCADE NOT NULL,
    summary_type TEXT NOT NULL CHECK (summary_type IN ('short', 'long')),
    language TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_documents_user_id ON documents(user_id);
CREATE INDEX idx_documents_created_at ON documents(created_at DESC);
CREATE INDEX idx_knowledge_cards_document_id ON knowledge_cards(document_id);
CREATE INDEX idx_quizzes_document_id ON quizzes(document_id);
CREATE INDEX idx_research_messages_document_id ON research_messages(document_id);
CREATE INDEX idx_translations_document_id ON translations(document_id);
```

### 3. Firebase Auth Middleware

New middleware in `python-api/app/middleware/firebase_auth.py`:

- Validate `Authorization: Bearer <firebase_id_token>` header
- Verify token with `firebase_admin.auth.verify_id_token()`
- Get or create `users` row by `firebase_uid`
- Attach `user_id` to request state
- Applied to `/api/v2/*` routes only (v1 stays as-is)

### 4. New API v2 Routes

All under `/api/v2/` prefix, all require Firebase auth.

Create `python-api/app/routes/documents_routes.py`:

| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| GET | `/api/v2/documents` | `list_documents` | List user's documents (paginated) |
| POST | `/api/v2/documents` | `create_document` | Create document + trigger summarization |
| GET | `/api/v2/documents/{id}` | `get_document` | Full document with all related data |
| DELETE | `/api/v2/documents/{id}` | `delete_document` | Delete document + cascade |
| POST | `/api/v2/documents/migrate` | `migrate_document` | Accept bulk data from old local storage |
| GET | `/api/v2/documents/{id}/cards` | `get_cards` | Knowledge cards for document |
| PATCH | `/api/v2/documents/{id}/cards/{card_id}` | `update_card` | Toggle is_saved |
| GET | `/api/v2/documents/{id}/quiz` | `get_quiz` | Quiz for document |
| PUT | `/api/v2/documents/{id}/quiz` | `update_quiz` | Update answers/progress |
| GET | `/api/v2/documents/{id}/chat` | `get_chat` | Chat history |
| POST | `/api/v2/documents/{id}/chat` | `send_message` | Ask question (saves + returns answer) |
| PUT | `/api/v2/user/settings` | `update_settings` | Save user settings |

### 5. File Storage

For PDF/DOCX uploads, store files on disk or S3-compatible storage:

- **Option A (simple):** Local disk volume mounted in Docker (`/data/uploads/`)
- **Option B (scalable):** S3-compatible storage (MinIO self-hosted or AWS S3)

Store `file_storage_key` in `documents` table. On `/questions/files` endpoint,
read from storage by `document_id` instead of re-uploading.

### 6. Migration Endpoint Detail

`POST /api/v2/documents/migrate` accepts a JSON payload:

```json
{
  "local_key": "https://example.com/article",
  "source_type": "url",
  "title": "Article Title",
  "image_url": "https://...",
  "original_text": "...",
  "short_summary": "...",
  "long_summary": "...",
  "knowledge_cards": [...],
  "quiz": {...},
  "research_messages": [...],
  "translations": [...]
}
```

Returns: `{ "document_id": "uuid", "card_ids": {...}, "quiz_id": "uuid" }`

### 7. Backward Compatibility

- All existing `/api/v1/*` endpoints remain unchanged
- `X-API-Key` auth continues to work for v1
- v2 endpoints require Firebase token
- Flutter app can use v1 for old local documents and v2 for new/migrated ones

### 8. New Files to Create

```
python-api/app/
├── db/
│   ├── __init__.py
│   ├── database.py          # AsyncSession factory, engine
│   ├── models.py            # SQLAlchemy ORM models
│   └── migrations/          # Alembic migrations
├── middleware/
│   └── firebase_auth.py     # Firebase ID token verification
├── routes/
│   └── documents_routes.py  # All /api/v2/ endpoints
├── services/
│   ├── document_service.py  # CRUD logic for documents + related
│   └── file_storage.py      # File upload/download abstraction
└── schemas/
    └── document_schemas.py  # Pydantic models for v2 requests/responses
```

### 9. Environment Variables to Add

```
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=lmnotebook
POSTGRES_USER=lmnotebook
POSTGRES_PASSWORD=<secret>
FIREBASE_SERVICE_ACCOUNT_KEY=<path or JSON>
FILE_STORAGE_PATH=/data/uploads
```

### 10. Implementation Order

1. Add PostgreSQL to docker-compose + create schema via Alembic
2. Add `firebase-admin` + auth middleware for v2 routes
3. Implement `POST /api/v2/documents` (create + summarize)
4. Implement `GET /api/v2/documents` (list)
5. Implement `GET /api/v2/documents/{id}` (detail)
6. Implement `POST /api/v2/documents/migrate` (for lazy migration)
7. Implement remaining CRUD endpoints (cards, quiz, chat, translations)
8. Add file storage for uploads
9. Test with Flutter client
