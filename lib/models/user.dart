/// 用户模型类
class User {
  /// 用户ID
  final String id;
  
  /// 用户名
  final String name;
  
  /// 用户头像缩写（用于显示头像）
  final String initials;
  
  /// 用户等级
  final int level;
  
  /// 用户积分
  final int score;
  
  /// 构造函数
  const User({
    required this.id,
    required this.name,
    required this.initials,
    required this.level,
    required this.score,
  });

  // 从JSON创建User对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      initials: json['initials'],
      level: json['level'],
      score: json['score'],
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'initials': initials,
      'level': level,
      'score': score,
    };
  }

  // 创建带有更新属性的副本
  User copyWith({
    String? id,
    String? name,
    String? initials,
    int? level,
    int? score,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      level: level ?? this.level,
      score: score ?? this.score,
    );
  }
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String backgroundColor; // 十六进制颜色字符串
  final String iconColor; // 十六进制颜色字符串
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.backgroundColor,
    required this.iconColor,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  // 从JSON创建Achievement对象
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconName: json['iconName'],
      backgroundColor: json['backgroundColor'],
      iconColor: json['iconColor'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'backgroundColor': backgroundColor,
      'iconColor': iconColor,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
} 