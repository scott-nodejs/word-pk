import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word_library.dart';
import '../utils/mock_data.dart';

/// 词书选择页面
class LibrarySelectionScreen extends StatefulWidget {
  /// 构造函数
  const LibrarySelectionScreen({Key? key}) : super(key: key);

  @override
  State<LibrarySelectionScreen> createState() => _LibrarySelectionScreenState();
}

class _LibrarySelectionScreenState extends State<LibrarySelectionScreen> {
  /// 所有可用词书列表
  late List<WordLibrary> _allLibraries;
  
  /// 搜索关键词
  String _searchKeyword = '';
  
  /// 当前选中的难度
  String _selectedDifficulty = '全部';
  
  /// 当前选中的词书
  WordLibrary? _selectedLibrary;
  
  /// 词书难度列表
  final List<String> _difficulties = ['全部', '简单', '中等', '中高', '高', '很高'];
  
  @override
  void initState() {
    super.initState();
    _allLibraries = MockData.getWordLibraries();
    // 初始化选中当前正在使用的词书
    _selectedLibrary = _allLibraries.firstWhere((lib) => lib.isAdded, orElse: () => _allLibraries.first);
  }
  
  /// 过滤后的词书列表
  List<WordLibrary> get _filteredLibraries {
    return _allLibraries.where((library) {
      // 根据搜索关键词过滤
      final matchesSearch = _searchKeyword.isEmpty || 
          library.name.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
          library.description.toLowerCase().contains(_searchKeyword.toLowerCase());
      
      // 根据难度过滤
      final matchesDifficulty = _selectedDifficulty == '全部' || 
          library.difficulty == _selectedDifficulty;
      
      return matchesSearch && matchesDifficulty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('选择词书', style: TextStyle(color: AppTheme.textPrimaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimaryColor),
        actions: [
          // 保存按钮
          TextButton(
            onPressed: () {
              // 更新所有词书为未选中状态
              List<WordLibrary> updatedLibraries = _allLibraries.map((lib) {
                return lib.copyWith(isAdded: false);
              }).toList();
              
              // 更新选中的词书
              if (_selectedLibrary != null) {
                final selectedIndex = updatedLibraries.indexWhere(
                  (lib) => lib.id == _selectedLibrary!.id
                );
                if (selectedIndex != -1) {
                  updatedLibraries[selectedIndex] = updatedLibraries[selectedIndex].copyWith(isAdded: true);
                }
              }
              
              // 更新全局词书列表
              setState(() {
                _allLibraries = updatedLibraries;
              });
              
              // 返回上一页
              Navigator.pop(context);
            },
            child: const Text(
              '保存',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 当前选中的词书
          if (_selectedLibrary != null)
            _buildSelectedLibrary(_selectedLibrary!),
            
          // 搜索框
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索词书',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondaryColor),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),
          
          // 难度选择
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _difficulties.length,
              itemBuilder: (context, index) {
                final difficulty = _difficulties[index];
                final isSelected = difficulty == _selectedDifficulty;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 词书列表
          Expanded(
            child: _filteredLibraries.isEmpty
                ? const Center(child: Text('没有找到符合条件的词书'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredLibraries.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final library = _filteredLibraries[index];
                      final isSelected = _selectedLibrary?.id == library.id;
                      return _buildLibraryItem(library, isSelected);
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  /// 构建当前选中的词书
  Widget _buildSelectedLibrary(WordLibrary library) {
    final Color backgroundColor = Color(int.parse(library.backgroundColor.substring(1), radix: 16) + 0xFF000000);
    final Color textColor = Color(int.parse(library.textColor.substring(1), radix: 16) + 0xFF000000);
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor.withOpacity(0.15),
            backgroundColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: backgroundColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // 词书图标
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.book,
              color: textColor,
              size: 30,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 词书信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '当前选择',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  library.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${library.wordCount} 词 · ${library.difficulty}',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          
          // 已选中标记
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.check_circle,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建词书项
  Widget _buildLibraryItem(WordLibrary library, bool isSelected) {
    // 将十六进制颜色字符串转换为Color对象
    final Color backgroundColor = Color(int.parse(library.backgroundColor.substring(1), radix: 16) + 0xFF000000);
    final Color textColor = Color(int.parse(library.textColor.substring(1), radix: 16) + 0xFF000000);
    
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? backgroundColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? backgroundColor.withOpacity(0.3) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLibrary = library;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 词书图标
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.book,
                  color: textColor,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // 词书信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      library.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${library.wordCount} 词 · ${library.difficulty}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 选择状态
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isSelected 
                    ? null 
                    : Border.all(color: AppTheme.textSecondaryColor.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.check,
                  color: isSelected ? Colors.white : Colors.transparent,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 