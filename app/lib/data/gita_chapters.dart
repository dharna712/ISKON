/// Standard Bhagavad-gītā chapter titles, keyed by chapter number.
/// Only chapters that actually have verses in `verses.json` are shown.
const Map<int, String> gitaChapterTitles = {
  1: 'Arjuna-viṣāda-yoga',
  2: 'Sāṅkhya-yoga',
  3: 'Karma-yoga',
  4: 'Jñāna-karma-sannyāsa-yoga',
  5: 'Karma-sannyāsa-yoga',
  6: 'Dhyāna-yoga',
  7: 'Jñāna-vijñāna-yoga',
  8: 'Akṣara-brahma-yoga',
  9: 'Rāja-vidyā-rāja-guhya-yoga',
  10: 'Vibhūti-yoga',
  11: 'Viśvarūpa-darśana-yoga',
  12: 'Bhakti-yoga',
  13: 'Kṣetra-kṣetrajña-vibhāga-yoga',
  14: 'Guṇatraya-vibhāga-yoga',
  15: 'Puruṣottama-yoga',
  16: 'Daivāsura-sampad-vibhāga-yoga',
  17: 'Śraddhātraya-vibhāga-yoga',
  18: 'Mokṣa-sannyāsa-yoga',
};

/// Short one-line description per chapter, for the chapters present in
/// verses.json (not all 18 have verses recorded yet).
const Map<int, String> gitaChapterBlurbs = {
  2: 'The nature of the eternal self and the path of knowledge.',
  3: 'Action without attachment — the yoga of selfless work.',
  4: 'Transcendental knowledge and the descent of the Divine.',
  5: 'Renunciation through work, and true detachment.',
  6: 'The practice of meditation and mastery of the mind.',
  7: 'Knowledge of the Absolute and the two natures.',
  8: 'Attaining the imperishable at the time of death.',
  9: 'The most confidential knowledge and supreme secret.',
  13: 'The field of activity and the knower of the field.',
  14: 'The three modes of material nature.',
  15: 'The supreme person beyond the material and spiritual.',
  18: 'Conclusion — the perfection of renunciation.',
};

/// Parses "BG 2.7" -> 2. Returns null for names that don't match (e.g. ISO verses).
int? parseGitaChapter(String verseName) {
  final match = RegExp(r'^BG\s+(\d+)\.').firstMatch(verseName);
  if (match == null) return null;
  return int.tryParse(match.group(1)!);
}
