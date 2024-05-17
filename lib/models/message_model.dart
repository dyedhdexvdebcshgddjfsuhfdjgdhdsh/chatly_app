import 'dart:convert';

class MessageModel {
  final String? id;
  final String? fromId;
  final String? toId;
  final String? message;
  final String? createdAt;
  final String? type;
  final String? read;

  MessageModel({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.message,
    required this.createdAt,
    required this.type,
    required this.read,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        id: json['id'],
        fromId: json["from_id"] ?? "",
        toId: json['to_id'] ?? "",
        message: json['message'] ?? "",
        createdAt: json['created_at'] ?? "",
        type: json['type'],
        read: json['read']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_id': fromId,
      'to_id': toId,
      'message': message,
      'created_at': createdAt,
      'read': read,
      'type': type,
    };
  }
}
