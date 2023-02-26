class MetaJson {
  MetaJson({
    this.name,
    this.url,
    this.type,
    this.size,
    this.msgType,
  });

  MetaJson.fromJson(dynamic json) {
    name = json['name'] ?? '';
    url = json['url'] != null && json['url'] != 'null' ? json['url'] : '';
    type = json['type'] ?? '';
    size = json['size'] ?? 0;
    msgType = json['msgType'] ?? -1;
  }

  String? name;
  String? url;
  String? type;
  int? size;
  int? msgType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['url'] = url;
    map['type'] = type;
    map['size'] = size;
    map['msgType'] = msgType;
    return map;
  }
}
