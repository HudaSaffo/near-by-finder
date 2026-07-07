import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'signup.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const Color bgColor = Color(0xFFF9F5EB);
  static const Color darkBrown = Color(0xFF1A0101);
  static const Color mainRed = Color(0xFF5D1219);
  static const Color lightGrey = Color(0xffD0D0D0);

  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final currId = supabase.auth.currentUser!.id;
    final data = await supabase
        .from("notifications")
        .select()
        .eq("user_id", currId)
        .order("created_at", ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> markAsRead() async {
    final currId = supabase.auth.currentUser!.id;
    await supabase
        .from("notifications")
        .update({'is_read': true})
        .eq("user_id", currId)
        .eq('is_read', false);
  }

  @override
  void initState() {
    super.initState();
    markAsRead();
  }

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
          'Notification',
          style: TextStyle(color: darkBrown, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 55),

              _notificationCard(
                title: v=="Customer"?'Check out "Service name"!':'Check out "Customer name"!',
                subtitle: "Description",
                isActive: false,
                isUnread: false,
              ),

              const SizedBox(height: 12),

              _notificationCard(
                title:  v=="Customer"?'Check out "Service name"!':'Check out "Customer name"!',
                subtitle: "Description",
                isActive: false,
                isUnread: false,
              ),

              const SizedBox(height: 12),

              _notificationCard(
                title:  v=="Customer"?'Check out "Service name"!':'Check out "Customer name"!',
                subtitle: "Description",
                isActive: false,
                isUnread: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationCard({
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isUnread,
  }) {
    return Container(
      height: 115,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              color: lightGrey,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isActive ? darkBrown : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.grey : Colors.grey.shade400,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}