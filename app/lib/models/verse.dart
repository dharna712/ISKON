enum AppLang { en, hi }

extension AppLangLabel on AppLang {
  String get label => this == AppLang.en ? 'EN' : 'हिं';
}

class VerseWord {
  final String sa;
  final String en;
  final String hi;

  const VerseWord({required this.sa, required this.en, required this.hi});

  factory VerseWord.fromJson(Map<String, dynamic> json) => VerseWord(
        sa: json['sa'] as String,
        en: json['en'] as String,
        hi: json['hi'] as String,
      );

  String meaning(AppLang lang) => lang == AppLang.en ? en : hi;
}

class Translation {
  final String en;
  final String hi;

  const Translation({required this.en, required this.hi});

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        en: json['en'] as String,
        hi: json['hi'] as String,
      );

  String text(AppLang lang) => lang == AppLang.en ? en : hi;
}

class Verse {
  final String id;
  final String name;
  final String sub;
  final String badge;
  final String book; // 'bg' | 'iso'
  final List<String> lines;
  final List<VerseWord> words;
  final Translation translation;
  final String audioAsset;

  const Verse({
    required this.id,
    required this.name,
    required this.sub,
    required this.badge,
    required this.book,
    required this.lines,
    required this.words,
    required this.translation,
    required this.audioAsset,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        id: json['id'] as String,
        name: json['name'] as String,
        sub: json['sub'] as String,
        badge: json['badge'] as String,
        book: json['book'] as String,
        lines: (json['lines'] as List).cast<String>(),
        words: (json['words'] as List)
            .map((w) => VerseWord.fromJson(w as Map<String, dynamic>))
            .toList(),
        translation:
            Translation.fromJson(json['translation'] as Map<String, dynamic>),
        audioAsset: 'assets/audio/${(json['audioUrl'] as String).split('/').last}',
      );

  String get bookName => book == 'bg' ? 'Bhagavad-gītā' : 'Īśopaniṣad';
}
