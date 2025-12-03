import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/flashcard.dart';
import '../models/quiz_question.dart';
import '../models/study_set.dart';

class AiService {
  final String apiKey;

  AiService(this.apiKey);

  Future<StudySet> generateStudySet(String text, String title) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
    );

    final prompt = '''
      Analyze the following text and generate a study set.
      Return a VALID JSON object with the following structure:
      {
        "flashcards": [
          {"front": "Question or Term", "back": "Answer or Definition"}
        ],
        "questions": [
          {
            "question": "Multiple choice question text",
            "options": ["Option A", "Option B", "Option C", "Option D"],
            "correctIndex": 0, // Integer 0-3
            "explanation": "Why this is correct"
          }
        ]
      }
      
      Generate at least 5 flashcards and 5 questions if possible.
      Make the content educational and accurate.
      
      Text:
      $text
    ''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text == null) {
      throw Exception('Failed to generate content: No response from AI');
    }

    try {
      // Clean up potential markdown code blocks if the model adds them despite JSON mime type
      String jsonString = response.text!;
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.replaceAll('```json', '').replaceAll('```', '');
      }

      final Map<String, dynamic> data = json.decode(jsonString);
      
      final String setId = DateTime.now().millisecondsSinceEpoch.toString();

      final List<Flashcard> flashcards = (data['flashcards'] as List).map((item) {
        return Flashcard(
          front: item['front'],
          back: item['back'],
          deckId: setId,
        );
      }).toList();

      final List<QuizQuestion> questions = (data['questions'] as List).map((item) {
        return QuizQuestion(
          question: item['question'],
          options: List<String>.from(item['options']),
          correctIndex: item['correctIndex'],
          explanation: item['explanation'],
          deckId: setId,
        );
      }).toList();

      return StudySet(
        id: setId,
        name: title,
        createdAt: DateTime.now(),
        flashcards: flashcards,
        questions: questions,
      );

    } catch (e) {
      throw Exception('Failed to parse AI response: $e');
    }
  }
}
