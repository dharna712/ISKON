import 'package:flutter/material.dart';
import '../models/verse.dart';
import '../state/prefs.dart';
import '../theme/app_theme.dart';
import '../widgets/lang_toggle.dart';
import 'quiz_screen.dart';

class UnderstandScreen extends StatefulWidget {
  final Verse verse;
  final DateTime sessionStart;
  const UnderstandScreen({super.key, required this.verse, required this.sessionStart});

  @override
  State<UnderstandScreen> createState() => _UnderstandScreenState();
}

class _UnderstandScreenState extends State<UnderstandScreen> {
  @override
  Widget build(BuildContext context) {
    final verse = widget.verse;
    return Scaffold(
      appBar: AppBar(
        title: const Text('What it means'),
        actions: [
          IconButton(
            icon: Icon(
              AppPrefs.instance.isStarred(verse.id) ? Icons.star : Icons.star_border,
              color: AppColors.marigoldDeep,
            ),
            onPressed: () async {
              await AppPrefs.instance.toggleStarred(verse.id);
              setState(() {});
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LangToggle()),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Step 2 of 4 — Understand',
                style: TextStyle(color: AppColors.soft, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.line, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final line in verse.lines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(line,
                          style: const TextStyle(
                              fontSize: 17, height: 1.6, color: AppColors.heading, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('Word by word',
                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
            const SizedBox(height: 8),
            ValueListenableBuilder<AppLang>(
              valueListenable: AppPrefs.instance.lang,
              builder: (context, lang, _) => Column(
                children: [
                  for (final w in verse.words)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(w.sa,
                                style: const TextStyle(
                                    color: AppColors.tealDeep, fontWeight: FontWeight.w700)),
                          ),
                          const Icon(Icons.arrow_forward, size: 14, color: AppColors.turmeric),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(w.meaning(lang),
                                textAlign: TextAlign.right,
                                style: const TextStyle(color: AppColors.ink, fontSize: 13.5)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<AppLang>(
              valueListenable: AppPrefs.instance.lang,
              builder: (context, lang, _) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF6E6), Color(0xFFFDEBCF)],
                  ),
                  border: Border.all(color: AppColors.turmeric, width: 1.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('THE WHOLE MEANING',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 1,
                            color: AppColors.marigoldDeep)),
                    const SizedBox(height: 6),
                    Text(verse.translation.text(lang),
                        style: const TextStyle(fontSize: 15.5, height: 1.5, color: AppColors.heading)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        verse: verse,
                        sessionStart: widget.sessionStart,
                      ),
                    ),
                  );
                },
                child: const Text("I'm ready — quiz me! ✨"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
