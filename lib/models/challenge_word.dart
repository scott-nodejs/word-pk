import 'word.dart';

/// 单词挑战模型，包含挑战所需的全部信息
class ChallengeWord {
  /// ID
  final int id;
  
  /// 单词
  final String word;
  
  /// 音标
  final String phoneticSymbol;
  
  /// 含义
  final String meaning;
  
  /// 音频URL
  final String audioUrl;
  
  /// 选项列表
  final List<ChallengeOption> options;
  
  /// 难度级别 (1-5)
  final int difficulty;
  
  /// 分类/标签
  final List<String>? tags;
  
  /// 正确答案索引
  final int correctIndex;
  
  /// 正确答案选项
  final ChallengeOption correctOption;
  
  /// 构造函数
  ChallengeWord({
    required this.id,
    required this.word,
    required this.phoneticSymbol,
    required this.meaning,
    required this.audioUrl,
    required this.options,
    required this.correctIndex,
    required this.correctOption,
    this.difficulty = 1,
    this.tags,
  });
  
  /// 从JSON创建对象
  factory ChallengeWord.fromJson(Map<String, dynamic> json) {
    final optionsList = (json['options'] as List)
        .map((option) => ChallengeOption.fromJson(option))
        .toList();
    
    return ChallengeWord(
      id: json['id'],
      word: json['word'],
      phoneticSymbol: json['phoneticSymbol'],
      meaning: json['meaning'],
      audioUrl: json['audioUrl'],
      options: optionsList,
      correctIndex: json['correctIndex'],
      correctOption: ChallengeOption.fromJson(json['correctOption']),
      difficulty: json['difficulty'] ?? 1,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'phoneticSymbol': phoneticSymbol,
      'meaning': meaning,
      'audioUrl': audioUrl,
      'options': options.map((option) => option.toJson()).toList(),
      'correctIndex': correctIndex,
      'correctOption': correctOption.toJson(),
      'difficulty': difficulty,
      'tags': tags,
    };
  }
}

/// 挑战选项模型
class ChallengeOption {
  /// 选项文本
  final String text;
  
  /// 是否为正确答案
  final bool isCorrect;
  
  /// 构造函数
  ChallengeOption({
    required this.text,
    this.isCorrect = false,
  });
  
  /// 从JSON创建对象
  factory ChallengeOption.fromJson(Map<String, dynamic> json) {
    return ChallengeOption(
      text: json['text'],
      isCorrect: json['isCorrect'] ?? false,
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCorrect': isCorrect,
    };
  }
}

/// 单词挑战会话模型
class WordChallenge {
  /// 挑战ID
  final String id;
  
  /// 挑战中的单词列表
  final List<ChallengeWord> words;
  
  /// 总单词数量
  final int totalWords;
  
  /// 挑战开始时间
  final DateTime startTime;
  
  /// 挑战状态
  final ChallengeStatus status;
  
  /// 构造函数
  WordChallenge({
    required this.id,
    required this.words,
    required this.totalWords,
    required this.startTime,
    this.status = ChallengeStatus.inProgress,
  });
  
  /// 从JSON创建对象
  factory WordChallenge.fromJson(Map<String, dynamic> json) {
    return WordChallenge(
      id: json['id'],
      words: (json['words'] as List)
          .map((word) => ChallengeWord.fromJson(word))
          .toList(),
      totalWords: json['totalWords'],
      startTime: DateTime.parse(json['startTime']),
      status: ChallengeStatus.values.byName(json['status'] ?? 'inProgress'),
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'words': words.map((word) => word.toJson()).toList(),
      'totalWords': totalWords,
      'startTime': startTime.toIso8601String(),
      'status': status.name,
    };
  }
  
  /// 创建新的挑战
  factory WordChallenge.create({
    required List<ChallengeWord> words,
  }) {
    return WordChallenge(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      words: words,
      totalWords: words.length,
      startTime: DateTime.now(),
    );
  }
}

/// 挑战状态枚举
enum ChallengeStatus {
  /// 进行中
  inProgress,
  
  /// 已完成
  completed,
  
  /// 已放弃
  abandoned
} 