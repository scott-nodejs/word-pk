class User {
  final String id;
  final String name;
  final String? avatarUrl;
  final String initials; // 用户名首字母，如"JD"
  final int level;
  final int experience;
  final int learnedWords;
  final int learningDays;
  final int duelWins;
  final List<Achievement> achievements;
  final List<String> addedLibraryIds; // 已添加的词库ID列表

  User({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.initials,
    this.level = 1,
    this.experience = 0,
    this.learnedWords = 0,
    this.learningDays = 0,
    this.duelWins = 0,
    this.achievements = const [],
    this.addedLibraryIds = const [],
  });

  // 从JSON创建User对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      initials: json['initials'],
      level: json['level'] ?? 1,
      experience: json['experience'] ?? 0,
      learnedWords: json['learnedWords'] ?? 0,
      learningDays: json['learningDays'] ?? 0,
      duelWins: json['duelWins'] ?? 0,
      achievements: json['achievements'] != null
          ? (json['achievements'] as List)
              .map((a) => Achievement.fromJson(a))
              .toList()
          : [],
      addedLibraryIds: json['addedLibraryIds'] != null
          ? List<String>.from(json['addedLibraryIds'])
          : [],
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'initials': initials,
      'level': level,
      'experience': experience,
      'learnedWords': learnedWords,
      'learningDays': learningDays,
      'duelWins': duelWins,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'addedLibraryIds': addedLibraryIds,
    };
  }

  // 创建带有更新属性的副本
  User copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? initials,
    int? level,
    int? experience,
    int? learnedWords,
    int? learningDays,
    int? duelWins,
    List<Achievement>? achievements,
    List<String>? addedLibraryIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      initials: initials ?? this.initials,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      learnedWords: learnedWords ?? this.learnedWords,
      learningDays: learningDays ?? this.learningDays,
      duelWins: duelWins ?? this.duelWins,
      achievements: achievements ?? this.achievements,
      addedLibraryIds: addedLibraryIds ?? this.addedLibraryIds,
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