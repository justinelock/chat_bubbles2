import 'dart:convert';

KeyValue kvFromJson(String str) => KeyValue.fromJson(json.decode(str));

String kvToJson(KeyValue data) => json.encode(data.toJson());

class KeyValue<K, V> {
  KeyValue({
    this.key,
    this.value,
  });

  KeyValue.fromJson(dynamic json) {
    key = json['key'];
    value = json['value'];
  }

  K? key;
  V? value;

  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['key'] = key;
    map['value'] = value;
    return map;
  }
}
