class MessageModel {
  MessageModel({
    required this.read,
    required this.toId,
    required this.type,
    required this.msg,
    required this.sent,
    required this.fromId,
  });
  late final String read;
  late final String toId;
  late final Type type;
  late final String msg;
  late final String sent;
  late final String fromId;

  MessageModel.fromJson(Map<String, dynamic> json) {
    read = json['read'].toString();
    toId = json['toId'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    msg = json['msg'].toString();
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['read'] = read;
    data['toId'] = toId;
    data['type'] = type.name;
    data['msg'] = msg;
    data['sent'] = sent;
    data['fromId'] = fromId;
    return data;
  }
}

enum Type { text, image }
