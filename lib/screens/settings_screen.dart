import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../utils/auth_utils.dart';

/// 设置页面
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部导航
                  Container(
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
                          '设置',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 用户信息
                  Container(
                    padding: const EdgeInsets.all(24),
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
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0E7FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'JD',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'John Doe',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '13800138000',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                          onPressed: () {
                            // TODO: 编辑个人信息
                          },
                        ),
                      ],
                    ),
                  ),

                  // 账号设置
                  _buildSectionTitle('账号设置'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          icon: Icons.lock_outline,
                          iconBgColor: const Color(0xFFDBEAFE),
                          iconColor: const Color(0xFF3B82F6),
                          title: '修改密码',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: Icons.mail_outline,
                          iconBgColor: const Color(0xFFDCFCE7),
                          iconColor: const Color(0xFF10B981),
                          title: '绑定邮箱',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: Icons.chat_bubble_outline,
                          iconBgColor: const Color(0xFFDCFCE7),
                          iconColor: const Color(0xFF10B981),
                          title: '绑定微信',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '已绑定',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xFFD1D5DB),
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  // 学习设置
                  _buildSectionTitle('学习设置'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          icon: Icons.access_time,
                          iconBgColor: const Color(0xFFE0E7FF),
                          iconColor: AppTheme.primaryColor,
                          title: '学习提醒',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '每天 20:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xFFD1D5DB),
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/study-plan');
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.lightbulb_outline,
                          iconBgColor: const Color(0xFFF3E8FF),
                          iconColor: const Color(0xFF9333EA),
                          title: '每日单词数量',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '20个',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xFFD1D5DB),
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/study-plan');
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.view_in_ar,
                          iconBgColor: const Color(0xFFFEF3C7),
                          iconColor: const Color(0xFFD97706),
                          title: '学习模式',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '标准模式',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xFFD1D5DB),
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/study-plan');
                          },
                        ),
                      ],
                    ),
                  ),

                  // 通用设置
                  _buildSectionTitle('通用设置'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          icon: Icons.notifications_none,
                          iconBgColor: const Color(0xFFE0E7FF),
                          iconColor: AppTheme.primaryColor,
                          title: '消息通知',
                          trailing: Switch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: AppTheme.primaryColor,
                          ),
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: Icons.delete_outline,
                          iconBgColor: const Color(0xFFFFE4E6),
                          iconColor: const Color(0xFFDC2626),
                          title: '清除缓存',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: Icons.help_outline,
                          iconBgColor: const Color(0xFFDBEAFE),
                          iconColor: const Color(0xFF3B82F6),
                          title: '关于我们',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  // 退出登录
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: TextButton(
                      onPressed: () {
                        AuthUtils.isLoggedIn = false;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFEE2E2),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '退出登录',
                        style: TextStyle(
                          color: Color(0xFFDC2626),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // 版本信息
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text(
                        'WordDuel v1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建设置项标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  /// 构建设置项
  Widget _buildSettingItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF3F4F6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const Spacer(),
                trailing ?? const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFD1D5DB),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 