import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word.dart';

/// 单词详情页面
class WordDetailScreen extends StatefulWidget {
  /// 构造函数
  const WordDetailScreen({
    Key? key,
    required this.word,
  }) : super(key: key);

  /// 单词对象
  final Word word;

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  /// 是否收藏
  bool _isFavorite = false;

  /// 当前显示的是同义词还是反义词
  bool _showSynonyms = true;

  @override
  void initState() {
    super.initState();
    // 初始化收藏状态 - 移除错误的isFavorite引用
    _isFavorite = false; // 默认为未收藏
  }

  /// 切换收藏状态
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // 实际应用中，这里应该更新数据库
  }

  /// 播放发音
  void _playPronunciation() {
    // 实际应用中，这里应该调用文本转语音API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('播放发音...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 内容区域
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部导航
                  _buildTopBar(),
                  
                  // 单词内容
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 单词和发音
                        _buildWordHeader(),
                        
                        // 词性解释
                        _buildDefinitions(),
                        
                        // 例句
                        _buildExamples(),
                        
                        // 词组搭配
                        _buildPhrases(),
                        
                        // 记忆技巧
                        _buildMemoryTips(),
                        
                        // 同义词/反义词
                        _buildSynonymsAntonyms(),
                        
                        // 词形变化
                        _buildWordForms(),
                        
                        // 学习进度
                        _buildLearningProgress(),
                        
                        // 底部空间，为固定按钮留出空间
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 底部操作栏
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomActions(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 返回按钮和标题
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.grey[500],
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              const Text(
                '单词详情',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          
          // 更多选项按钮
          IconButton(
            icon: const Icon(Icons.more_horiz),
            color: Colors.grey[500],
            onPressed: () {
              // 显示更多选项菜单
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  /// 构建单词标题和发音
  Widget _buildWordHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 单词和音标
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.word.text,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    widget.word.pronunciation, // 使用pronunciation而不是phonetic
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _playPronunciation,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.volume_up,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // 收藏按钮
        InkWell(
          onTap: _toggleFavorite,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey[400],
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建词性解释
  Widget _buildDefinitions() {
    final definitions = widget.word.definitions;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 遍历所有词性和释义
          // 修改为直接遍历List<WordDefinition>而不是使用entries
          for (final definition in definitions)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 词性
                  Text(
                    definition.partOfSpeech,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 释义 - WordDefinition只有一个meaning，不是列表
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            definition.meaning,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 如果有英文释义，也显示出来
                  if (definition.englishMeaning != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0, left: 16.0),
                      child: Text(
                        definition.englishMeaning!,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 构建例句
  Widget _buildExamples() {
    // 使用Word模型中的实际例句而不是硬编码
    final examples = widget.word.examples;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '例句',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: examples.map((example) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      example.sentence,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      example.translation,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 构建词组搭配
  Widget _buildPhrases() {
    // 示例词组，实际应用中应该从API获取
    final phrases = [
      {
        'en': 'appreciate it',
        'zh': '感激不尽',
      },
      {
        'en': 'deeply appreciate',
        'zh': '深表感谢',
      },
      {
        'en': 'greatly appreciate',
        'zh': '非常感谢',
      },
      {
        'en': 'fully appreciate',
        'zh': '充分理解',
      },
    ];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '词组搭配',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5,
            ),
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      phrases[index]['en']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      phrases[index]['zh']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建记忆技巧
  Widget _buildMemoryTips() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '记忆技巧',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.bolt,
                    size: 20,
                    color: Colors.blue[600],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '词根记忆：',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ap(去) + preci(价值) + ate(动词后缀) = 对...有价值 → 欣赏；感激',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建同义词/反义词
  Widget _buildSynonymsAntonyms() {
    // 示例同义词和反义词，实际应用中应该从API获取
    final synonyms = [
      {'en': 'value', 'zh': '重视；珍惜'},
      {'en': 'cherish', 'zh': '珍爱；珍惜'},
      {'en': 'esteem', 'zh': '尊重；敬重'},
      {'en': 'treasure', 'zh': '珍视；珍藏'},
    ];
    
    final antonyms = [
      {'en': 'undervalue', 'zh': '低估'},
      {'en': 'depreciate', 'zh': '贬低；轻视'},
      {'en': 'disregard', 'zh': '忽视；不尊重'},
      {'en': 'despise', 'zh': '鄙视；轻蔑'},
    ];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '同义词/反义词',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _showSynonyms = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _showSynonyms ? AppTheme.primaryColor : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '同义词',
                        style: TextStyle(
                          fontSize: 12,
                          color: _showSynonyms ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _showSynonyms = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: !_showSynonyms ? AppTheme.primaryColor : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '反义词',
                        style: TextStyle(
                          fontSize: 12,
                          color: !_showSynonyms ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final words = _showSynonyms ? synonyms : antonyms;
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      words[index]['en']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      words[index]['zh']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建词形变化
  Widget _buildWordForms() {
    // 示例词形变化，实际应用中应该从API获取
    final wordForms = [
      {'type': '过去式：', 'word': 'appreciated'},
      {'type': '过去分词：', 'word': 'appreciated'},
      {'type': '现在分词：', 'word': 'appreciating'},
      {'type': '名词：', 'word': 'appreciation'},
      {'type': '形容词：', 'word': 'appreciative'},
    ];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '词形变化',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: wordForms.map((form) {
                final isLast = wordForms.indexOf(form) == wordForms.length - 1;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          form['type']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          form['word']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建学习进度
  Widget _buildLearningProgress() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '学习进度',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            size: 20,
                            color: Colors.green[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '已掌握',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              '上次复习：2天前',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '记忆强度',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          '92%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.92,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600]!),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部操作按钮
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                // 标记为生词
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[100],
                foregroundColor: Colors.grey[700],
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '标记为生词',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // 开始练习
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '开始练习',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 