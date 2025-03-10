import 'user.dart';
import 'word_library.dart';

class Duel {
  final String id;
  final User player1;
  final User player2;
  final WordLibrary wordLibrary;
  final int wordCount;
  final int timeLimit; // 每题时间限制（秒）
  final DateTime createdAt;
  final DateTime? completedAt;
  final DuelStatus status;
  final int player1Score;
  final int player2Score;
  final List<DuelQuestion> questions;
  final List<DuelAnswer> player1Answers;
  final List<DuelAnswer> player2Answers;

  Duel({
    required this.id,
    required this.player1,
    required this.player2,
    required this.wordLibrary,
    required this.wordCount,
    required this.timeLimit,
    required this.createdAt,
    this.completedAt,
    this.status = DuelStatus.waiting,
    this.player1Score = 0,
    this.player2Score = 0,
    required this.questions,
    this.player1Answers = const [],
    this.player2Answers = const [],
  });

  // 从JSON创建Duel对象
  factory Duel.fromJson(Map<String, dynamic> json) {
    return Duel(
      id: json['id'],
      player1: User.fromJson(json['player1']),
      player2: User.fromJson(json['player2']),
      wordLibrary: WordLibrary.fromJson(json['wordLibrary']),
      wordCount: json['wordCount'],
      timeLimit: json['timeLimit'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      status: DuelStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
          orElse: () => DuelStatus.waiting),
      player1Score: json['player1Score'] ?? 0,
      player2Score: json['player2Score'] ?? 0,
      questions: (json['questions'] as List)
          .map((q) => DuelQuestion.fromJson(q))
          .toList(),
      player1Answers: json['player1Answers'] != null
          ? (json['player1Answers'] as List)
              .map((a) => DuelAnswer.fromJson(a))
              .toList()
          : [],
      player2Answers: json['player2Answers'] != null
          ? (json['player2Answers'] as List)
              .map((a) => DuelAnswer.fromJson(a))
              .toList()
          : [],
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player1': player1.toJson(),
      'player2': player2.toJson(),
      'wordLibrary': wordLibrary.toJson(),
      'wordCount': wordCount,
      'timeLimit': timeLimit,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'status': status.toString().split('.').last,
      'player1Score': player1Score,
      'player2Score': player2Score,
      'questions': questions.map((q) => q.toJson()).toList(),
      'player1Answers': player1Answers.map((a) => a.toJson()).toList(),
      'player2Answers': player2Answers.map((a) => a.toJson()).toList(),
    };
  }

  // 获取当前问题
  DuelQuestion? getCurrentQuestion() {
    final currentIndex = player1Answers.length;
    return currentIndex < questions.length ? questions[currentIndex] : null;
  }

  // 判断对战是否结束
  bool isCompleted() {
    return player1Answers.length >= wordCount && player2Answers.length >= wordCount;
  }

  // 获取胜者
  User? getWinner() {
    if (!isCompleted()) return null;
    if (player1Score > player2Score) return player1;
    if (player2Score > player1Score) return player2;
    return null; // 平局
  }

  // 创建带有更新属性的副本
  Duel copyWith({
    String? id,
    User? player1,
    User? player2,
    WordLibrary? wordLibrary,
    int? wordCount,
    int? timeLimit,
    DateTime? createdAt,
    DateTime? completedAt,
    DuelStatus? status,
    int? player1Score,
    int? player2Score,
    List<DuelQuestion>? questions,
    List<DuelAnswer>? player1Answers,
    List<DuelAnswer>? player2Answers,
  }) {
    return Duel(
      id: id ?? this.id,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      wordLibrary: wordLibrary ?? this.wordLibrary,
      wordCount: wordCount ?? this.wordCount,
      timeLimit: timeLimit ?? this.timeLimit,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      questions: questions ?? this.questions,
      player1Answers: player1Answers ?? this.player1Answers,
      player2Answers: player2Answers ?? this.player2Answers,
    );
  }
}

enum DuelStatus {
  waiting, // 等待开始
  inProgress, // 进行中
  completed, // 已完成
  cancelled, // 已取消
}

class DuelQuestion {
  final String id;
  final String word;
  final String pronunciation;
  final List<DuelOption> options;
  final int correctOptionIndex;

  DuelQuestion({
    required this.id,
    required this.word,
    required this.pronunciation,
    required this.options,
    required this.correctOptionIndex,
  });

  // 从JSON创建DuelQuestion对象
  factory DuelQuestion.fromJson(Map<String, dynamic> json) {
    return DuelQuestion(
      id: json['id'],
      word: json['word'],
      pronunciation: json['pronunciation'],
      options: (json['options'] as List)
          .map((o) => DuelOption.fromJson(o))
          .toList(),
      correctOptionIndex: json['correctOptionIndex'],
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'pronunciation': pronunciation,
      'options': options.map((o) => o.toJson()).toList(),
      'correctOptionIndex': correctOptionIndex,
    };
  }
}

class DuelOption {
  final String id;
  final String text;

  DuelOption({
    required this.id,
    required this.text,
  });

  // 从JSON创建DuelOption对象
  factory DuelOption.fromJson(Map<String, dynamic> json) {
    return DuelOption(
      id: json['id'],
      text: json['text'],
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}

class DuelAnswer {
  final String questionId;
  final int selectedOptionIndex;
  final bool isCorrect;
  final int timeSpent; // 答题用时（毫秒）

  DuelAnswer({
    required this.questionId,
    required this.selectedOptionIndex,
    required this.isCorrect,
    required this.timeSpent,
  });

  // 从JSON创建DuelAnswer对象
  factory DuelAnswer.fromJson(Map<String, dynamic> json) {
    return DuelAnswer(
      questionId: json['questionId'],
      selectedOptionIndex: json['selectedOptionIndex'],
      isCorrect: json['isCorrect'],
      timeSpent: json['timeSpent'],
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedOptionIndex': selectedOptionIndex,
      'isCorrect': isCorrect,
      'timeSpent': timeSpent,
    };
  }
} 