class Word {
  final String id;
  final String text;
  final String pronunciation;
  final List<WordDefinition> definitions;
  final List<WordExample> examples;
  final String? imageUrl;
  final int difficulty; // 1-5，表示难度级别
  final int memoryStrength; // 0-100，表示记忆强度

  Word({
    required this.id,
    required this.text,
    required this.pronunciation,
    required this.definitions,
    required this.examples,
    this.imageUrl,
    this.difficulty = 3,
    this.memoryStrength = 0,
  });

  // 从JSON创建Word对象
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      text: json['text'],
      pronunciation: json['pronunciation'],
      definitions: (json['definitions'] as List)
          .map((def) => WordDefinition.fromJson(def))
          .toList(),
      examples: (json['examples'] as List)
          .map((ex) => WordExample.fromJson(ex))
          .toList(),
      imageUrl: json['imageUrl'],
      difficulty: json['difficulty'] ?? 3,
      memoryStrength: json['memoryStrength'] ?? 0,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'pronunciation': pronunciation,
      'definitions': definitions.map((def) => def.toJson()).toList(),
      'examples': examples.map((ex) => ex.toJson()).toList(),
      'imageUrl': imageUrl,
      'difficulty': difficulty,
      'memoryStrength': memoryStrength,
    };
  }
}

class WordDefinition {
  final String partOfSpeech; // 词性，如 n., v., adj.
  final String meaning; // 中文释义
  final String? englishMeaning; // 英文释义（可选）

  WordDefinition({
    required this.partOfSpeech,
    required this.meaning,
    this.englishMeaning,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> json) {
    return WordDefinition(
      partOfSpeech: json['partOfSpeech'],
      meaning: json['meaning'],
      englishMeaning: json['englishMeaning'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partOfSpeech': partOfSpeech,
      'meaning': meaning,
      'englishMeaning': englishMeaning,
    };
  }
}

class WordExample {
  final String sentence; // 英文例句
  final String translation; // 中文翻译

  WordExample({
    required this.sentence,
    required this.translation,
  });

  factory WordExample.fromJson(Map<String, dynamic> json) {
    return WordExample(
      sentence: json['sentence'],
      translation: json['translation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentence': sentence,
      'translation': translation,
    };
  }
} 