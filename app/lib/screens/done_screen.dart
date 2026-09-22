import 'package:flutter/material.dart';
import '../models/verse.dart';
import '../state/prefs.dart';
import '../theme/app_theme.dart';

class DoneScreen extends StatefulWidget {
  final Verse verse;
  final int quizScore;
  final int quizTotal;
  final Duration elapsed;

  const DoneScreen({
    super.key,
    required this.verse,
    required this.quizScore,
    required this.quizTotal,
    required this.elapsed,
  });

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  void initState() {
    super.initState();
    AppPrefs.instance.markMastered(widget.verse.id);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final pct = widget.quizTotal == 0 ? 1.0 : widget.quizScore / widget.quizTotal;
    final stars = pct >= 0.8 ? '⭐⭐⭐' : (pct >= 0.5 ? '⭐⭐' : '⭐');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 8),
              const Text('Gauranga! 🙌',
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.heading)),
              const SizedBox(height: 8),
              Text(stars, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: [
                  Chip(
                    label: Text('${widget.quizScore} / ${widget.quizTotal} correct'),
                    backgroundColor: const Color(0xFFFCE9D0),
                  ),
                  Chip(
                    label: Text('⏱ ${_fmt(widget.elapsed)}'),
                    backgroundColor: const Color(0xFFFCE9D0),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "You've listened, learnt the meaning, and recited it yourself. Well done!",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.soft, fontSize: 14.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Try another shloka'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
