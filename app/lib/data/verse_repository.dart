import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/verse.dart';

class VerseRepository {
  VerseRepository._();
  static final VerseRepository instance = VerseRepository._();

  List<Verse>? _verses;

  Future<List<Verse>> loadAll() async {
    if (_verses != null) return _verses!;
    final raw = await rootBundle.loadString('assets/data/verses.json');
    final list = jsonDecode(raw) as List;
    _verses = list
        .map((e) => Verse.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return _verses!;
  }

  Future<Map<String, List<Verse>>> loadGroupedByBook() async {
    final all = await loadAll();
    final grouped = <String, List<Verse>>{};
    for (final v in all) {
      grouped.putIfAbsent(v.book, () => []).add(v);
    }
    return grouped;
  }
}
