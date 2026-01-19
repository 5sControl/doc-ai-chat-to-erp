# Quiz Assets

This directory contains pre-generated quiz JSON files for library documents. These quizzes are bundled with the app to avoid unnecessary API calls and provide instant quiz access for demo/library content.

## Current Demo Quizzes

- `the_7_habits_quiz.json` - Quiz for "The 7 Habits of Highly Effective People"

## How to Add More Demo Quizzes

### Option 1: Generate from App (Recommended)

1. Run the app in debug mode
2. Navigate to a library document that doesn't have a demo quiz
3. Generate the quiz normally (it will call the API)
4. The quiz is automatically saved in HydratedBloc storage
5. Extract the JSON from app storage:
   - iOS: `~/Library/Developer/CoreSimulator/Devices/[DEVICE_ID]/data/Containers/Data/Application/[APP_ID]/Library/Application Support/`
   - Android: Use Device File Explorer in Android Studio
   - Or use debugging tools to inspect HydratedBloc state
6. Copy the quiz JSON and save it to this directory as `{book_key}_quiz.json`
7. Update the mapping in `lib/services/quiz_asset_loader.dart`

### Option 2: Use the Generation Script

1. Navigate to the project root
2. Edit `scripts/generate_demo_quiz.dart`:
   - Replace the `summaryText` with the book summary
   - Update the output filename
3. Run: `dart run scripts/generate_demo_quiz.dart` (requires network access)
4. The quiz JSON will be saved to this directory
5. Update the mapping in `lib/services/quiz_asset_loader.dart`

### Option 3: Manual Creation

If you want to create a custom quiz:

1. Create a new JSON file following the format below
2. Save it to this directory
3. Update the mapping in `lib/services/quiz_asset_loader.dart`

## JSON Format

```json
{
  "quiz_id": "demo_book_name",
  "documentKey": "Book Title",
  "generated_at": "2026-01-19T00:00:00Z",
  "questions": [
    {
      "id": "q1",
      "question": "What is the main concept?",
      "options": [
        {"id": "a", "text": "Option A"},
        {"id": "b", "text": "Option B"},
        {"id": "c", "text": "Option C"},
        {"id": "d", "text": "Option D"}
      ],
      "correct_answer_id": "a",
      "explanation": "Detailed explanation of why this is correct..."
    }
  ]
}
```

### Field Descriptions

- `quiz_id`: Unique identifier (e.g., "demo_book_name")
- `documentKey`: Must match the library document title exactly
- `generated_at`: ISO 8601 timestamp
- `questions`: Array of question objects
  - `id`: Unique question identifier (e.g., "q1", "q2")
  - `question`: The question text
  - `options`: Array of 4 option objects
    - `id`: Unique option identifier (e.g., "a", "b", "c", "d")
    - `text`: Option text
  - `correct_answer_id`: ID of the correct option
  - `explanation`: Detailed explanation shown after answering

## Updating the Asset Mapping

After adding a new quiz JSON file, update `lib/services/quiz_asset_loader.dart`:

```dart
static const Map<String, String> _quizAssets = {
  'The 7 Habits of Highly Effective People': 'the_7_habits_quiz.json',
  'Your New Book Title': 'your_new_book_quiz.json', // Add your mapping here
};
```

The key must match the `documentKey` in `lib/bloc/library/library_documents.dart`.

## Benefits of Pre-generated Quizzes

1. **Instant Access**: No waiting for API generation
2. **Reduced Server Load**: Fewer API calls
3. **Offline Support**: Quizzes work without internet
4. **Consistent Quality**: Manually reviewed questions
5. **Better UX**: Immediate quiz availability for library content

## Notes

- Quiz JSON files are loaded via Flutter's `rootBundle.loadString()`
- Failed asset loads gracefully fall back to API generation
- Asset quizzes are cached in HydratedBloc like API-generated quizzes
- Users can still generate custom quizzes for their own documents via API
