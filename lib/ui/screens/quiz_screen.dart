import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/study_provider.dart';
import '../../providers/activity_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentIndex = 0;
  int? _selectedOption;
  int _score = 0;
  bool _isAnswered = false;
  bool _isFinished = false;

  void _submitAnswer() {
    if (_selectedOption == null) return;

    final currentSet = ref.read(studyProvider).currentSet;
    final question = currentSet!.questions[_currentIndex];

    setState(() {
      _isAnswered = true;
      if (_selectedOption == question.correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    final currentSet = ref.read(studyProvider).currentSet;
    if (_currentIndex < currentSet!.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _isAnswered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    setState(() {
      _isFinished = true;
    });
    // Log activity
    final currentSet = ref.read(studyProvider).currentSet;
    ref.read(activityProvider.notifier).logProgress(questions: currentSet!.questions.length);
  }

  @override
  Widget build(BuildContext context) {
    final currentSet = ref.watch(studyProvider).currentSet;

    if (currentSet == null) {
      return const Scaffold(body: Center(child: Text('No set selected')));
    }

    if (_isFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Results')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              Text(
                'Score: $_score / ${currentSet.questions.length}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final question = currentSet.questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${currentSet.questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question.question,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Options
            ...List.generate(question.options.length, (index) {
              final isCorrect = index == question.correctIndex;
              final isSelected = index == _selectedOption;
              
              Color? tileColor;
              if (_isAnswered) {
                if (isCorrect) tileColor = Colors.green.withOpacity(0.2);
                if (isSelected && !isCorrect) tileColor = Colors.red.withOpacity(0.2);
              }

              return Card(
                color: tileColor,
                margin: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<int>(
                  value: index,
                  groupValue: _selectedOption,
                  onChanged: _isAnswered ? null : (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                  title: Text(question.options[index]),
                ),
              );
            }),
            
            // Explanation
            if (_isAnswered) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Explanation: ${question.explanation}',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ),
            ],
            
            const Spacer(),
            
            // Action Button
            FilledButton(
              onPressed: _selectedOption == null ? null : (_isAnswered ? _nextQuestion : _submitAnswer),
              child: Text(_isAnswered 
                ? (_currentIndex == currentSet.questions.length - 1 ? 'Finish' : 'Next Question') 
                : 'Submit Answer'),
            ),
          ],
        ),
      ),
    );
  }
}
