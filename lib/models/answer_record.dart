/// 答题记录模型类
class AnswerRecord {
  /// 单词
  final String word;
  
  /// 用户答案
  final String userAnswer;
  
  /// 正确答案
  final String correctAnswer;
  
  /// 是否正确
  final bool isCorrect;
  
  /// 答题时间
  final Duration duration;
  
  /// 构造函数
  const AnswerRecord({
    required this.word,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.duration,
  });
} 