import 'package:flutter/material.dart';
import '../models/word_library.dart';
import 'library_card.dart';
import 'section_header.dart';

/// 词库列表区域组件
/// 
/// 显示用户的词库列表，带有标题和查看全部按钮
class LibrarySection extends StatelessWidget {
  /// 词库列表
  final List<WordLibrary> libraries;
  
  /// 点击查看全部按钮的回调
  final VoidCallback onViewAll;
  
  /// 点击词库卡片的回调
  final Function(WordLibrary) onLibraryTap;
  
  /// 最大显示数量
  final int maxDisplay;

  /// 构造函数
  const LibrarySection({
    Key? key,
    required this.libraries,
    required this.onViewAll,
    required this.onLibraryTap,
    this.maxDisplay = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 如果超过最大显示数量，则截取
    final displayLibraries = libraries.length > maxDisplay 
        ? libraries.sublist(0, maxDisplay) 
        : libraries;
    
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          // 标题和查看全部按钮
          SectionHeader(
            title: '我的词库',
            actionText: '查看全部',
            onActionTap: onViewAll,
          ),
          
          const SizedBox(height: 12),
          
          // 词库列表
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayLibraries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final library = displayLibraries[index];
              return LibraryCard(
                library: library,
                showProgress: true,
                onTap: () => onLibraryTap(library),
              );
            },
          ),
        ],
      ),
    );
  }
} 