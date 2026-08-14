import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../models/message.dart';
// ignore: unused_import
import '../../data/chat_repository.dart';
import 'conversations_viewmodel.dart';

class ChatState {
  final List<MessageModel> messages;
  final bool isLoading; // first load
  final bool isLoadingMore; // loading older messages (scroll up)
  final bool isSending; // send button spinner
  final bool hasMore; // more older pages available
  final int currentPage;
  final String? error;
  final String? sendError;

  const ChatState({
    this.messages = const [],
    this.isLoading = true,
    this.isLoadingMore = false,
    this.isSending = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
    this.sendError,
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSending,
    bool? hasMore,
    int? currentPage,
    String? error,
    String? sendError,
    bool clearError = false,
    bool clearSendError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSending: isSending ?? this.isSending,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: clearError ? null : error ?? this.error,
      sendError: clearSendError ? null : sendError ?? this.sendError,
    );
  }
}

class ChatViewModel extends FamilyNotifier<ChatState, String> {
  // The polling timer — fires every 4 seconds
  Timer? _pollTimer;

  // conversationId comes as the family argument
  @override
  ChatState build(String conversationId) {
    // Fetch messages immediately on open
    Future.microtask(() => _initialLoad(conversationId));

    // Start polling — only while this screen is alive
    _startPolling(conversationId);

    // When the provider is disposed (screen closed), cancel timer
    // This is the key — no wasted API calls in the background
    ref.onDispose(() {
      _pollTimer?.cancel();
    });

    return const ChatState(isLoading: true);
  }

  void _startPolling(String conversationId) {
    // Timer.periodic fires the callback every 4 seconds
    // We poll page 1 (newest) to catch new incoming messages
    _pollTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _pollForNewMessages(conversationId),
    );
  }

  // Initial load — fetches first page, sets up the list
  Future<void> _initialLoad(String conversationId) async {
    final repo = ref.read(chatRepositoryProvider);
    try {
      final messages = await repo.getMessages(
        conversationId: conversationId,
        page: 1,
      );

      state = state.copyWith(
        // Backend returns newest first, we reverse for display
        // so oldest shows at top, newest at bottom — chat convention
        messages: messages.reversed.toList(),
        isLoading: false,
        currentPage: 1,
        // If backend returned less than limit, no more pages
        hasMore: messages.length >= 20,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Called by the polling timer every 4 seconds
  // Silently fetches page 1 and prepends any new messages
  Future<void> _pollForNewMessages(String conversationId) async {
    // Don't poll if still on initial load or no messages yet
    if (state.isLoading) return;

    final repo = ref.read(chatRepositoryProvider);
    try {
      final latest = await repo.getMessages(
        conversationId: conversationId,
        page: 1,
      );

      if (latest.isEmpty) return;

      // Collect IDs we already have for fast deduplication
      final existingIds = state.messages.map((m) => m.id).toSet();

      // Filter to only genuinely new messages
      final newMessages = latest
          .where((m) => !existingIds.contains(m.id))
          .toList();

      if (newMessages.isEmpty) return;

      // Prepend new messages at the END of the list
      // (list is reversed — newest is at bottom/end)
      state = state.copyWith(
        messages: [...state.messages, ...newMessages.reversed],
      );
    } catch (_) {
      // Polling errors are silent — don't disrupt the UI
      // The user can still type and send
    }
  }

  // Load older messages — triggered when user scrolls to top
  Future<void> loadOlderMessages(String conversationId) async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    final repo = ref.read(chatRepositoryProvider);

    try {
      final nextPage = state.currentPage + 1;
      final older = await repo.getMessages(
        conversationId: conversationId,
        page: nextPage,
      );

      state = state.copyWith(
        // Prepend older messages at the START of the list (top)
        messages: [...older.reversed, ...state.messages],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: older.length >= 20,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoadingMore: false, sendError: e.message);
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, sendError: e.toString());
    }
  }

  // Send a message
  Future<void> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    state = state.copyWith(isSending: true, clearSendError: true);
    final repo = ref.read(chatRepositoryProvider);

    try {
      final message = await repo.sendMessage(
        conversationId: conversationId,
        text: text.trim(),
      );

      // Append sent message immediately — don't wait for next poll
      state = state.copyWith(
        messages: [...state.messages, message],
        isSending: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isSending: false, sendError: e.message);
    } catch (e) {
      state = state.copyWith(isSending: false, sendError: e.toString());
    }
  }

  void clearSendError() {
    state = state.copyWith(clearSendError: true);
  }
}

// Family provider — one ViewModel per conversationId
final chatViewModelProvider =
    NotifierProviderFamily<ChatViewModel, ChatState, String>(ChatViewModel.new);
