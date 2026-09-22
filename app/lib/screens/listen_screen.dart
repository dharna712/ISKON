import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/verse.dart';
import '../theme/app_theme.dart';
import 'understand_screen.dart';

class ListenScreen extends StatefulWidget {
  final Verse verse;
  const ListenScreen({super.key, required this.verse});

  @override
  State<ListenScreen> createState() => _ListenScreenState();
}

class _ListenScreenState extends State<ListenScreen> {
  final _player = AudioPlayer();
  final DateTime _sessionStart = DateTime.now();
  int _loops = 0;
  static const _loopTarget = 5;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    try {
      await _player.setAsset(widget.verse.audioAsset);
    } catch (_) {
      // Asset missing or unsupported on this platform - playback stays disabled.
    }
    setState(() => _loading = false);
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        setState(() => _loops = (_loops + 1).clamp(0, _loopTarget));
        _player.seek(Duration.zero);
        _player.play();
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listen')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Step 1 of 4 — Listen',
                  style: TextStyle(color: AppColors.soft, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              _VerseCard(verse: widget.verse),
              const SizedBox(height: 20),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else ...[
                StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (context, snap) {
                    final pos = snap.data ?? Duration.zero;
                    final dur = _player.duration ?? Duration.zero;
                    return Column(
                      children: [
                        Slider(
                          value: dur.inMilliseconds == 0
                              ? 0
                              : pos.inMilliseconds
                                  .clamp(0, dur.inMilliseconds)
                                  .toDouble(),
                          max: dur.inMilliseconds == 0
                              ? 1
                              : dur.inMilliseconds.toDouble(),
                          activeColor: AppColors.marigold,
                          onChanged: (v) =>
                              _player.seek(Duration(milliseconds: v.round())),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_fmt(pos), style: const TextStyle(color: AppColors.soft)),
                            Text(_fmt(dur), style: const TextStyle(color: AppColors.soft)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    StreamBuilder<PlayerState>(
                      stream: _player.playerStateStream,
                      builder: (context, snap) {
                        final playing = snap.data?.playing ?? false;
                        return IconButton.filled(
                          iconSize: 30,
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.marigold,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                          ),
                          onPressed: () => playing ? _player.pause() : _player.play(),
                          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                        );
                      },
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tap play, then follow the tune',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          Row(
                            children: List.generate(_loopTarget, (i) {
                              final on = i < _loops;
                              return Container(
                                margin: const EdgeInsets.only(right: 6, top: 4),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: on ? AppColors.teal : AppColors.line,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _player.stop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => UnderstandScreen(
                          verse: widget.verse,
                          sessionStart: _sessionStart,
                        ),
                      ),
                    );
                  },
                  child: const Text('Next →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final Verse verse;
  const _VerseCard({required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(verse.name,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.heading)),
          const SizedBox(height: 10),
          for (final line in verse.lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                line,
                style: const TextStyle(
                    fontSize: 17, height: 1.6, color: AppColors.heading, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}
