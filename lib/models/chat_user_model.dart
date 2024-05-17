class ChatUserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? about;
  final String? image;
  final String? createdAt;
  final String? lastActivated;
   final String? pushToken;
  final bool online;
  final List? myUsers;
  ChatUserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.about,
      required this.image,
      required this.createdAt,
      required this.lastActivated,
      required this.pushToken,
      required this.online ,
      required this.myUsers
      });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id']??"",
      name: json['name']??"",
      email: json['email']??"",
      about: json['about']??"",
      image: json['image']??"",
      createdAt:json['created_at']??"",
      lastActivated: json['last_activated']??"",
      pushToken: json['push_token']??"",
      online: json['online']??false,
      myUsers: json['my_users']??[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'about': about,
      'image': image,
      'created_at': createdAt,
      'last_activated': lastActivated,
      'push_token': pushToken,
      'online': online ,
      'my_users':myUsers
    };
  }
}
