import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/constants/ultils.dart';
import 'package:shop_proh/providers/user_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shop_proh/constants/globalvariable.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages =
      []; // Thay đổi kiểu dữ liệu của messages

  String userName = '';
  @override
  void initState() {
    super.initState();
    socket = IO.io(
      uri,
      <String, dynamic>{
        'transports': ['websocket'],
      },
    );
    socket.connect();
    socket.emit('CLIENT_SEND_USERNAME', {
      'name': Provider.of<UserProvider>(context, listen: false).user.name,
    });
    userName = Provider.of<UserProvider>(context, listen: false).user.name;
    socket.on('SERVER_SEND_MESSAGE', _handleServerMessage);
  }

  void _handleServerMessage(dynamic data) {
    print(data);
    setState(() {
      messages.insert(0, data); // Thêm tin nhắn mới vào đầu danh sách
    });
  }

  Widget _buildSenderAvatar(String senderName) {
    String firstLetter = senderName.substring(0, 1).toUpperCase();
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.primaries[senderName.length % Colors.primaries.length],
      ),
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Chat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final reversedIndex = messages.length - 1 - index;
                final message = messages[reversedIndex];
                final from = message['from']['name'];
                final messageContent = message['message']['message'];
                final isFromCurrentUser = from == userName;

                final time = message['time']['time'];

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: isFromCurrentUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      isFromCurrentUser
                          ? SizedBox() // Nếu là tin nhắn của người dùng hiện tại, không cần hiển thị vòng tròn ở bên trái
                          : _buildSenderAvatar(
                              from), // Ngược lại, hiển thị vòng tròn ở bên trái
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: isFromCurrentUser
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isFromCurrentUser ? 'Me' : from,
                              style: TextStyle(
                                color: isFromCurrentUser
                                    ? Colors.blue
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              messageContent,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      isFromCurrentUser
                          ? _buildSenderAvatar(
                              from) // Nếu là tin nhắn của người dùng hiện tại, hiển thị vòng tròn ở bên phải
                          : SizedBox(), // Ngược lại, không cần hiển thị vòng tròn ở bên phải
                      SizedBox(width: 8),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: 'Nhập tin nhắn'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Gửi tin nhắn đến server
                    socket.emit('CLIENT_SEND_MESSAGE', {
                      'message': messageController.text,
                    });
                    // Xóa nội dung tin nhắn từ ô nhập liệu
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
