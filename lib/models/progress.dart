/// 学习进度数据模型
class Progress {
  /// 新学单词数
  final int newWordCount;
  
  /// 复习单词数
  final int reviewWordCount;
  
  /// 目标单词数
  final int targetWordCount;
  
  /// 总进度百分比（0-100）
  final int percentage;
  
  /// 错题数量
  final int wrongCount;
  
  /// 构造函数
  const Progress({
    required this.newWordCount,
    required this.reviewWordCount,
    required this.targetWordCount,
    required this.percentage,
    this.wrongCount = 0,
  });
} 