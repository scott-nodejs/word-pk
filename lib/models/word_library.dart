class WordLibrary {
  final String id;
  final String name;
  final String shortName; // 简称，如"CET"
  final String description;
  final int wordCount;
  final String difficulty; // "简单", "中等", "中高", "高", "很高"
  final String? imageUrl;
  final String backgroundColor; // 背景颜色，十六进制字符串
  final String textColor; // 文本颜色，十六进制字符串
  final int progress; // 0-100，表示学习进度百分比
  final bool isAdded; // 是否已添加到我的词库

  WordLibrary({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.wordCount,
    required this.difficulty,
    this.imageUrl,
    required this.backgroundColor,
    required this.textColor,
    this.progress = 0,
    this.isAdded = false,
  });

  // 从JSON创建WordLibrary对象
  factory WordLibrary.fromJson(Map<String, dynamic> json) {
    return WordLibrary(
      id: json['id'],
      name: json['name'],
      shortName: json['shortName'],
      description: json['description'],
      wordCount: json['wordCount'],
      difficulty: json['difficulty'],
      imageUrl: json['imageUrl'],
      backgroundColor: json['backgroundColor'],
      textColor: json['textColor'],
      progress: json['progress'] ?? 0,
      isAdded: json['isAdded'] ?? false,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'description': description,
      'wordCount': wordCount,
      'difficulty': difficulty,
      'imageUrl': imageUrl,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'progress': progress,
      'isAdded': isAdded,
    };
  }

  // 创建带有更新进度的副本
  WordLibrary copyWith({
    String? id,
    String? name,
    String? shortName,
    String? description,
    int? wordCount,
    String? difficulty,
    String? imageUrl,
    String? backgroundColor,
    String? textColor,
    int? progress,
    bool? isAdded,
  }) {
    return WordLibrary(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      description: description ?? this.description,
      wordCount: wordCount ?? this.wordCount,
      difficulty: difficulty ?? this.difficulty,
      imageUrl: imageUrl ?? this.imageUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      progress: progress ?? this.progress,
      isAdded: isAdded ?? this.isAdded,
    );
  }
} 