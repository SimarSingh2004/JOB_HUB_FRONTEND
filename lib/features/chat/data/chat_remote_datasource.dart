import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../models/conversation.dart';
import '../../../models/message.dart';

class ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSource(this._dio);

  // GET /conversations — returns all conversations for logged-in user
  // Backend populates jobId, candidateId, recruiterId automatically
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await _dio.get(ApiConstants.conversations);
      final data = response.data['data'] as List;
      return data
          .map((c) => ConversationModel.fromJson(c as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // POST /conversations — recruiter only
  // Creates conversation if it doesn't exist, returns existing if it does
  Future<ConversationModel> createOrGetConversation({
    required String jobId,
    required String candidateId,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.conversations,
        data: {'jobId': jobId, 'candidateId': candidateId},
      );
      return ConversationModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // GET /messages/:conversationId — paginated, sorted by createdAt desc
  // page 1 = newest messages
  Future<List<MessageModel>> getMessages({
    required String conversationId,
    required int page,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.messages}/$conversationId',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data['data'] as List;
      return data
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // POST /messages — send a message
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.messages,
        data: {'conversationId': conversationId, 'text': text},
      );
      return MessageModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
