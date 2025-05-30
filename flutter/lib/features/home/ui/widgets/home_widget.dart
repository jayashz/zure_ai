import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zure_ai/core/bloc/socket_state.dart';
import 'package:zure_ai/core/services/database_services.dart';
import 'package:zure_ai/features/auth/repository/auth_repository.dart';
import 'package:zure_ai/features/home/cubit/socket_cubit.dart';
import 'package:zure_ai/features/home/models/message.dart';
import 'package:zure_ai/features/home/repository/socket_repository.dart';
import 'package:zure_ai/features/splash/ui/pages/splash_page.dart';
import '../../../../core/theme/app_theme.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final DatabaseServices databaseServices = DatabaseServices();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> messages = [];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmit(String text) {
    if (_controller.text.isNotEmpty) {
      context.read<SocketCubit>().sendMessage(text);
      _controller.clear();
    }

    _controller.clear();

    // Scroll to bottom after message is added
  }

  void _scroller() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(Message message, ThemeData theme) {
    final isUser = message.isUser;
    final bgColor =
        isUser ? Colors.transparent : AppTheme.secondaryBackgroundColor;
    final avatarColor = isUser ? AppTheme.textColor : AppTheme.primaryColor;
    final icon = isUser ? Icons.person : Icons.smart_toy;
    final iconColor = isUser ? AppTheme.backgroundColor : AppTheme.textColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:
                    isUser
                        ? [
                          // Message first, avatar on right
                          Flexible(
                            child: Text(
                              message.text,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            backgroundColor: avatarColor,
                            radius: 16,
                            child: Icon(icon, color: iconColor, size: 18),
                          ),
                        ]
                        : [
                          // Avatar first, message after
                          CircleAvatar(
                            backgroundColor: avatarColor,
                            radius: 16,
                            child: Icon(icon, color: iconColor, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              message.text,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textColor,
                              ),
                            ),
                          ),
                        ],
              ),
            ),
          ),
          Text(
            message.dateTime,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textLightColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'AI Assistant',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                context.read<AuthRepository>().logout();
                if (!context.mounted) {
                  return;
                }
                context.read<SocketRepository>().disconnect();
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const SplashPage(),
                  ),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<SocketCubit, SocketState>(
                  listenWhen: (previous, current) => current is! SocketInitial,

                  listener: (context, state) {
                    if (state is MessagesLoaded) {
                      messages.addAll(state.messages);
                      _scroller();
                    } else if (state is NewMessageReceived) {
                      messages.add(state.message);
                      _scroller();
                    }
                  },
                  builder: (context, state) {
                    if (state is SocketConnecting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder:
                          (context, index) =>
                              _buildMessageBubble(messages[index], theme),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.inputBackgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.secondaryBackgroundColor,
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Send a message...',
                          hintStyle: TextStyle(color: AppTheme.textLightColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.primaryColor,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: AppTheme.backgroundColor,
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: _handleSubmit,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () => _handleSubmit(_controller.text),
                      icon: const Icon(Icons.send_rounded),
                      color: AppTheme.primaryColor,
                      tooltip: 'Send message',
                      iconSize: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
