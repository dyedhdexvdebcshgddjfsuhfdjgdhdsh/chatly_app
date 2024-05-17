
class GroupChatRoomModel {
  final String? id;
  final String? name;
  final String? image;
  final List? admin;
  final List? members;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? createdAt;

  GroupChatRoomModel(
      {required this.name,
      required this.image,
      required this.admin,
      required this.id,
      required this.members,
      required this.lastMessage,
      required this.lastMessageTime,
      required this.createdAt});

  factory GroupChatRoomModel.fromJson(Map<String, dynamic> json) {
    return GroupChatRoomModel(
        id: json['id'],
        members: json["members"] ?? [],
        lastMessage: json['last_message'] ?? "",
        lastMessageTime: json['last_message_time'] ?? "",
        createdAt: json['created_at'] ?? "",
        name:json['name']??"",
        image:json['image']??"",
        admin:json['admin']??[]);
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
