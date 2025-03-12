import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word_library.dart';
import '../utils/mock_data.dart';
import '../widgets/library_card.dart';

/// 词库选择页面
class LibraryScreen extends StatefulWidget {
  /// 构造函数
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  /// 所有词库列表
  late List<WordLibrary> _allLibraries;
  
  /// 推荐词库列表
  late List<WordLibrary> _recommendedLibraries;
  
  /// 当前选中的分类索引
  int _selectedCategoryIndex = 0;
  
  /// 分类列表
  final List<String> _categories = ['全部', '考试词汇', '专业词汇', '日常词汇'];

  @override
  void initState() {
    super.initState();
    _allLibraries = MockData.getWordLibraries();
    _recommendedLibraries = MockData.getRecommendedLibraries();
  }

  /// 添加/移除词库
  void _toggleLibraryAdd(WordLibrary library, bool isAdded) {
    setState(() {
      final index = _allLibraries.indexWhere((lib) => lib.id == library.id);
      if (index != -1) {
        _allLibraries[index] = library.copyWith(isAdded: isAdded);
      }
      
      final recIndex = _recommendedLibraries.indexWhere((lib) => lib.id == library.id);
      if (recIndex != -1) {
        _recommendedLibraries[recIndex] = library.copyWith(isAdded: isAdded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 顶部渐变背景
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4, // 屏幕高度的40%
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFDBEAFE), // 更好看的浅蓝色起始色
                    const Color(0xFFEFF6FF), 
                    const Color(0xFFF1F5F9).withOpacity(0.6),
                    Colors.white.withOpacity(0), // 渐变至透明
                  ],
                  stops: const [0.0, 0.5, 0.8, 1.0],
                ),
              ),
            ),
          ),
          // 主要内容
          SafeArea(
            child: Column(
              children: [
                // 顶部导航栏
                _buildAppBar(),
                
                // 分类标签
                _buildCategoryTabs(),
                
                // 内容区域
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 推荐词库
                          _buildRecommendedSection(),
                          
                          // 所有词库
                          _buildAllLibrariesSection(),
                          
                          // 底部间距
                          const SizedBox(height: 16),
                        ],
                      ),
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

  /// 构建顶部导航栏
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 返回按钮和标题
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // 返回上一页
                },
                child: const Icon(
                  Icons.chevron_left,
                  color: AppTheme.textSecondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '词库中心',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          // 搜索按钮
          GestureDetector(
            onTap: () {
              // 打开搜索页面
            },
            child: const Icon(
              Icons.search,
              color: AppTheme.textSecondaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分类标签
  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedCategoryIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 构建推荐词库部分
  Widget _buildRecommendedSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 20.0), // 减少底部间距
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '推荐词库',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12), // 减少间距
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12, // 减少间距
              mainAxisSpacing: 12, // 减少间距
              childAspectRatio: 1.3, // 调整宽高比
            ),
            itemCount: _recommendedLibraries.length,
            itemBuilder: (context, index) {
              final library = _recommendedLibraries[index];
              return LibraryCard(
                library: library,
                isSmall: true,
                onTap: () {
                  // 跳转到词库详情页
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// 构建所有词库部分
  Widget _buildAllLibrariesSection() {
    // 根据当前选中的分类过滤词库
    List<WordLibrary> filteredLibraries = _allLibraries;
    if (_selectedCategoryIndex > 0) {
      final category = _categories[_selectedCategoryIndex];
      // 这里简化处理，实际应用中应该在词库模型中添加分类字段
      if (category == '考试词汇') {
        filteredLibraries = _allLibraries.where((lib) => 
          lib.name.contains('四级') || 
          lib.name.contains('六级') || 
          lib.name.contains('雅思') || 
          lib.name.contains('托福') || 
          lib.name.contains('GRE')
        ).toList();
      } else if (category == '专业词汇') {
        filteredLibraries = _allLibraries.where((lib) => 
          lib.name.contains('专业') || 
          lib.name.contains('医学') || 
          lib.name.contains('IT') || 
          lib.name.contains('金融')
        ).toList();
      } else if (category == '日常词汇') {
        filteredLibraries = _allLibraries.where((lib) => 
          lib.name.contains('日常') || 
          lib.name.contains('口语') || 
          lib.name.contains('旅游')
        ).toList();
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '所有词库',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredLibraries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final library = filteredLibraries[index];
            return LibraryCard(
              library: library,
              onToggleAdd: (isAdded) => _toggleLibraryAdd(library, isAdded),
            );
          },
        ),
      ],
    );
  }
} 