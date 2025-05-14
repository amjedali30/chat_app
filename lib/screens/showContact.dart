import 'package:chat_app/screens/messageScreen.dart';
import 'package:flutter/material.dart';
import '../services/apiService.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({Key? key}) : super(key: key);

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  bool _isLoading = false;
  String _errorMessage = '';
  List contacts = [];

  @override
  void initState() {
    super.initState();
    _loadChatProfiles();
  }

  Future _loadChatProfiles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      contacts = await ApiService.getChatProfiles();
    } catch (e) {
      _errorMessage = 'Failed to load contacts: $e';

      contacts = [
        {
          "name": "Arjun",
          "profile_photo_url":
              "https://fliq-test-bucket.s3.ap-south-1.amazonaws.com/10/conversions/gYlvYiE8ZeK2ZawVmcvL4oWkzion23fnhz44440s-square300.jpg",
          "is_online": true,
          "message_received_from_partner_at": "10:00 AM"
        },
        {
          "name": "Rhonda Rivera",
          "profile_photo_url":
              "https://randomuser.me/api/portraits/women/7.jpg",
          "is_online": false,
          "message_received_from_partner_at": "10:00 AM"
        },
      ];
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black54),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D0C0C),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return StoryItem(user: contacts[index]);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Icon(Icons.search, color: Colors.grey.shade400),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                'Chat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty && contacts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error loading contacts',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(_errorMessage, textAlign: TextAlign.center),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadChatProfiles,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadChatProfiles,
                          child: ListView.builder(
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              return ChatItem(user: contacts[index]);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  final Map<String, dynamic> user;

  const StoryItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user["profile_photo_url"]),
              ),
              if (user["is_online"])
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          user["name"],
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ChatItem extends StatelessWidget {
  final Map<String, dynamic> user;

  const ChatItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = user["name"] ?? "Unknown";
    final avatar = user["profile_photo_url"] ?? "";
    final time = user["message_received_from_partner_at"];
    final isOnline = user["is_online"] == true;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(avatar),
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: time != null
          ? Text(
              time,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: time != null
          ? Text(
              time,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            )
          : null,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                    custName: name, prImage: avatar, online: isOnline)));
      },
    );
  }
}
