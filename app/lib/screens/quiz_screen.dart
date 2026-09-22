import 'dart:math';
import 'package:flutter/material.dart';
import '../models/verse.dart';
import '../state/prefs.dart';
import '../theme/app_theme.dart';
import '../widgets/lang_toggle.dart';
import 'recite_screen.dart';

enum _QType { meaning, blank }

class _Question {
  final _QType type;
  final VerseWord word;
  final List<String> options;
  final String correct;

  _Question({
    required this.type,
    required this.word,
    required this.options,
    required this.correct,
  });
}

class QuizScreen extends StatefulWidget {
  final Verse verse;
  final DateTime sessionStart;
  const QuizScreen({super.key, required this.verse, required this.sessionStart});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const _meaningCount = 5;
  static const _blankCount = 3;

  late List<_Question> _quiz;
  int _index = 0;
  int _score = 0;
  String? _selected;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _quiz = _buildQuiz();
  }

  List<_Question> _buildQuiz() {
    final rand = Random();
    final words = widget.verse.words;
    final lang = AppPrefs.instance.lang.value;
    final pool = List<VerseWord>.from(words)..shuffle(rand);

    final meaningWords = pool.take(min(_meaningCount, pool.length)).toList();
    final blankWords = (List<VerseWord>.from(words)..shuffle(rand))
        .take(min(_blankCount, words.length))
        .toList();

    final questions = <_Question>[];
    for (final w in meaningWords) {
      final distractors = words.where((x) => x.sa != w.sa).toList()..shuffle(rand);
      final opts = [w.meaning(lang), ...distractors.take(2).map((d) => d.meaning(lang))]
        ..shuffle(rand);
      questions.add(_Question(
        type: _QType.meaning,
        word: w,
        options: opts,
        correct: w.meaning(lang),
      ));
    }
    for (final w in blankWords) {
      final distractors = words.where((x) => x.sa != w.sa).toList()..shuffle(rand);
      final opts = [w.sa, ...distractors.take(2).map((d) => d.sa)]..shuffle(rand);
      questions.add(_Question(
        type: _QType.blank,
        word: w,
        options: opts,
        correct: w.sa,
      ));
    }
    questions.shuffle(rand);
    return questions;
  }

  void _select(String option) {
    if (_answered) return;
    setState(() {
      _selected = option;
      _answered = true;
      if (option == _quiz[_index].correct) _score++;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_index + 1 < _quiz.length) {
        setState(() {
          _index++;
          _answered = false;
          _selected = null;
        });
      } else {
        _finish();
      }
    });
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ReciteScreen(
          verse: widget.verse,
          quizScore: _score,
          quizTotal: _quiz.length,
          sessionStart: widget.sessionStart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _quiz[_index];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: Center(child: LangToggle()))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Step 3 of 4 — Quiz',
                  style: TextStyle(color: AppColors.soft, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('${_index + 1} / ${_quiz.length}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.soft, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(_quiz.length, (i) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: i < _index
                            ? AppColors.teal
                            : i == _index
                                ? AppColors.turmeric
                                : AppColors.line,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              _buildPrompt(q),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: q.options.map((opt) {
                    Color? bg;
                    Color border = AppColors.line;
                    Color textColor = AppColors.ink;
                    if (_answered) {
                      if (opt == q.correct) {
                        bg = const Color(0xFFE7F6E9);
                        border = AppColors.green;
                        textColor = AppColors.green;
                      } else if (opt == _selected) {
                        bg = const Color(0xFFFBEAE6);
                        border = AppColors.red;
                        textColor = AppColors.red;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => _select(opt),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                          decoration: BoxDecoration(
                            color: bg ?? AppColors.card,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: border, width: 2),
                          ),
                          child: Text(opt,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15.5, color: textColor)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              TextButton(onPressed: _finish, child: const Text('Skip Quiz ➔')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrompt(_Question q) {
    if (q.type == _QType.meaning) {
      return Text.rich(
        TextSpan(
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 19, color: AppColors.heading),
          children: [
            const TextSpan(text: 'What does '),
            TextSpan(
                text: q.word.sa,
                style: const TextStyle(color: AppColors.tealDeep)),
            const TextSpan(text: ' mean?'),
          ],
        ),
        textAlign: TextAlign.center,
      );
    }
    return const Text('Which word is missing?',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19, color: AppColors.heading));
  }
}
