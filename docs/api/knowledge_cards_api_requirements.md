# Knowledge Cards API - Требования к серверному Endpoint

## Обзор

Данный документ описывает требования к API endpoint для генерации/получения карточек знаний (Knowledge Cards) из саммари текста. Карточки знаний - это структурированные элементы контента, которые помогают пользователям лучше усваивать ключевую информацию из обработанных документов.

## Текущая реализация

Endpoint уже используется в приложении:
- **URL**: `https://employees-training.com/api/v1/knowledge-cards`
- **Метод**: `POST`
- **Аутентификация**: X-API-Key header

## 1. Endpoint Спецификация

### 1.1 Request

**URL**: `POST /api/v1/knowledge-cards`

**Headers**:
```
X-API-Key: <api_key>
Content-Type: application/json
```

**Request Body**:
```json
{
  "text": "string",           // Обязательный. Текст саммари для анализа
  "num_cards": 5,             // Опциональный. Количество карточек (по умолчанию: 5)
  "card_types": ["thesis", "term", "conclusion", "insight"], // Опциональный. Типы карточек
  "difficulty": "medium",     // Опциональный. Уровень сложности: "easy", "medium", "hard"
  "language": "en"            // Опциональный. Язык контента (по умолчанию: "en")
}
```

### 1.2 Response

**Success Response** (200 OK):
```json
{
  "cards": [
    {
      "id": "string",              // Уникальный ID карточки (UUID)
      "type": "thesis",            // Тип: "thesis" | "term" | "conclusion" | "insight"
      "title": "string",           // Заголовок карточки (краткое название)
      "content": "string",         // Основное содержание карточки
      "explanation": "string",     // Опциональное. Дополнительное объяснение
      "relevance_score": 0.95      // Опциональное. Оценка релевантности (0-1)
    }
  ],
  "generated_at": "2026-01-21T10:30:00Z",
  "total_cards": 5,
  "processing_time_ms": 1234
}
```

**Error Responses**:

`400 Bad Request`:
```json
{
  "detail": "Text is required and must not be empty"
}
```

`422 Unprocessable Entity`:
```json
{
  "detail": "Text is too short for knowledge extraction (minimum 100 characters)"
}
```

`429 Too Many Requests`:
```json
{
  "detail": "Rate limit exceeded. Please try again later.",
  "retry_after": 60
}
```

`500 Internal Server Error`:
```json
{
  "detail": "Failed to extract knowledge cards: <error_message>"
}
```

## 2. Типы Карточек Знаний

### 2.1 Thesis (Тезис)
- **Назначение**: Главные идеи и утверждения из текста
- **Пример**: "Ежедневные привычки формируют 40% наших действий"
- **Характеристики**: Должен быть четким, проверяемым утверждением

### 2.2 Term (Термин/Определение)
- **Назначение**: Ключевые понятия, термины и их определения
- **Пример**: "Атомные привычки - небольшие изменения, которые приводят к значительным результатам"
- **Характеристики**: Содержит термин + определение

### 2.3 Conclusion (Вывод)
- **Назначение**: Основные выводы и заключения из текста
- **Пример**: "Для формирования устойчивой привычки требуется в среднем 66 дней"
- **Характеристики**: Синтезированный инсайт из нескольких фактов

### 2.4 Insight (Инсайт/Применение)
- **Назначение**: Практические советы и применимые знания
- **Пример**: "Начните с привычки, которая занимает менее 2 минут в день"
- **Характеристики**: Actionable рекомендация для пользователя

## 3. Требования к генерации карточек

### 3.1 Качество контента

1. **Релевантность**: Карточки должны извлекать наиболее важную информацию из текста
2. **Уникальность**: Избегать дублирования информации между карточками
3. **Ясность**: Текст должен быть понятным без дополнительного контекста
4. **Сбалансированность**: Распределение по типам карточек должно отражать содержание текста

### 3.2 Технические требования

1. **Скорость**: Генерация должна занимать не более 10 секунд
2. **Минимальная длина текста**: 100 символов
3. **Максимальная длина текста**: 50,000 символов
4. **Количество карточек**: От 3 до 15 карточек

### 3.3 Форматирование

1. **Title**: Максимум 80 символов, без точки в конце
2. **Content**: От 50 до 500 символов
3. **Explanation**: Опционально, максимум 300 символов
4. **ID**: UUID v4 формат

## 4. Рекомендуемый ML Pipeline

### 4.1 Архитектура

```
Input Text
    ↓
Text Preprocessing & Chunking
    ↓
LLM-based Extraction (GPT-4, Claude, etc.)
    ↓
Post-processing & Validation
    ↓
Ranking by Relevance
    ↓
Response Formation
```

### 4.2 Используемые модели

**Рекомендуемые LLM**:
- OpenAI GPT-4 / GPT-4 Turbo
- Anthropic Claude 3 Sonnet/Opus
- Google Gemini Pro

**Альтернатива** (для снижения затрат):
- Fine-tuned модели на базе Llama 3 или Mistral
- Комбинация NLP техник + smaller LLM

### 4.3 Prompt Engineering

Пример системного промпта:
```
You are a knowledge extraction expert. Extract key knowledge cards from the provided text.
For each card:
- Identify the type (thesis, term, conclusion, insight)
- Create a concise title
- Write clear, standalone content
- Optionally add explanation for complex concepts

Focus on the most important and actionable information.
```

## 5. Оптимизация и кеширование

### 5.1 Кеширование

Рекомендуется кешировать результаты для идентичных текстов:
- **Key**: Hash of input text + parameters
- **TTL**: 7 дней
- **Storage**: Redis или аналог

### 5.2 Rate Limiting

- **По пользователю**: 10 запросов в минуту
- **По IP**: 20 запросов в минуту
- **Глобально**: В зависимости от мощности инфраструктуры

## 6. Мониторинг и аналитика

### 6.1 Метрики для отслеживания

1. **Performance**:
   - Average response time
   - P95, P99 latency
   - Success rate

2. **Quality**:
   - User feedback (saved/unsaved cards ratio)
   - Card type distribution
   - Average relevance scores

3. **Usage**:
   - Requests per day
   - Unique users
   - Popular content types

### 6.2 Логирование

Логировать для каждого запроса:
- Request ID
- Input text length
- Number of cards generated
- Processing time
- Any errors

## 7. Безопасность

### 7.1 Валидация

- Проверка длины входного текста
- Санитизация HTML/специальных символов
- Проверка на вредоносный контент

### 7.2 Защита от злоупотреблений

- Rate limiting
- API key rotation
- IP blocking для подозрительной активности

## 8. Примеры использования

### 8.1 Базовый запрос

```bash
curl -X POST https://employees-training.com/api/v1/knowledge-cards \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Atomic Habits by James Clear explores how small changes can lead to remarkable results. The key is to focus on systems rather than goals. A habit is a behavior that has been repeated enough times to become automatic. The book introduces the concept of the aggregation of marginal gains - the idea that small improvements can compound into significant changes over time."
  }'
```

### 8.2 Запрос с параметрами

```bash
curl -X POST https://employees-training.com/api/v1/knowledge-cards \
  -H "X-API-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "...",
    "num_cards": 8,
    "card_types": ["thesis", "insight"],
    "difficulty": "easy",
    "language": "en"
  }'
```

## 9. Версионирование API

Текущая версия: **v1**

При внесении breaking changes:
- Создать новую версию endpoint (v2)
- Поддерживать v1 минимум 6 месяцев
- Уведомлять клиентов за 3 месяца до deprecation

## 10. Roadmap и улучшения

### Краткосрочные (1-3 месяца)
- [ ] Добавить поддержку batch requests
- [ ] Улучшить качество extraction для коротких текстов
- [ ] Добавить поддержку большего количества языков

### Среднесрочные (3-6 месяцев)
- [ ] Personalized cards на основе истории пользователя
- [ ] Visual cards с изображениями/диаграммами
- [ ] Integration с spaced repetition системой

### Долгосрочные (6-12 месяцев)
- [ ] Multi-document knowledge graph
- [ ] Interactive cards с квизами
- [ ] AI-powered card recommendations

## 11. Контакты и поддержка

Для вопросов по API:
- Email: api-support@employees-training.com
- Documentation: https://docs.employees-training.com/api/knowledge-cards
- Status Page: https://status.employees-training.com

---

**Версия документа**: 1.0  
**Дата последнего обновления**: 21.01.2026  
**Автор**: Development Team
