import 'package:flutter/material.dart';
import '../utils/mock_data.dart';
import '../constants/app_theme.dart';
import '../utils/auth_utils.dart';

/// 个人中心页面
class ProfileScreen extends StatelessWidget {
  /// 构造函数
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = MockData.getCurrentUser();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部个人信息背景，不再使用Stack
              GestureDetector(
                onTap: () async {
                  await AuthUtils.checkLoginState(context);
                },
                child: _buildProfileHeader(user),
              ),
              
              // 统计卡片，独立放置而不是重叠
              GestureDetector(
                onTap: () async {
                  await AuthUtils.checkLoginState(context);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                  child: _buildStatisticsCard(),
                ),
              ),
              
              // 成就部分
              GestureDetector(
                onTap: () async {
                  await AuthUtils.checkLoginState(context);
                },
                child: _buildAchievementsSection(),
              ),
              
              // 设置菜单
              GestureDetector(
                onTap: () async {
                  await AuthUtils.checkLoginState(context);
                },
                child: _buildSettingsMenu(),
              ),
              
              // 底部间距，防止内容被底部导航栏遮挡
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 构建顶部个人信息区域
  Widget _buildProfileHeader(dynamic user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24), // 减少底部内边距，因为不需要重叠了
      margin: const EdgeInsets.only(bottom: 0), // 减少与下方卡片的间距
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 用户基本信息和设置按钮
          Row(
            children: [
              // 头像
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    user.initials,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 用户名和等级
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Lv.8',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 设置按钮
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // 打开设置页面
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 36), // 增加顶部和统计区域之间的距离
          // 学习统计数据
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderStatItem('已学单词', '128'),
              _buildHeaderStatItem('学习天数', '45'),
              _buildHeaderStatItem('对决胜场', '18'),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建顶部简单统计项
  Widget _buildHeaderStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  /// 构建学习统计卡片
  Widget _buildStatisticsCard() {
    return Transform.translate(
      offset: const Offset(0, -35), // 向上偏移35像素，稍微再多压一点
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '学习数据',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 查看详细数据
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        '查看详情',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.calendar_today,
                  value: '28',
                  label: '今日单词',
                ),
                _buildStatItem(
                  icon: Icons.local_fire_department,
                  value: '12',
                  label: '连续打卡',
                  valueColor: const Color(0xFFFF6B6B),
                ),
                _buildStatItem(
                  icon: Icons.auto_awesome,
                  value: '1,286',
                  label: '总计词量',
                  valueColor: const Color(0xFF4C6EF5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建统计项
  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
  
  /// 构建成就部分
  Widget _buildAchievementsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '我的成就',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
              TextButton(
                onPressed: () {
                  // 查看全部成就
                },
                child: Text(
                  '查看全部',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAchievementItem(
                icon: Icons.attach_money,
                label: '单词达人',
                color: Colors.amber,
              ),
              _buildAchievementItem(
                icon: Icons.flash_on,
                label: '速记王',
                color: AppTheme.primaryColor,
              ),
              _buildAchievementItem(
                icon: Icons.timer,
                label: '坚持不懈',
                color: Colors.green,
              ),
              _buildAchievementItem(
                icon: Icons.lock,
                label: '未解锁',
                color: Colors.grey,
                isLocked: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// 构建成就项
  Widget _buildAchievementItem({
    required IconData icon,
    required String label,
    required Color color,
    bool isLocked = false,
  }) {
    final backgroundColor = isLocked ? Colors.grey[100]! : color.withOpacity(0.1);
    final iconColor = isLocked ? Colors.grey[400]! : color;
    final textColor = isLocked ? Colors.grey[400]! : Colors.grey[600]!;
    
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
          ),
        ),
      ],
    );
  }
  
  /// 构建设置菜单
  Widget _buildSettingsMenu() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '设置',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.settings,
            iconColor: AppTheme.primaryColor,
            title: '学习设置',
            subtitle: '学习计划、提醒时间',
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.security,
            iconColor: Colors.purple,
            title: '隐私设置',
            subtitle: '账户安全、数据隐私',
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            icon: Icons.help,
            iconColor: Colors.blue,
            title: '帮助与反馈',
            subtitle: '常见问题、联系我们',
          ),
        ],
      ),
    );
  }
  
  /// 构建设置项
  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[100]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
} 