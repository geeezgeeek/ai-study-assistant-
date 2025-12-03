import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/study_set.dart';
import '../data/models/flashcard.dart';
import '../data/services/storage_service.dart';
import '../data/services/pdf_service.dart';
import '../data/services/ai_service.dart';

// Service Providers
final storageServiceProvider = Provider((ref) => StorageService());
final pdfServiceProvider = Provider((ref) => PdfService());
// Ideally, API key should come from secure storage or user input. 
// For now, we'll assume it's passed or set later. 
// We'll use a StateProvider for the API Key.
final apiKeyProvider = StateProvider<String>((ref) => '');

final aiServiceProvider = Provider((ref) {
  final apiKey = ref.watch(apiKeyProvider);
  return AiService(apiKey);
});

// Study State
class StudyState {
  final bool isLoading;
  final List<StudySet> studySets;
  final StudySet? currentSet;
  final String? error;

  StudyState({
    this.isLoading = false,
    this.studySets = const [],
    this.currentSet,
    this.error,
  });

  StudyState copyWith({
    bool? isLoading,
    List<StudySet>? studySets,
    StudySet? currentSet,
    String? error,
  }) {
    return StudyState(
      isLoading: isLoading ?? this.isLoading,
      studySets: studySets ?? this.studySets,
      currentSet: currentSet ?? this.currentSet,
      error: error ?? this.error,
    );
  }
}

class StudyNotifier extends StateNotifier<StudyState> {
  final StorageService _storage;
  final PdfService _pdf;
  final AiService _ai;

  StudyNotifier(this._storage, this._pdf, this._ai) : super(StudyState()) {
    loadSets();
  }

  void loadSets() {
    final sets = _storage.getStudySets();
    state = state.copyWith(studySets: sets);
  }

  Future<void> generateStudySet(String filePath, String title) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final text = await _pdf.extractText(filePath);
      if (text.isEmpty) throw Exception("No text found in PDF");

      final studySet = await _ai.generateStudySet(text, title);
      
      await _storage.saveStudySet(studySet);
      
      // Reload to include new set
      loadSets();
      state = state.copyWith(isLoading: false, currentSet: studySet);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectSet(StudySet set) {
    state = state.copyWith(currentSet: set);
  }

  Future<void> deleteSet(String id) async {
    await _storage.deleteStudySet(id);
    loadSets();
    if (state.currentSet?.id == id) {
      state = state.copyWith(currentSet: null);
    }
  }
  
  Future<void> updateFlashcard(Flashcard card) async {
     // In a real app, we'd update the specific card in Hive
     // For now, we rely on HiveObject's save() if we used it, or re-save the set.
     // Since Flashcard extends HiveObject, we can call card.save() if it's in a box.
     if (card.isInBox) {
       await card.save();
     }
     // Trigger UI rebuild if needed
     state = state.copyWith(); 
  }
}

final studyProvider = StateNotifierProvider<StudyNotifier, StudyState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final pdf = ref.watch(pdfServiceProvider);
  final ai = ref.watch(aiServiceProvider);
  return StudyNotifier(storage, pdf, ai);
});
