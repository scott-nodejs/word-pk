import '../models/word.dart';
import '../models/word_library.dart';
import '../models/user.dart';
import '../models/duel.dart';
import '../models/wrong_answer.dart';

/// 模拟数据生成工具类
class MockData {
  /// 获取当前用户
  static User getCurrentUser() {
    return User(
      id: 'user1',
      name: 'John Doe',
      initials: 'JD',
      level: 8,
      score: 3500,
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
      score: 1865,
    );
    final opponent2 = User(
      id: 'user3',
      name: 'Mike',
      initials: 'MK',
      level: 9,
      score: 1720,
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

  /// 获取错题列表
  static List<WrongAnswer> getWrongAnswers() {
    return [
      WrongAnswer(
        word: 'accomplish',
        pronunciation: '/əˈkʌmplɪʃ/',
        userAnswer: '实现；完成',
        correctAnswer: '完成；达到',
        addedDate: DateTime.now(),
      ),
      WrongAnswer(
        word: 'determine',
        pronunciation: '/dɪˈtɜːmɪn/',
        userAnswer: '决心；意志',
        correctAnswer: '决定；确定',
        addedDate: DateTime.now(),
      ),
      WrongAnswer(
        word: 'elaborate',
        pronunciation: '/ɪˈlæbərət/',
        userAnswer: '阐述；说明',
        correctAnswer: '精心制作的；详尽的',
        addedDate: DateTime.now().subtract(const Duration(days: 1)),
        isReviewed: true,
      ),
      WrongAnswer(
        word: 'facilitate',
        pronunciation: '/fəˈsɪlɪteɪt/',
        userAnswer: '方便；简化',
        correctAnswer: '促进；使容易',
        addedDate: DateTime.now().subtract(const Duration(days: 3)),
        isReviewed: true,
      ),
      WrongAnswer(
        word: 'controversial',
        pronunciation: '/ˌkɒntrəˈvɜːʃl/',
        userAnswer: '竞争的；争议的',
        correctAnswer: '有争议的；引起争论的',
        addedDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      WrongAnswer(
        word: 'advocate',
        pronunciation: '/ˈædvəkeɪt/',
        userAnswer: '建议；劝告',
        correctAnswer: '提倡；拥护',
        addedDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      WrongAnswer(
        word: 'allocate',
        pronunciation: '/ˈæləkeɪt/',
        userAnswer: '分类；归类',
        correctAnswer: '分配；分派',
        addedDate: DateTime.now().subtract(const Duration(days: 7)),
        isReviewed: true,
      ),
    ];
  }

  /// 获取单词挑战的单词列表
  static List<Word> getWordsForChallenge(int count) {
    // 使用现有的单词数据，也可以创建专门的挑战词汇
    final allWords = getWords();
    allWords.shuffle(); // 随机打乱顺序
    return allWords.take(count).toList();
  }
  
  /// 获取单个随机错误选项
  static String getRandomWrongMeaning() {
    final wrongMeanings = _getWrongMeaningList();
    wrongMeanings.shuffle();
    return wrongMeanings.first;
  }
  
  /// 获取多个随机错误选项
  static List<String> getRandomWrongMeanings(int count) {
    final allWrongMeanings = _getWrongMeaningList();
    allWrongMeanings.shuffle();
    
    // 确保不超过可用的错误选项数量
    final actualCount = count > allWrongMeanings.length ? allWrongMeanings.length : count;
    return allWrongMeanings.sublist(0, actualCount);
  }
  
  /// 获取错误选项列表
  static List<String> _getWrongMeaningList() {
    return [
      '处理；解决',
      '认为；相信',
      '想象；假设',
      '改变；修改',
      '分析；研究',
      '寻找；搜索',
      '应用；使用',
      '保持；维持',
      '接受；承认',
      '检查；查看',
      '拒绝；抵制',
      '完成；实现',
      '探索；发现',
      '关注；集中',
      '转变；变化',
      '增强；提高',
      '减少；降低',
      '支持；赞同',
      '反对；否定',
      '创造；建立',
      '破坏；摧毁',
      '参与；加入',
      '退出；离开',
      '开始；启动',
      '结束；完成',
    ];
  }
} 