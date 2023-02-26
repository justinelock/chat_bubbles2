import 'dart:convert';

import 'meta_json.dart';

ConversationItem conversationItemFromJson(String str) =>
    ConversationItem.fromJson(json.decode(str));

String conversationItemToJson(ConversationItem data) =>
    json.encode(data.toJson());

class ConversationItem {
  ConversationItem({
    this.id,
    this.content,
    this.sent,
    this.metaJson,
    this.caption,
    this.delivered,
    this.seen,
    this.type,
  });

  ConversationItem.fromJson(dynamic json) {
    id = json['id'];
    content = json['content'];
    sent = json['sent'] ?? false;
    delivered = json['delivered'] ?? false;
    seen = json['seen'] ?? false;
    caption = json['caption'] ?? '';
    type = json['type'] ?? 0;
    String metaJsonStr = json['MetaJson'] ?? '';
    if (metaJsonStr.isNotEmpty) {
      metaJson = MetaJson.fromJson(metaJsonStr);
    }
  }

  int? id;
  int? type; // 0:msg 1:trans 14:file
  String? content;
  String? caption;
  MetaJson? metaJson;
  bool? sent;
  bool? delivered;
  bool? seen;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = content;
    map['sent'] = sent;
    map['delivered'] = delivered;
    map['seen'] = seen;
    map['type'] = type;
    map['metaJson'] = metaJson;
    return map;
  }
}
