import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
// ignore: unused_import
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../models/conversation.dart';
import '../../data/chat_remote_datasource.dart';
import '../../data/chat_repository.dart';

class ConversationsState {
  final List<ConversationModel> conversations;
  final bool isLoading;
  final String? error;

  const ConversationsState({
    this.conversations = const [],
    this.isLoading = true,
    this.error,
  });

  ConversationsState copyWith({
    List<ConversationModel>? conversations,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class ConversationsViewModel extends AutoDisposeNotifier<ConversationsState> {
  @override
  ConversationsState build() {
    Future.microtask(() => fetch());
    return const ConversationsState(isLoading: true);
  }

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final repo = ref.read(chatRepositoryProvider);

    try {
      final conversations = await repo.getConversations();
      state = state.copyWith(conversations: conversations, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  // Called after recruiter creates a conversation —
  // adds it to the top of the list without a full reload
  void prependConversation(ConversationModel conversation) {
    final exists = state.conversations.any((c) => c.id == conversation.id);
    if (!exists) {
      state = state.copyWith(
        conversations: [conversation, ...state.conversations],
      );
    }
  }
}

// ---- Providers ----

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return ChatRemoteDataSource(dio);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remote = ref.watch(chatRemoteDataSourceProvider);
  return ChatRepository(remote);
});

final conversationsViewModelProvider =
    AutoDisposeNotifierProvider<ConversationsViewModel, ConversationsState>(
      ConversationsViewModel.new,
    );
