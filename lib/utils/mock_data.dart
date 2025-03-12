import '../models/word.dart';
import '../models/word_library.dart';
import '../models/user.dart';
import '../models/duel.dart';

/// 模拟数据生成工具类
class MockData {
  /// 获取当前用户
  static User getCurrentUser() {
    return User(
      id: 'user1',
      name: 'John Doe',
      initials: 'JD',
      level: 8,
      experience: 3500,
      learnedWords: 128,
      learningDays: 45,
      duelWins: 18,
      achievements: [
        Achievement(
          id: 'achievement1',
          name: '单词达人',
          description: '学习超过100个单词',
          iconName: 'coin',
          backgroundColor: '#FEF3C7',
          iconColor: '#F59E0B',
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Achievement(
          id: 'achievement2',
          name: '速记王',
          description: '连续答对20个单词',
          iconName: 'lightning',
          backgroundColor: '#E0E7FF',
          iconColor: '#6366F1',
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Achievement(
          id: 'achievement3',
          name: '坚持不懈',
          description: '连续学习10天',
          iconName: 'badge',
          backgroundColor: '#D1FAE5',
          iconColor: '#10B981',
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Achievement(
          id: 'achievement4',
          name: '对战高手',
          description: '赢得10场对战',
          iconName: 'lock',
          backgroundColor: '#F3F4F6',
          iconColor: '#9CA3AF',
          isUnlocked: false,
        ),
      ],
      addedLibraryIds: ['library1', 'library2'],
    );
  }

  /// 获取词库列表
  static List<WordLibrary> getWordLibraries() {
    return [
      WordLibrary(
        id: 'library1',
        name: '大学英语四级',
        shortName: 'CET',
        description: '大学英语四级必备词汇',
        wordCount: 2500,
        difficulty: '中等',
        backgroundColor: '#DBEAFE',
        textColor: '#2563EB',
        progress: 45,
        isAdded: true,
      ),
      WordLibrary(
        id: 'library2',
        name: 'GRE词汇',
        shortName: 'GRE',
        description: 'GRE考试必备词汇',
        wordCount: 5000,
        difficulty: '很高',
        backgroundColor: '#FEE2E2',
        textColor: '#DC2626',
        progress: 20,
        isAdded: true,
      ),
      WordLibrary(
        id: 'library3',
        name: '大学英语六级',
        shortName: 'CET',
        description: '大学英语六级必备词汇',
        wordCount: 2000,
        difficulty: '中高',
        backgroundColor: '#DBEAFE',
        textColor: '#2563EB',
        isAdded: false,
      ),
      WordLibrary(
        id: 'library4',
        name: '雅思词汇',
        shortName: 'IELTS',
        description: '雅思考试必备词汇',
        wordCount: 3500,
        difficulty: '高',
        backgroundColor: '#FEF3C7',
        textColor: '#D97706',
        isAdded: false,
      ),
    ];
  }

  /// 获取推荐词库
  static List<WordLibrary> getRecommendedLibraries() {
    return [
      WordLibrary(
        id: 'library1',
        name: '四级词汇',
        shortName: '4',
        description: '大学英语四级必备词汇',
        wordCount: 2500,
        difficulty: '中等',
        backgroundColor: '#DBEAFE',
        textColor: '#2563EB',
        isAdded: true,
      ),
      WordLibrary(
        id: 'library3',
        name: '六级词汇',
        shortName: '6',
        description: '大学英语六级必备词汇',
        wordCount: 2000,
        difficulty: '中高',
        backgroundColor: '#E9D5FF',
        textColor: '#9333EA',
        isAdded: false,
      ),
    ];
  }

  /// 获取单词列表
  static List<Word> getWords() {
    return [
      Word(
        id: 'word1',
        text: 'Ambiguous',
        pronunciation: '/æmˈbɪɡjuəs/',
        definitions: [
          WordDefinition(
            partOfSpeech: 'adj.',
            meaning: '模糊不清的；有歧义的；不明确的',
          ),
        ],
        examples: [
          WordExample(
            sentence: 'The statement was ambiguous and could be interpreted in various ways.',
            translation: '这个陈述模棱两可，可以有多种解释。',
          ),
        ],
        difficulty: 4,
        memoryStrength: 60,
      ),
      Word(
        id: 'word2',
        text: 'Eloquent',
        pronunciation: '/ˈɛləkwənt/',
        definitions: [
          WordDefinition(
            partOfSpeech: 'adj.',
            meaning: '雄辩的；有说服力的；流利的',
          ),
        ],
        examples: [
          WordExample(
            sentence: 'She gave an eloquent speech at the conference.',
            translation: '她在会议上发表了一篇雄辩的演讲。',
          ),
        ],
        difficulty: 3,
        memoryStrength: 40,
      ),
      Word(
        id: 'word3',
        text: 'Meticulous',
        pronunciation: '/məˈtɪkjələs/',
        definitions: [
          WordDefinition(
            partOfSpeech: 'adj.',
            meaning: '一丝不苟的；极为谨慎的；注重细节的',
          ),
        ],
        examples: [
          WordExample(
            sentence: 'He is meticulous about keeping records of all transactions.',
            translation: '他一丝不苟地保存所有交易记录。',
          ),
        ],
        difficulty: 4,
        memoryStrength: 30,
      ),
    ];
  }

  /// 获取对战历史
  static List<Duel> getDuelHistory() {
    final currentUser = getCurrentUser();
    final opponent1 = User(
      id: 'user2',
      name: 'Sarah',
      initials: 'SK',
      level: 7,
    );
    final opponent2 = User(
      id: 'user3',
      name: 'Mike',
      initials: 'MK',
      level: 9,
    );
    final wordLibrary = getWordLibraries()[0];

    return [
      Duel(
        id: 'duel1',
        player1: currentUser,
        player2: opponent1,
        wordLibrary: wordLibrary,
        wordCount: 10,
        timeLimit: 15,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        completedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        status: DuelStatus.completed,
        player1Score: 7,
        player2Score: 3,
        questions: [],
        player1Answers: [],
        player2Answers: [],
      ),
      Duel(
        id: 'duel2',
        player1: currentUser,
        player2: opponent2,
        wordLibrary: wordLibrary,
        wordCount: 10,
        timeLimit: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        completedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4, minutes: 45)),
        status: DuelStatus.completed,
        player1Score: 3,
        player2Score: 7,
        questions: [],
        player1Answers: [],
        player2Answers: [],
      ),
    ];
  }

  /// 获取对战问题
  static List<DuelQuestion> getDuelQuestions() {
    return [
      DuelQuestion(
        id: 'question1',
        word: 'Ambiguous',
        pronunciation: '/æmˈbɪɡjuəs/',
        options: [
          DuelOption(id: 'option1', text: '模糊不清的，有歧义的'),
          DuelOption(id: 'option2', text: '雄心勃勃的，有野心的'),
          DuelOption(id: 'option3', text: '善变的，多变的'),
          DuelOption(id: 'option4', text: '古老的，远古的'),
        ],
        correctOptionIndex: 0,
      ),
      DuelQuestion(
        id: 'question2',
        word: 'Eloquent',
        pronunciation: '/ˈɛləkwənt/',
        options: [
          DuelOption(id: 'option1', text: '优雅的，高贵的'),
          DuelOption(id: 'option2', text: '雄辩的，有说服力的'),
          DuelOption(id: 'option3', text: '精确的，准确的'),
          DuelOption(id: 'option4', text: '困难的，艰巨的'),
        ],
        correctOptionIndex: 1,
      ),
      DuelQuestion(
        id: 'question3',
        word: 'Meticulous',
        pronunciation: '/məˈtɪkjələs/',
        options: [
          DuelOption(id: 'option1', text: '神秘的，不可思议的'),
          DuelOption(id: 'option2', text: '善变的，多变的'),
          DuelOption(id: 'option3', text: '一丝不苟的，极为谨慎的'),
          DuelOption(id: 'option4', text: '有魅力的，迷人的'),
        ],
        correctOptionIndex: 2,
      ),
    ];
  }
} 