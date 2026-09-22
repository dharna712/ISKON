import 'package:flutter/material.dart';
import '../data/gita_chapters.dart';
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
  final _scripturesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _grouped = VerseRepository.instance.loadGroupedByBook();
  }

  void _refresh() => setState(() {});

  void _scrollToScriptures() {
    final ctx = _scripturesKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    }
  }

  Future<void> _openVerse(Verse verse) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ListenScreen(verse: verse)),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, List<Verse>>>(
        future: _grouped,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final grouped = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _Header(onExplore: _scrollToScriptures)),
              SliverToBoxAdapter(child: _FeatureCards(onTap: _scrollToScriptures)),
              SliverToBoxAdapter(
                child: Padding(
                  key: _scripturesKey,
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
                  child: Text('📚 Scriptures', style: appHeadingStyle(fontSize: 20)),
                ),
              ),
              if (grouped['bg'] != null)
                SliverToBoxAdapter(
                  child: _GitaAccordionSection(verses: grouped['bg']!, onOpenVerse: _openVerse),
                ),
              if (grouped['iso'] != null)
                SliverToBoxAdapter(
                  child: _SimpleBookSection(
                    title: 'Īśopaniṣad',
                    blurb: 'One of the principal Upaniṣads — the complete\ntext, translated in full by Śrīla Prabhupāda.',
                    verses: grouped['iso']!,
                    onOpenVerse: _openVerse,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onExplore;
  const _Header({required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 54, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.peacockGradient,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.65), width: 1.5),
              image: const DecorationImage(
                image: AssetImage('assets/images/logo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text('Shlok Saarthi', style: appHeadingStyle(fontSize: 26, color: Colors.white)),
          const SizedBox(height: 6),
          Text(
            'Discover the wisdom of ancient Indian scriptures.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.gold.withValues(alpha: 0.9), fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _FeatureCards extends StatelessWidget {
  final VoidCallback onTap;
  const _FeatureCards({required this.onTap});

  static const _features = [
    (icon: '📖', title: 'Learn', desc: 'Read shlokas &\ntheir meanings'),
    (icon: '🔊', title: 'Listen', desc: 'Hear shlokas &\nexplanations'),
    (icon: '🌐', title: 'Translate', desc: 'English &\nहिंदी'),
    (icon: '🧠', title: 'Quiz', desc: 'Test your\nunderstanding'),
    (icon: '📚', title: 'Scriptures', desc: 'Gītā &\nUpaniṣads'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        scrollDirection: Axis.horizontal,
        itemCount: _features.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final f = _features[i];
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
              width: 118,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line, width: 1.2),
                boxShadow: [BoxShadow(color: AppColors.marigoldDeep.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 8),
                  Text(f.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.heading)),
                  const SizedBox(height: 3),
                  Text(f.desc, style: const TextStyle(fontSize: 10.5, color: AppColors.soft, height: 1.25)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SimpleBookSection extends StatelessWidget {
  final String title;
  final String blurb;
  final List<Verse> verses;
  final void Function(Verse) onOpenVerse;

  const _SimpleBookSection({
    required this.title,
    required this.blurb,
    required this.verses,
    required this.onOpenVerse,
  });

  @override
  Widget build(BuildContext context) {
    final masteredCount = verses.where((v) => AppPrefs.instance.isMastered(v.id)).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: appHeadingStyle(fontSize: 16)),
          const SizedBox(height: 2),
          const Text('18 verses • principal Upaniṣad', style: TextStyle(color: AppColors.soft, fontSize: 12.5)),
          const SizedBox(height: 12),
          _AccordionCard(
            title: 'Complete Text',
            subtitle: '${verses.length} of 18 verses available',
            blurb: blurb,
            progressLabel: '$masteredCount / ${verses.length} shlokas completed',
            progress: verses.isEmpty ? 0 : masteredCount / verses.length,
            children: [
              for (final v in verses) _VerseRow(verse: v, onTap: () => onOpenVerse(v)),
            ],
            onContinue: () => onOpenVerse(
              verses.firstWhere((v) => !AppPrefs.instance.isMastered(v.id), orElse: () => verses.first),
            ),
          ),
        ],
      ),
    );
  }
}

class _GitaAccordionSection extends StatelessWidget {
  final List<Verse> verses;
  final void Function(Verse) onOpenVerse;

  const _GitaAccordionSection({required this.verses, required this.onOpenVerse});

  @override
  Widget build(BuildContext context) {
    final byChapter = <int, List<Verse>>{};
    for (final v in verses) {
      final ch = parseGitaChapter(v.name) ?? 0;
      byChapter.putIfAbsent(ch, () => []).add(v);
    }
    final chapters = byChapter.keys.toList()..sort();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bhagavad Gītā', style: appHeadingStyle(fontSize: 16)),
          const SizedBox(height: 2),
          const Text('700 verses • 18 chapters', style: TextStyle(color: AppColors.soft, fontSize: 12.5)),
          const SizedBox(height: 12),
          for (final ch in chapters)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildChapter(ch, byChapter[ch]!),
            ),
        ],
      ),
    );
  }

  Widget _buildChapter(int ch, List<Verse> chapterVerses) {
    final masteredCount = chapterVerses.where((v) => AppPrefs.instance.isMastered(v.id)).length;
    final title = gitaChapterTitles[ch] ?? 'Chapter $ch';
    final blurb = gitaChapterBlurbs[ch] ?? '';
    return _AccordionCard(
      title: 'Chapter $ch — $title',
      subtitle: '${chapterVerses.length} shlokas',
      blurb: blurb,
      progressLabel: '$masteredCount / ${chapterVerses.length} shlokas completed',
      progress: chapterVerses.isEmpty ? 0 : masteredCount / chapterVerses.length,
      children: [
        for (final v in chapterVerses) _VerseRow(verse: v, onTap: () => onOpenVerse(v)),
      ],
      onContinue: () => onOpenVerse(
        chapterVerses.firstWhere((v) => !AppPrefs.instance.isMastered(v.id), orElse: () => chapterVerses.first),
      ),
    );
  }
}

class _AccordionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String blurb;
  final String progressLabel;
  final double progress;
  final List<Widget> children;
  final VoidCallback onContinue;

  const _AccordionCard({
    required this.title,
    required this.subtitle,
    required this.blurb,
    required this.progressLabel,
    required this.progress,
    required this.children,
    required this.onContinue,
  });

  @override
  State<_AccordionCard> createState() => _AccordionCardState();
}

class _AccordionCardState extends State<_AccordionCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line, width: 1.3),
        boxShadow: [BoxShadow(color: AppColors.marigoldDeep.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.heading)),
                        const SizedBox(height: 2),
                        Text(widget.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.soft)),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, color: AppColors.bronze),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.blurb.isNotEmpty) ...[
                    Text(widget.blurb, style: const TextStyle(fontSize: 12.5, color: AppColors.soft, height: 1.4)),
                    const SizedBox(height: 10),
                  ],
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: widget.progress,
                      minHeight: 6,
                      backgroundColor: AppColors.line,
                      valueColor: const AlwaysStoppedAnimation(AppColors.emerald),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(widget.progressLabel, style: const TextStyle(fontSize: 11.5, color: AppColors.soft, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ...widget.children,
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onContinue,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: const Text('Continue Learning'),
                    ),
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _VerseRow extends StatelessWidget {
  final Verse verse;
  final VoidCallback onTap;

  const _VerseRow({required this.verse, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mastered = AppPrefs.instance.isMastered(verse.id);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: mastered ? const Color(0xFFEAF6EF) : AppColors.sand,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: mastered ? const Color(0xFFB6DFC5) : AppColors.line),
        ),
        child: Row(
          children: [
            Icon(
              mastered ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 18,
              color: mastered ? AppColors.green : AppColors.soft,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(verse.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.heading)),
                  Text(verse.sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.soft)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.bronze),
          ],
        ),
      ),
    );
  }
}
