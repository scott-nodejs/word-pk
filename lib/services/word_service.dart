import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/word.dart';
import '../models/answer_record.dart';
import '../models/challenge_word.dart';
import '../utils/auth_utils.dart';

/// 单词相关的API服务
class WordService {
  final Dio _dio;
  
  /// API基础URL
  static const String baseUrl = 'http://localhost:9080/oneCode/lazyer';
  
  /// 单例实例
  static final WordService _instance = WordService._internal();
  
  /// 工厂构造函数
  factory WordService() => _instance;
  
  /// 私有构造函数
  WordService._internal() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
    },
  )) {
    // 添加拦截器，为每个请求添加授权头
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 如果用户已登录，则添加Authorization头
        if (AuthUtils.isLoggedIn && AuthUtils.token != null) {
          options.headers['Authorization'] = 'Bearer ${AuthUtils.token}';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        // 如果返回401错误，可能是token过期
        if (error.response?.statusCode == 401) {
          debugPrint('授权失败，请重新登录');
          // 这里可以添加自动刷新token的逻辑，或者清除登录状态
          AuthUtils.clearLoginInfo();
        }
        return handler.next(error);
      }
    ));
  }

  /// 登录并获取token
  Future<bool> login(String phone, String password) async {
    try {
      final response = await _dio.post(
        '/mobile/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 200) {
        // 保存token和用户信息

        AuthUtils.token = response.data['data']['token'];
        AuthUtils.isLoggedIn = true;
        return true;
      }
      debugPrint('登录失败: ${response.data['msg'] ?? '未知错误'}');
      return false;
    } catch (e) {
      debugPrint('登录失败: $e');
      return false;
    }
  }
  
  /// 使用验证码登录
  Future<bool> loginWithVerifyCode(String phone, String verifyCode) async {
    try {
      final response = await _dio.post(
        '/mobile/login',
        data: {
          'phone': phone,
          'code': verifyCode,
          'type': 'code'
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 200) {
        // 保存token和用户信息
        AuthUtils.token = response.data.data['token'];
        AuthUtils.isLoggedIn = true;
        return true;
      }
      debugPrint('验证码登录失败: ${response.data['msg'] ?? '未知错误'}');
      return false;
    } catch (e) {
      debugPrint('验证码登录失败: $e');
      return false;
    }
  }
  
  /// 发送验证码
  Future<bool> sendVerifyCode(String phone, {String type = 'login'}) async {
    try {
      final response = await _dio.post(
        '/mobile/send/code',
        data: {
          'phone': phone,
          'type': type, // 类型可以是login、register、reset等
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return true;
      }
      debugPrint('发送验证码失败: ${response.data['msg'] ?? '未知错误'}');
      return false;
    } catch (e) {
      debugPrint('发送验证码失败: $e');
      return false;
    }
  }
  
  /// 注册新用户
  Future<bool> register(String phone, String password, String verifyCode) async {
    try {
      final response = await _dio.post(
        '/mobile/register',
        data: {
          'phone': phone,
          'password': password,
          'code': verifyCode,
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return true;
      }
      debugPrint('注册失败: ${response.data['msg'] ?? '未知错误'}');
      return false;
    } catch (e) {
      debugPrint('注册失败: $e');
      return false;
    }
  }
  
  /// 重置密码（忘记密码）
  Future<bool> resetPassword(String phone, String newPassword, String verifyCode) async {
    try {
      final response = await _dio.post(
        '/mobile/findPassword',
        data: {
          'phone': phone,
          'newPassword': newPassword,
          'code': verifyCode,
        },
      );
      
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return true;
      }
      debugPrint('重置密码失败: ${response.data['msg'] ?? '未知错误'}');
      return false;
    } catch (e) {
      debugPrint('重置密码失败: $e');
      return false;
    }
  }
  
  /// 退出登录
  Future<void> logout() async {
    try {
      if (AuthUtils.isLoggedIn) {
        final response = await _dio.post('/mobile/logout');
        if (response.statusCode != 200 || response.data['code'] != 200) {
          debugPrint('退出登录API调用失败: ${response.data['msg'] ?? '未知错误'}');
        }
      }
    } catch (e) {
      debugPrint('退出登录失败: $e');
    } finally {
      // 无论API调用是否成功，都清除本地登录信息
      AuthUtils.clearLoginInfo();
    }
  }

  /// 获取单词详情
  Future<Word> getWordDetail(String wordId) async {
    try {
      final response = await _dio.get('/words/$wordId');
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return Word.fromJson(response.data['data']);
      }
      throw Exception(response.data['msg'] ?? '获取单词详情失败');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取单词的词组搭配
  Future<List<Map<String, String>>> getWordPhrases(String wordId) async {
    try {
      final response = await _dio.get('/words/$wordId/phrases');
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return (response.data['data'] as List)
            .map((item) => {
                  'en': item['phrase'].toString(),
                  'zh': item['translation'].toString(),
                })
            .toList();
      }
      throw Exception(response.data['msg'] ?? '获取单词词组搭配失败');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取单词的同义词
  Future<List<Map<String, String>>> getWordSynonyms(String wordId) async {
    try {
      final response = await _dio.get('/words/$wordId/synonyms');
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return (response.data['data'] as List)
            .map((item) => {
                  'en': item['word'].toString(),
                  'zh': item['translation'].toString(),
                })
            .toList();
      }
      throw Exception(response.data['msg'] ?? '获取单词同义词失败');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取单词的反义词
  Future<List<Map<String, String>>> getWordAntonyms(String wordId) async {
    try {
      final response = await _dio.get('/words/$wordId/antonyms');
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return (response.data['data'] as List)
            .map((item) => {
                  'en': item['word'].toString(),
                  'zh': item['translation'].toString(),
                })
            .toList();
      }
      throw Exception(response.data['msg'] ?? '获取单词反义词失败');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 更新单词收藏状态
  Future<void> updateFavoriteStatus(String wordId, bool isFavorite) async {
    try {
      final response = await _dio.put(
        '/words/$wordId/favorite',
        data: {'isFavorite': isFavorite},
      );
      if (response.statusCode != 200 || response.data['code'] != 200) {
        throw Exception(response.data['msg'] ?? '更新收藏状态失败');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取单词学习进度
  Future<Map<String, dynamic>> getWordProgress(String wordId) async {
    try {
      final response = await _dio.get('/words/$wordId/progress');
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return response.data['data'];
      }
      throw Exception(response.data['msg'] ?? '获取单词学习进度失败');
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// 获取单词挑战
  Future<WordChallenge> getWordChallenge(int wordCount) async {
    try {
      final response = await _dio.get('/challenge/new', queryParameters: {
        'count': wordCount,
      });
      
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return WordChallenge.fromJson(response.data['data']);
      }
      throw Exception(response.data['msg'] ?? '获取单词挑战失败');
    } catch (e) {
      debugPrint('获取单词挑战失败: $e');
      throw _handleError(e);
    }
  }
  
  /// 获取挑战单词列表
  Future<List<ChallengeWord>> getChallengeWords(int count) async {
    try {
      // 获取包含单词、释义和选项的挑战单词列表
      final response = await _dio.get('/mobile/challenge/words', queryParameters: {
        'count': count,
      });
      
      if (response.statusCode == 200 && response.data['code'] == 200) {
        // 将响应数据转换为ChallengeWord对象列表
        final List<ChallengeWord> words = (response.data['data'] as List)
            .map((item) => ChallengeWord.fromJson(item))
            .toList();
            
        // 日志记录，帮助调试
        debugPrint('获取到 ${words.length} 个挑战单词');
        for (var word in words) {
          debugPrint('单词: ${word.word}, 选项数量: ${word.options.length}');
        }
        
        return words;
      }
      throw Exception(response.data['msg'] ?? '获取挑战单词列表失败');
    } catch (e) {
      debugPrint('获取挑战单词失败: $e');
      throw _handleError(e);
    }
  }
  
  /// 上传答题记录
  Future<void> uploadAnswerRecord({
    required int wordId,
    required int myAnswer,
    required int answer,
    int type = 1,
    int? bookId,
  }) async {
    try {
      final response = await _dio.post(
        '/mobile/challenge/answer',
        data: {
          'wordId': wordId,
          'myAnwser': myAnswer, // 注意后端字段是myAnwser而不是myAnswer
          'anwser': answer, // 注意后端字段是anwser而不是answer
          'type': type,
          'bookId': bookId,
        },
      );
      
      if (response.statusCode != 200 || response.data['code'] != 200) {
        debugPrint('上传答题记录失败: ${response.data['msg'] ?? '未知错误'}');
      }
    } catch (e) {
      // 记录错误但不抛出，避免影响用户体验
      debugPrint('上传答题记录失败: $e');
    }
  }
  
  /// 上传挑战结果
  Future<void> uploadChallengeResult(List<AnswerRecord> records, Duration totalDuration) async {
    try {
      final correctCount = records.where((record) => record.isCorrect).length;
      
      final response = await _dio.post(
        '/mobile/challenge/result',
        data: {
          'totalWords': records.length,
          'correctCount': correctCount,
          'durationSeconds': totalDuration.inSeconds,
          'answers': records.map((record) => {
            'word': record.word,
            'userAnswer': record.userAnswer,
            'correctAnswer': record.correctAnswer,
            'isCorrect': record.isCorrect,
            'durationMillis': record.duration.inMilliseconds,
          }).toList(),
        },
      );
      
      if (response.statusCode != 200 || response.data['code'] != 200) {
        debugPrint('上传挑战结果失败: ${response.data['msg'] ?? '未知错误'}');
      }
    } catch (e) {
      // 记录错误但不抛出，避免影响用户体验
      debugPrint('上传挑战结果失败: $e');
    }
  }
  
  /// 获取单词发音URL
  Future<String> getWordPronunciationUrl(String wordId) async {
    try {
      final response = await _dio.get('/words/$wordId/pronunciation');
      if (response.statusCode == 200 && response.data['code'] == 200) {
        return response.data['data']['url'];
      }
      throw Exception(response.data['msg'] ?? '获取单词发音URL失败');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 统一处理错误
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('网络连接超时，请检查网络');
        case DioExceptionType.badResponse:
          return Exception('服务器响应错误：${error.response?.statusCode}');
        case DioExceptionType.cancel:
          return Exception('请求已取消');
        default:
          return Exception('网络请求失败：${error.message}');
      }
    }
    return Exception('未知错误：$error');
  }
} 