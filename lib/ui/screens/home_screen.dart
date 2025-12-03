import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/study_provider.dart';
import '../../data/models/study_set.dart';
import 'import_screen.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final studyState = ref.watch(studyProvider);
    
    final screens = [
      _buildDashboard(context, studyState.studySets),
      const ProgressScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Progress'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImportScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New Study Set'),
            )
          : null,
    );
  }

  Widget _buildDashboard(BuildContext context, List<StudySet> sets) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('AI Study Assistant'),
          centerTitle: false,
        ),
        if (sets.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No study sets yet. Tap + to create one!'),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final set = sets[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        set.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        '${set.flashcards.length} Cards • ${set.questions.length} Questions',
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'delete') {
                            ref.read(studyProvider.notifier).deleteSet(set.id);
                          }
                        },
                      ),
                      onTap: () => _showStudyOptions(context, set),
                    ),
                  );
                },
                childCount: sets.length,
              ),
            ),
          ),
      ],
    );
  }

  void _showStudyOptions(BuildContext context, StudySet set) {
    // Set current set
    ref.read(studyProvider.notifier).selectSet(set);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(set.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.style, color: Colors.blue),
              title: const Text('Flashcards'),
              subtitle: const Text('Review terms and definitions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FlashcardScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.quiz, color: Colors.orange),
              title: const Text('Mock Test'),
              subtitle: const Text('Take a multiple choice quiz'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
