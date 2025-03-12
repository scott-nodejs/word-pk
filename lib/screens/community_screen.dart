import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/user.dart';
import '../utils/mock_data.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/gradient_background.dart';

/// 社区页面
class CommunityScreen extends StatefulWidget {
  /// 构造函数
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  /// 当前选中的分类索引
  int _selectedCategoryIndex = 0;
  
  /// 分类列表
  final List<String> _categories = ['推荐', '学习经验', '词汇技巧', '考试资料'];

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
                          // 排行榜
                          _buildLeaderboard(),
                          
                          // 学习动态
                          _buildLearningFeed(),
                          
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
          // 标题
          const Text(
            '学习社区',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          
          // 右侧按钮
          Row(
            children: [
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
              
              const SizedBox(width: 16),
              
              // 通知按钮
              GestureDetector(
                onTap: () {
                  // 打开通知页面
                },
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.textSecondaryColor,
                  size: 24,
                ),
              ),
            ],
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

  /// 构建排行榜部分
  Widget _buildLeaderboard() {
    final topUser = User(
      id: 'user2',
      name: 'Sarah Kim',
      initials: 'SK',
      level: 7,
    );
    
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      child: GradientBackground(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: 16,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和查看全部按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '本周学习榜',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // 查看全部排行榜
                    },
                    child: Text(
                      '查看全部',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 排行榜第一名
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 用户信息
                  Row(
                    children: [
                      // 头像
                      Stack(
                        children: [
                          AvatarWidget(
                            initials: topUser.initials,
                            size: 48,
                            backgroundColor: Colors.white,
                            textColor: AppTheme.primaryColor,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // 用户名和学习数据
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topUser.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '学习了 320 个单词',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // 评分
                  Row(
                    children: const [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '9.8',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建学习动态部分
  Widget _buildLearningFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题和更多按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '学习动态',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
                fontSize: 16,
              ),
            ),
            IconButton(
              onPressed: () {
                // 显示更多选项
              },
              icon: const Icon(
                Icons.more_vert,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // 动态列表
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildFeedItem(
                userName: 'Mike Johnson',
                userInitials: 'MJ',
                userColor: Colors.blue,
                time: '2小时前',
                content: '分享一个记忆GRE单词的小技巧：将单词分解成词根和词缀，然后联想相关的简单词汇，这样记忆效果会更好！',
                attachmentTitle: 'GRE词汇记忆技巧',
                attachmentSubtitle: '点击查看详细内容',
                likes: 45,
                comments: 12,
                isLiked: false,
              );
            } else {
              return _buildFeedItemWithImages(
                userName: 'Amy Liu',
                userInitials: 'AL',
                userColor: Colors.green,
                time: '昨天 18:30',
                content: '今天完成了托福词汇的学习计划，连续学习30天啦！分享一下我的学习心得：每天坚持学习20个新词，复习50个旧词，效果真的很好！',
                likes: 78,
                comments: 24,
                isLiked: true,
              );
            }
          },
        ),
      ],
    );
  }

  /// 构建动态项（带附件）
  Widget _buildFeedItem({
    required String userName,
    required String userInitials,
    required Color userColor,
    required String time,
    required String content,
    String? attachmentTitle,
    String? attachmentSubtitle,
    required int likes,
    required int comments,
    required bool isLiked,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息和时间
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AvatarWidget(
                    initials: userInitials,
                    size: 40,
                    backgroundColor: userColor.withOpacity(0.1),
                    textColor: userColor,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  // 显示更多选项
                },
                icon: const Icon(
                  Icons.more_horiz,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 内容
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 14,
            ),
          ),
          
          // 附件
          if (attachmentTitle != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachmentTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimaryColor,
                          fontSize: 14,
                        ),
                      ),
                      if (attachmentSubtitle != null)
                        Text(
                          attachmentSubtitle,
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // 操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 点赞和评论
              Row(
                children: [
                  // 点赞按钮
                  GestureDetector(
                    onTap: () {
                      // 点赞/取消点赞
                    },
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : AppTheme.textSecondaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          likes.toString(),
                          style: TextStyle(
                            color: isLiked ? Colors.red : AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // 评论按钮
                  GestureDetector(
                    onTap: () {
                      // 查看/发表评论
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: AppTheme.textSecondaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          comments.toString(),
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // 分享按钮
              GestureDetector(
                onTap: () {
                  // 分享
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.share,
                      color: AppTheme.textSecondaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '分享',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建动态项（带图片）
  Widget _buildFeedItemWithImages({
    required String userName,
    required String userInitials,
    required Color userColor,
    required String time,
    required String content,
    required int likes,
    required int comments,
    required bool isLiked,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息和时间
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AvatarWidget(
                    initials: userInitials,
                    size: 40,
                    backgroundColor: userColor.withOpacity(0.1),
                    textColor: userColor,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  // 显示更多选项
                },
                icon: const Icon(
                  Icons.more_horiz,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 内容
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 图片
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/300x200/DDDDDD/999999?text=学习照片1'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/300x200/DDDDDD/999999?text=学习照片2'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 点赞和评论
              Row(
                children: [
                  // 点赞按钮
                  GestureDetector(
                    onTap: () {
                      // 点赞/取消点赞
                    },
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : AppTheme.textSecondaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          likes.toString(),
                          style: TextStyle(
                            color: isLiked ? Colors.red : AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // 评论按钮
                  GestureDetector(
                    onTap: () {
                      // 查看/发表评论
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: AppTheme.textSecondaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          comments.toString(),
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // 分享按钮
              GestureDetector(
                onTap: () {
                  // 分享
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.share,
                      color: AppTheme.textSecondaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '分享',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 