import 'package:flutter/material.dart';
import 'package:zure_ai/features/home/models/message.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late io.Socket socket;
  List<Message> messages = [];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    initSocket();
    super.initState();
  }
  void initSocket() {
    try {
      socket = io.io('http://192.168.1.11:3000', <String, dynamic>{
        'transports': ['websocket'],
        'auth': {
          'token':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjEyMzQ1Njc4OTAiLCJwYXNzd29yZCI6IkpvaG4gRG9lIn0.NJDQysvZFpi1_VhnTP-TqVVHzyMYPcdew-4kgo7thXc',
        },
      });

      socket.connect();

      socket.onConnect((_) {
        print('✅ Connected to server');
      });

      socket.onConnectError((data) => print("❌ Connect error: $data"));
      socket.onError((data) => print("❌ General error: $data"));

      socket.on("previousMessages", (data) {
        setState(() {
          final mess = data.map<Message>((e) => Message.fromJson(e)).toList();
          messages.addAll(mess);
        });
        _scroller();
      });

      socket.on('ai_message', (data) {
        setState(() {
          messages.add(Message.fromJson(data));
        });
        _scroller();
        print("🤖 Message received: $data");
      });

      socket.on('user', (data) {
        setState(() {
          messages.add(Message.fromJson(data));
        });
        _scroller();
      });

      socket.onDisconnect((_) => print('⚠️ Socket disconnected!'));
    } catch (e) {
      print("🔥 Error connecting to socket: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    socket.dispose();
    super.dispose();
  }

  void _handleSubmit(String text) {
    if (_controller.text.isNotEmpty) {
      socket.emit('user', _controller.text);
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
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder:
                      (context, index) =>
                          _buildMessageBubble(messages[index], theme),
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
