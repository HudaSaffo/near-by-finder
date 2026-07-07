import 'package:flutter/material.dart';
import 'package:flutter_nearfix/customernavbar.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const CustomerChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  static const Color bgColor = Color(0xFFF9F5EB);
  static const Color darkBrown = Color(0xFF1A0101);
  static const Color mainRed = Color(0xFF5D1219);
  static const Color lightGrey = Color(0xffD0D0D0);

  final supabase = Supabase.instance.client;
  final TextEditingController c = TextEditingController();
  late final String currId;
  String currCustomerName="";

  Future<void> getCurrCustomerName() async {
    final data = await supabase
        .from('customers')
        .select('full_name')
        .eq('id', currId)
        .single();
    currCustomerName = data['full_name'];
  }

  @override
  void initState() {
    super.initState();
    currId = supabase.auth.currentUser!.id;
    getCurrCustomerName();
  }

  Future<void> sendMessage() async {
    final text = c.text.trim();
    if (text.isEmpty) return;
    await supabase.from('messages').insert({
      'sender_id': currId,
      'receiver_id': widget.receiverId,
      'message': text,
    });
    await supabase.from('notifications').insert({
      'user_id': widget.receiverId,
      'title': 'New Message',
      'description': 'You received a new message',
      'target_id': currId,
      'target_name': currCustomerName,
      'target_type': 'customer',
      'notification_type':'message',
      'is_read': false
    });
    c.clear();
  }

  Stream<List<Map<String, dynamic>>> getMessage() {
    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) {
      return data.where((message) {
        return (message['sender_id'] == currId &&
            message['receiver_id'] == widget.receiverId) ||
            (message['sender_id'] == widget.receiverId &&
                message['receiver_id'] == currId);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        actions: [
          SvgPicture.asset('assets/images/logo.svg', width: 35),
          SizedBox(width: 20),
        ],
        backgroundColor: bgColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 30, color: darkBrown),
        ),
        title: Text(
          widget.receiverName,
          style: TextStyle(color: darkBrown, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getMessage(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(15),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['sender_id'] == currId;
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(15),
                        constraints: const BoxConstraints(maxWidth: 200),
                        decoration: BoxDecoration(
                          color: isMe ? lightGrey : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          message['message'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Input
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: c,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                CircleAvatar(
                  radius: 28,
                  backgroundColor: mainRed,
                  child: IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}