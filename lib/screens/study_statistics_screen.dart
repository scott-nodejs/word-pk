import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/gradient_background.dart';

/// 学习统计页面
class StudyStatisticsScreen extends StatefulWidget {
  const StudyStatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StudyStatisticsScreen> createState() => _StudyStatisticsScreenState();
}

class _StudyStatisticsScreenState extends State<StudyStatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部导航栏
              _buildAppBar(),
              
              // 时间选择器
              _buildDateSelector(),
              
              // 学习概览
              _buildOverview(),
              
              // 学习日历
              _buildCalendar(),
              
              // 学习趋势
              _buildTrend(),
              
              // 学习成就
              _buildAchievements(),
            ],
          ),
        ),
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
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.chevron_left,
                  color: AppTheme.textSecondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '学习统计',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          // 更多按钮
          GestureDetector(
            onTap: () {
              // 显示更多选项
            },
            child: const Icon(
              Icons.more_vert,
              color: AppTheme.textSecondaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建时间选择器
  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 上个月按钮
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.chevron_left,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
          ),
          
          // 当前月份
          const Text(
            '2023年10月',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          
          // 下个月按钮
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建学习概览
  Widget _buildOverview() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GradientBackground(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: 16,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '本月学习概览',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOverviewItem('28天', '学习天数'),
                  _buildOverviewItem('420个', '学习单词'),
                  _buildOverviewItem('18小时', '学习时长'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建概览项
  Widget _buildOverviewItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
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

  /// 构建学习日历
  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '学习日历',
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
              children: [
                // 星期标题
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('一', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                    Text('二', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                    Text('三', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                    Text('四', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                    Text('五', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                    Text('六', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                    Text('日', style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                // 日历网格
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 42, // 6周 * 7天
                  itemBuilder: (context, index) {
                    // 这里应该根据实际日期数据来显示
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                // 图例
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(const Color(0xFFD1FAE5), '已学习'),
                    const SizedBox(width: 16),
                    _buildLegendItem(const Color(0xFF6366F1), '今天'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建图例项
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  /// 构建学习趋势
  Widget _buildTrend() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '学习趋势',
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '每日学习单词数',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '周',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '月',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 24,
                            height: 120 * (index + 1) / 7,
                            decoration: BoxDecoration(
                              color: index == 6
                                  ? AppTheme.primaryColor
                                  : const Color(0xFFE0E7FF),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ['一', '二', '三', '四', '五', '六', '日'][index],
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建学习成就
  Widget _buildAchievements() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '学习成就',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildAchievementItem(
            icon: Icons.star,
            title: '学习达人',
            subtitle: '连续学习30天',
            isUnlocked: true,
            color: const Color(0xFFFFF7ED),
            iconColor: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 8),
          _buildAchievementItem(
            icon: Icons.flash_on,
            title: '词汇大师',
            subtitle: '掌握500个单词',
            isUnlocked: true,
            color: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 8),
          _buildAchievementItem(
            icon: Icons.emoji_events,
            title: '对战王者',
            subtitle: '赢得50场对战',
            isUnlocked: false,
            progress: '32/50',
          ),
          const SizedBox(height: 8),
          _buildAchievementItem(
            icon: Icons.check_circle,
            title: '完美记忆',
            subtitle: '一次复习中全部答对',
            isUnlocked: false,
          ),
        ],
      ),
    );
  }

  /// 构建成就项
  Widget _buildAchievementItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isUnlocked = true,
    String? progress,
    Color? color,
    Color? iconColor,
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isUnlocked ? (color ?? const Color(0xFFFFF7ED)) : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isUnlocked ? (iconColor ?? const Color(0xFFF59E0B)) : const Color(0xFF9CA3AF),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isUnlocked ? AppTheme.textPrimaryColor : const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked ? AppTheme.textSecondaryColor : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? const Color(0xFFD1FAE5)
                  : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isUnlocked ? '已获得' : (progress ?? '未获得'),
              style: TextStyle(
                fontSize: 12,
                color: isUnlocked
                    ? const Color(0xFF10B981)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 