import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: unused_import
import '../../../../models/message.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Listen for scroll reaching top — load older messages
    _scrollController.addListener(() {
      if (_scrollController.offset <=
          _scrollController.position.minScrollExtent + 80) {
        ref
            .read(chatViewModelProvider(widget.conversationId).notifier)
            .loadOlderMessages(widget.conversationId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Note: polling timer is cancelled automatically via ref.onDispose
    // inside ChatViewModel — no manual cleanup needed here
    super.dispose();
  }

  // Scroll to bottom — called after sending a message
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatViewModelProvider(widget.conversationId));
    final authState = ref.watch(authViewModelProvider).value;
    final currentUserId = authState?.user?.id ?? '';

    // Scroll to bottom when new messages arrive
    ref.listen<ChatState>(chatViewModelProvider(widget.conversationId), (
      prev,
      next,
    ) {
      // Only scroll if messages were added at the bottom
      // (new send or poll) — not when loading older at top
      if (prev != null &&
          next.messages.length > prev.messages.length &&
          !next.isLoadingMore) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0F8),
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: Column(
        children: [
          // Load older messages indicator at top
          if (chatState.isLoadingMore)
            Container(
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ),

          // Message list
          Expanded(
            child: chatState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
                  )
                : chatState.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Say hello!',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatState.messages[index];
                      final isMine = message.senderId == currentUserId;

                      // Show timestamp on last message of each
                      // consecutive group from the same sender
                      final isLast =
                          index == chatState.messages.length - 1 ||
                          chatState.messages[index + 1].senderId !=
                              message.senderId;

                      return MessageBubble(
                        message: message,
                        isMine: isMine,
                        showTime: isLast,
                      );
                    },
                  ),
          ),

          // Send error
          if (chatState.sendError != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      chatState.sendError!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref
                        .read(
                          chatViewModelProvider(widget.conversationId).notifier,
                        )
                        .clearSendError(),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
              ),
            ),

          // Input bar — pinned to bottom
          ChatInput(
            isSending: chatState.isSending,
            isDisabled: false, // wire to conversation.isActive in Phase polish
            onSend: (text) {
              ref
                  .read(chatViewModelProvider(widget.conversationId).notifier)
                  .sendMessage(
                    conversationId: widget.conversationId,
                    text: text,
                  );
            },
          ),
        ],
      ),
    );
  }
}
