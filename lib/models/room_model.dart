import 'dart:convert';

class ChatRoomModel {
 final String? id;
 final List? members;
 final String? lastMessage;
  final String? lastMessageTime;
  final String? createdAt;

  ChatRoomModel(
      {required this.id,
      required this.members,
      required this.lastMessage,
      required this.lastMessageTime,
      required this.createdAt});

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
        id: json['id'],
        members: json["members"] ?? "",
        lastMessage: json['last_message'] ?? "",
        lastMessageTime: json['last_message_time'] ?? "",
        createdAt: json['created_at'] ?? "");
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'members': members,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'created_at': createdAt
    };
  }
}
