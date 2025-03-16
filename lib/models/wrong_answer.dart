/// 错题模型类
class WrongAnswer {
  /// 单词
  final String word;
  
  /// 发音
  final String pronunciation;
  
  /// 用户答案（错误答案）
  final String userAnswer;
  
  /// 正确答案
  final String correctAnswer;
  
  /// 添加日期
  final DateTime addedDate;
  
  /// 是否已复习
  bool isReviewed;
  
  /// 构造函数
  WrongAnswer({
    required this.word,
    required this.pronunciation,
    required this.userAnswer,
    required this.correctAnswer,
    required this.addedDate,
    this.isReviewed = false,
  });
  
  /// 从JSON创建错题
  factory WrongAnswer.fromJson(Map<String, dynamic> json) {
    return WrongAnswer(
      word: json['word'],
      pronunciation: json['pronunciation'],
      userAnswer: json['userAnswer'],
      correctAnswer: json['correctAnswer'],
      addedDate: DateTime.parse(json['addedDate']),
      isReviewed: json['isReviewed'] ?? false,
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'pronunciation': pronunciation,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'addedDate': addedDate.toIso8601String(),
      'isReviewed': isReviewed,
    };
  }
} 