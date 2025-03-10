import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word_library.dart';
import '../utils/color_utils.dart';

/// 词库卡片组件
class LibraryCard extends StatelessWidget {
  /// 词库
  final WordLibrary library;
  
  /// 点击回调
  final VoidCallback? onTap;
  
  /// 添加/移除按钮点击回调
  final Function(bool)? onToggleAdd;
  
  /// 是否显示进度
  final bool showProgress;
  
  /// 是否使用小尺寸
  final bool isSmall;
  
  /// 构造函数
  const LibraryCard({
    Key? key,
    required this.library,
    this.onTap,
    this.onToggleAdd,
    this.showProgress = false,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 解析颜色
    final bgColor = ColorUtils.fromHex(library.backgroundColor);
    final txtColor = ColorUtils.fromHex(library.textColor);
    
    if (isSmall) {
      return _buildSmallCard(bgColor, txtColor);
    } else {
      return _buildRegularCard(bgColor, txtColor);
    }
  }

  /// 构建常规尺寸卡片
  Widget _buildRegularCard(Color bgColor, Color txtColor) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
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
            // 词库图标
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  library.shortName,
                  style: TextStyle(
                    color: txtColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // 词库信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    library.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${library.wordCount}词 | 难度: ${library.difficulty}',
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  if (showProgress && library.isAdded) ...[
                    const SizedBox(height: 4),
                    Text(
                      '进度: ${library.progress}%',
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // 添加/移除按钮
            if (onToggleAdd != null)
              ElevatedButton(
                onPressed: () => onToggleAdd!(!library.isAdded),
                style: ElevatedButton.styleFrom(
                  backgroundColor: library.isAdded ? Colors.grey[200] : AppTheme.primaryColor,
                  foregroundColor: library.isAdded ? Colors.grey[700] : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: const Size(0, 32),
                ),
                child: Text(
                  library.isAdded ? '移除' : '添加',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            
            // 箭头图标
            if (onToggleAdd == null)
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondaryColor,
              ),
          ],
        ),
      ),
    );
  }

  /// 构建小尺寸卡片（用于推荐词库）
  Widget _buildSmallCard(Color bgColor, Color txtColor) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor, bgColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      library.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${library.wordCount}词',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      library.shortName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // 底部按钮
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: txtColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: const Size(0, 28),
              ),
              child: const Text(
                '开始学习',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 