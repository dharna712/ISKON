import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/verse.dart';
import '../theme/app_theme.dart';
import 'done_screen.dart';

class ReciteScreen extends StatefulWidget {
  final Verse verse;
  final int quizScore;
  final int quizTotal;
  final DateTime sessionStart;

  const ReciteScreen({
    super.key,
    required this.verse,
    required this.quizScore,
    required this.quizTotal,
    required this.sessionStart,
  });

  @override
  State<ReciteScreen> createState() => _ReciteScreenState();
}

class _ReciteScreenState extends State<ReciteScreen> {
  static const _totalRounds = 3;
  final _player = AudioPlayer();
  final _tanpura = AudioPlayer();
  int _round = 0;
  bool _tanpuraOn = false;

  @override
  void initState() {
    super.initState();
    _player.setAsset(widget.verse.audioAsset).catchError((_) => null);
    _tanpura.setAsset('assets/audio/Tanpura.mp3').catchError((_) => null);
    _tanpura.setLoopMode(LoopMode.one);
  }

  @override
  void dispose() {
    _player.dispose();
    _tanpura.dispose();
    super.dispose();
  }

  void _toggleTanpura() {
    setState(() => _tanpuraOn = !_tanpuraOn);
    if (_tanpuraOn) {
      _tanpura.play();
    } else {
      _tanpura.pause();
    }
  }

  void _completeRound() {
    if (_round >= _totalRounds) return;
    setState(() => _round++);
    if (_round == _totalRounds) {
      _player.stop();
      _tanpura.stop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DoneScreen(
            verse: widget.verse,
            quizScore: widget.quizScore,
            quizTotal: widget.quizTotal,
            elapsed: DateTime.now().difference(widget.sessionStart),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final verse = widget.verse;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your turn 🎙'),
        actions: [
          IconButton(
            onPressed: _toggleTanpura,
            icon: Icon(_tanpuraOn ? Icons.music_note : Icons.music_off,
                color: _tanpuraOn ? AppColors.teal : AppColors.soft),
            tooltip: 'Tanpura drone',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Step 4 of 4 — Recite',
                  style: TextStyle(color: AppColors.soft, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              Row(
                children: List.generate(_totalRounds, (i) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: i < _round ? AppColors.teal : AppColors.line,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.line, width: 1.5),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final line in verse.lines)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(line,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 19, height: 1.9, color: AppColors.heading, fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  children: [
                    Text('Repeat this verse', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('$_round/$_totalRounds repetitions completed',
                        style: const TextStyle(fontSize: 13.5, color: AppColors.soft, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _completeRound,
                  child: const Text('I Chanted This Round ✓'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _player.play(),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play Audio'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _player.pause(),
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
