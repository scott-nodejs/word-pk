import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// 添加好友页面
class AddFriendScreen extends StatefulWidget {
  /// 构造函数
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  /// 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  
  /// 搜索结果
  final List<Map<String, dynamic>> _searchResults = [
    {
      'id': '10086',
      'name': 'Tom Zhang',
      'initials': 'TZ',
      'avatarColor': Colors.blue,
      'level': 5,
      'isAdded': false,
    },
    {
      'id': '10087',
      'name': 'Tina Li',
      'initials': 'TL',
      'avatarColor': Colors.purple,
      'level': 7,
      'isAdded': true,
    },
  ];
  
  /// 推荐好友
  final List<Map<String, dynamic>> _recommendedFriends = [
    {
      'id': '10088',
      'name': 'Jack Chen',
      'initials': 'JC',
      'avatarColor': Colors.green,
      'level': 6,
      'reason': '与你学习相同词库',
      'isAdded': false,
    },
    {
      'id': '10089',
      'name': 'Lucy Wang',
      'initials': 'LW',
      'avatarColor': Colors.amber,
      'level': 8,
      'reason': '学习天数排名第一',
      'isAdded': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 顶部状态栏占位
          SizedBox(height: statusBarHeight),
          
          // 顶部导航
          _buildTopBar(context),
          
          // 主要内容（可滚动）
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 搜索框
                  _buildSearchBar(),
                  
                  // 添加方式
                  _buildAddMethods(),
                  
                  // 搜索结果
                  _buildSearchResults(),
                  
                  // 推荐好友
                  _buildRecommendedFriends(),
                  
                  // 底部间距
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建顶部导航栏
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            color: const Color(0xFF6B7280),
          ),
          const SizedBox(width: 12),
          const Text(
            '添加好友',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建搜索栏
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '搜索用户ID、手机号',
            hintStyle: TextStyle(
              color: Color(0xFF9CA3AF),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFF9CA3AF),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }

  /// 构建添加方式
  Widget _buildAddMethods() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '添加方式',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          
          // 添加方式网格
          Row(
            children: [
              _buildAddMethodItem(Icons.qr_code_scanner, '扫一扫'),
              const SizedBox(width: 12),
              _buildAddMethodItem(Icons.qr_code, '我的二维码'),
              const SizedBox(width: 12),
              _buildAddMethodItem(Icons.contacts, '通讯录'),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建添加方式项
  Widget _buildAddMethodItem(IconData icon, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // 点击添加方式
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建搜索结果
  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '搜索结果',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          
          // 搜索结果列表
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _searchResults.length,
            itemBuilder: (context, index) => _buildUserItem(
              _searchResults[index],
              isRecommended: false,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建推荐好友
  Widget _buildRecommendedFriends() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '推荐好友',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          
          // 推荐好友列表
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _recommendedFriends.length,
            itemBuilder: (context, index) => _buildUserItem(
              _recommendedFriends[index],
              isRecommended: true,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建用户项
  Widget _buildUserItem(Map<String, dynamic> user, {required bool isRecommended}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // 头像
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: user['avatarColor'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user['initials'],
                      style: TextStyle(
                        color: user['avatarColor'],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // 用户信息
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // 等级标签
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Lv.${user['level']}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // ID或推荐原因
                        Text(
                          isRecommended ? user['reason'] : 'ID: ${user['id']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            // 添加按钮
            TextButton(
              onPressed: user['isAdded'] ? null : () {
                // 添加好友
                setState(() {
                  user['isAdded'] = true;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: user['isAdded'] 
                    ? const Color(0xFFE5E7EB) 
                    : AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                user['isAdded'] ? '已添加' : '添加',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: user['isAdded'] 
                      ? const Color(0xFF6B7280) 
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 