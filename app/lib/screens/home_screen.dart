import 'package:flutter/material.dart';
import '../data/verse_repository.dart';
import '../models/verse.dart';
import '../state/prefs.dart';
import '../theme/app_theme.dart';
import 'listen_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, List<Verse>>> _grouped;

  static const _bookOrder = ['bg', 'iso'];
  static const _bookLabels = {
    'bg': 'Bhagavad-gītā',
    'iso': 'Īśopaniṣad',
  };

  @override
  void initState() {
    super.initState();
    _grouped = VerseRepository.instance.loadGroupedByBook();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, List<Verse>>>(
          future: _grouped,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final grouped = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHero()),
                for (final book in _bookOrder)
                  if (grouped[book] != null) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        child: Text(
                          '${_bookLabels[book]} (${grouped[book]!.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 1,
                            color: AppColors.heading,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final verse = grouped[book]![index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: _VerseCard(
                              verse: verse,
                              onOpen: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ListenScreen(verse: verse),
                                  ),
                                );
                                _refresh();
                              },
                            ),
                          );
                        },
                        childCount: grouped[book]!.length,
                      ),
                    ),
                  ],
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 44,
            backgroundImage: AssetImage('assets/images/prabhupada.jpg'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Shloka Saathi',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 28,
              color: AppColors.heading,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Bhagavad-gītā & Īśopaniṣad companion',
            style: TextStyle(color: AppColors.soft, fontSize: 14),
          ),
          const SizedBox(height: 6),
          const Text(
            'A 10-minute journey to learn the verse and its meaning.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.soft, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final Verse verse;
  final VoidCallback onOpen;

  const _VerseCard({required this.verse, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final mastered = AppPrefs.instance.isMastered(verse.id);
    return Material(
      color: mastered ? const Color(0xFFEBF7EC) : AppColors.card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onOpen,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: mastered ? const Color(0xFFB2D9B6) : AppColors.line,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: LinearGradient(
                    colors: mastered
                        ? const [Color(0xFF74C97E), Color(0xFF2E9C3C)]
                        : const [AppColors.turmeric, AppColors.marigold],
                  ),
                ),
                child: Text(
                  verse.badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      verse.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: mastered ? const Color(0xFF1E6B27) : AppColors.heading,
                      ),
                    ),
                    Text(
                      verse.sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.soft, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: mastered ? const Color(0xFF2E9C3C) : AppColors.marigold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
