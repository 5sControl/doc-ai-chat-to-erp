# Quiz Generation API Specification

## Overview

This document specifies the API endpoint for generating quiz questions from document content. The API generates multiple-choice questions to test knowledge comprehension of the provided text.

## Base URL

```
https://employees-training.com/api/v1/quizzes
```

## Endpoint

### Generate Quiz from Text

`POST /quizzes/generate`

Generates a quiz with multiple-choice questions based on the provided document text.

#### Request

**Headers:**
```
Content-Type: application/json
```

**Body:**
```json
{
  "text": "Full document text content here...",
  "num_questions": 5,
  "difficulty": "medium"
}
```

**Parameters:**
- `text` (string, required) - The full text content of the document to generate questions from
- `num_questions` (integer, optional) - Number of questions to generate. Default: 5. Range: 3-10
- `difficulty` (string, optional) - Difficulty level: "easy", "medium", "hard". Default: "medium"

#### Response (200 OK)

```json
{
  "quiz_id": "quiz_123456",
  "questions": [
    {
      "id": "q1",
      "question": "What is the main topic discussed in the document?",
      "options": [
        {
          "id": "a1",
          "text": "Time management techniques"
        },
        {
          "id": "a2",
          "text": "Productivity strategies"
        },
        {
          "id": "a3",
          "text": "Goal setting methods"
        },
        {
          "id": "a4",
          "text": "Communication skills"
        }
      ],
      "correct_answer_id": "a2",
      "explanation": "The document primarily focuses on productivity strategies as outlined in the introduction."
    },
    {
      "id": "q2",
      "question": "According to the document, what is the first step to improve productivity?",
      "options": [
        {
          "id": "a5",
          "text": "Set clear goals"
        },
        {
          "id": "a6",
          "text": "Eliminate distractions"
        },
        {
          "id": "a7",
          "text": "Create a daily schedule"
        },
        {
          "id": "a8",
          "text": "Track your time"
        }
      ],
      "correct_answer_id": "a5",
      "explanation": "The document states that setting clear goals is the foundational step for improving productivity."
    }
  ],
  "generated_at": "2024-01-15T10:30:00Z"
}
```

**Response Fields:**
- `quiz_id` (string) - Unique identifier for the generated quiz
- `questions` (array) - List of quiz questions
  - `id` (string) - Unique question identifier
  - `question` (string) - The question text
  - `options` (array) - Array of answer options (always 4 options)
    - `id` (string) - Unique option identifier
    - `text` (string) - Option text
  - `correct_answer_id` (string) - ID of the correct answer option
  - `explanation` (string) - Explanation of why the answer is correct
- `generated_at` (string, ISO 8601) - Timestamp when the quiz was generated

#### Error Responses

**400 Bad Request** - Invalid input parameters
```json
{
  "detail": "Invalid number of questions. Must be between 3 and 10."
}
```

**422 Unprocessable Entity** - Text too short or invalid
```json
{
  "detail": "Text content is too short to generate questions. Minimum 500 characters required."
}
```

**500 Internal Server Error** - Server error during generation
```json
{
  "detail": "Failed to generate quiz questions. Please try again."
}
```

## Example Usage

### Request Example

```bash
curl -X POST https://employees-training.com/api/v1/quizzes/generate \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Atomic Habits is a book about building good habits and breaking bad ones. The author, James Clear, explains that small changes can make a remarkable difference. The key is to focus on systems rather than goals...",
    "num_questions": 5,
    "difficulty": "medium"
  }'
```

### Response Example

```json
{
  "quiz_id": "quiz_abc123",
  "questions": [
    {
      "id": "q1",
      "question": "What is the main focus of Atomic Habits?",
      "options": [
        {"id": "a1", "text": "Building good habits and breaking bad ones"},
        {"id": "a2", "text": "Setting long-term goals"},
        {"id": "a3", "text": "Time management techniques"},
        {"id": "a4", "text": "Financial planning strategies"}
      ],
      "correct_answer_id": "a1",
      "explanation": "The book's primary focus is on building good habits and breaking bad ones, as stated in the introduction."
    }
  ],
  "generated_at": "2024-01-15T10:30:00Z"
}
```

## Implementation Notes

1. **Question Quality**: Questions should test comprehension of key concepts, not just memorization of facts
2. **Option Variety**: All 4 options should be plausible, with only one clearly correct answer
3. **Text Length**: Minimum text length of 500 characters is recommended for quality questions
4. **Question Count**: Default to 5 questions, but allow 3-10 questions per quiz
5. **Explanations**: Each question should include a brief explanation to help users learn
6. **Idempotency**: Generating a quiz with the same text may produce different questions (not guaranteed to be identical)

## Integration with Flutter App

The Flutter app should:
1. Send document text (summary or annotation) to this endpoint
2. Parse the response and store quiz data locally
3. Display questions one at a time with multiple-choice options
4. Track user answers and compare with correct answers
5. Show results with explanations after completion
6. Allow quiz retake/reset functionality

---

## Продолжение следует...

### Integration Testing

**TODO: Create integration tests for quiz generation API**

The following integration tests should be implemented to ensure the quiz generation API works correctly:

#### Test Cases to Implement:

1. **Successful Quiz Generation**
   - Test: Generate quiz with valid text content
   - Expected: Returns 200 OK with valid quiz structure
   - Verify: All questions have 4 options, correct_answer_id exists, explanations are present

2. **Text Length Validation**
   - Test: Send text shorter than 500 characters
   - Expected: Returns 422 Unprocessable Entity with appropriate error message
   - Verify: Error message indicates minimum text length requirement

3. **Question Count Validation**
   - Test: Request quiz with num_questions outside valid range (e.g., 2 or 11)
   - Expected: Returns 400 Bad Request with validation error
   - Verify: Error message specifies valid range (3-10)

4. **Difficulty Level Handling**
   - Test: Generate quizzes with different difficulty levels (easy, medium, hard)
   - Expected: Returns 200 OK for all valid difficulty levels
   - Verify: Questions vary appropriately by difficulty

5. **Error Handling**
   - Test: Send malformed JSON request
   - Expected: Returns 400 Bad Request
   - Verify: Error message is descriptive

6. **Response Structure Validation**
   - Test: Verify all required fields are present in response
   - Expected: quiz_id, questions array, generated_at timestamp
   - Verify: Each question has id, question text, options array, correct_answer_id, explanation

7. **Option Validation**
   - Test: Verify each question has exactly 4 options
   - Expected: All questions contain 4 options
   - Verify: Each option has id and text fields

8. **Correct Answer Validation**
   - Test: Verify correct_answer_id matches one of the option IDs
   - Expected: correct_answer_id exists in options array
   - Verify: No orphaned correct_answer_id references

#### Test Implementation Notes:

- Use Postman collection or similar tool for manual testing
- Create automated integration tests using preferred testing framework
- Test with various document types and lengths
- Verify response times are acceptable (< 5 seconds for typical requests)
- Test concurrent requests handling
- Verify error responses follow consistent format

#### Example Test Request:

```bash
POST https://employees-training.com/api/v1/quizzes/generate
Content-Type: application/json

{
  "text": "Atomic Habits is a comprehensive guide to building good habits...",
  "num_questions": 5,
  "difficulty": "medium"
}
```

#### Example Test Assertions:

```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response has quiz_id", function () {
    const response = pm.response.json();
    pm.expect(response).to.have.property('quiz_id');
});

pm.test("Response has questions array", function () {
    const response = pm.response.json();
    pm.expect(response).to.have.property('questions');
    pm.expect(response.questions).to.be.an('array');
    pm.expect(response.questions.length).to.equal(5);
});

pm.test("Each question has 4 options", function () {
    const response = pm.response.json();
    response.questions.forEach(function(question) {
        pm.expect(question.options).to.have.lengthOf(4);
    });
});

pm.test("Correct answer ID exists in options", function () {
    const response = pm.response.json();
    response.questions.forEach(function(question) {
        const optionIds = question.options.map(opt => opt.id);
        pm.expect(optionIds).to.include(question.correct_answer_id);
    });
});
```

**Продолжение следует...**

