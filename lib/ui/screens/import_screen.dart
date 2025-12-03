import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/study_provider.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  String? _filePath;
  String? _fileName;
  final _titleController = TextEditingController();
  final _apiKeyController = TextEditingController();

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
        if (_titleController.text.isEmpty) {
          _titleController.text = _fileName!.replaceAll('.pdf', '');
        }
      });
    }
  }

  Future<void> _generate() async {
    if (_filePath == null || _titleController.text.isEmpty) return;

    // Update API Key if provided
    if (_apiKeyController.text.isNotEmpty) {
      ref.read(apiKeyProvider.notifier).state = _apiKeyController.text;
    }

    // Check if API key is set
    if (ref.read(apiKeyProvider).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Gemini API Key')),
      );
      return;
    }

    await ref.read(studyProvider.notifier).generateStudySet(
          _filePath!,
          _titleController.text,
        );

    if (mounted) {
      final error = ref.read(studyProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      } else {
        Navigator.pop(context); // Go back to Home
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studyState = ref.watch(studyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Import PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // API Key Input (Temporary for demo)
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'Gemini API Key',
                border: OutlineInputBorder(),
                helperText: 'Get one from AI Studio',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            
            // File Picker
            InkWell(
              onTap: _pickFile,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _fileName ?? 'Tap to select PDF',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Title Input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Study Set Title',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            
            // Generate Button
            FilledButton.icon(
              onPressed: studyState.isLoading ? null : _generate,
              icon: studyState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(studyState.isLoading ? 'Generating...' : 'Generate Study Set'),
            ),
          ],
        ),
      ),
    );
  }
}
