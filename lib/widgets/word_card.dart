import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/word.dart';

/// 单词卡片组件
class WordCard extends StatelessWidget {
  /// 单词
  final Word word;
  
  /// 是否显示释义
  final bool showDefinition;
  
  /// 是否显示收藏按钮
  final bool showFavoriteButton;
  
  /// 是否已收藏
  final bool isFavorite;
  
  /// 收藏按钮点击回调
  final Function(bool)? onFavoriteToggle;
  
  /// 发音按钮点击回调
  final VoidCallback? onPronounce;
  
  /// 显示/隐藏释义按钮点击回调
  final VoidCallback? onToggleDefinition;
  
  /// 词库名称
  final String? libraryName;
  
  /// 构造函数
  const WordCard({
    Key? key,
    required this.word,
    this.showDefinition = false,
    this.showFavoriteButton = true,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onPronounce,
    this.onToggleDefinition,
    this.libraryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 顶部信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (libraryName != null)
                  Text(
                    libraryName!,
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                if (showFavoriteButton)
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : AppTheme.textSecondaryColor,
                    ),
                    onPressed: () {
                      if (onFavoriteToggle != null) {
                        onFavoriteToggle!(!isFavorite);
                      }
                    },
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 单词
            Text(
              word.text,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // 音标
            Text(
              word.pronunciation,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // 发音按钮
            ElevatedButton(
              onPressed: onPronounce,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0E7FF),
                foregroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.volume_up, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '发音',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 显示/隐藏释义按钮
            TextButton(
              onPressed: onToggleDefinition,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    showDefinition ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    showDefinition ? '隐藏释义' : '显示释义',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            // 释义部分
            if (showDefinition) ...[
              const SizedBox(height: 16),
              _buildDefinitionSection(),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建释义部分
  Widget _buildDefinitionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 释义
          const Text(
            '释义',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ...word.definitions.map((def) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${def.partOfSpeech} ${def.meaning}',
                style: const TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          
          const SizedBox(height: 16),
          
          // 例句
          if (word.examples.isNotEmpty) ...[
            const Text(
              '例句',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...word.examples.map((example) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      example.sentence,
                      style: const TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      example.translation,
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
} 