import '../../../models/conversation.dart';
import '../../../models/message.dart';
import 'chat_remote_datasource.dart';

class ChatRepository {
  final ChatRemoteDataSource _remote;

  ChatRepository(this._remote);

  Future<List<ConversationModel>> getConversations() {
    return _remote.getConversations();
  }

  Future<ConversationModel> createOrGetConversation({
    required String jobId,
    required String candidateId,
  }) {
    return _remote.createOrGetConversation(
      jobId: jobId,
      candidateId: candidateId,
    );
  }

  Future<List<MessageModel>> getMessages({
    required String conversationId,
    required int page,
    int limit = 20,
  }) {
    return _remote.getMessages(
      conversationId: conversationId,
      page: page,
      limit: limit,
    );
  }

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String text,
  }) {
    return _remote.sendMessage(conversationId: conversationId, text: text);
  }
}
