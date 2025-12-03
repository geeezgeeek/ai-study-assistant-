import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/flashcard.dart';
import '../../providers/study_provider.dart';
import 'dart:math';

class FlashcardScreen extends ConsumerStatefulWidget {
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  bool _showBack = false;

  @override
  Widget build(BuildContext context) {
    final currentSet = ref.watch(studyProvider).currentSet;

    if (currentSet == null) {
      return const Scaffold(body: Center(child: Text('No set selected')));
    }

    final cards = currentSet.flashcards;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentSet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement full set editing
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: cards.length,
              onPageChanged: (index) {
                setState(() {
                  _showBack = false;
                });
              },
              itemBuilder: (context, index) {
                return _buildCard(cards[index]);
              },
            ),
          ),
          const SizedBox(height: 20),
          // Progress Indicator
          Text(
            'Tap to flip • Swipe for next',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCard(Flashcard card) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showBack = !_showBack;
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _showBack ? 'ANSWER' : 'QUESTION',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _showBack ? card.back : card.front,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (_showBack) ...[
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // Mark as learned logic
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Got it'),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
