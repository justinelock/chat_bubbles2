import 'dart:convert';
import 'dart:math';

import 'package:chat_bubbles/models/conversation_item.dart';
import 'package:chat_bubbles/models/meta_json.dart';
import 'package:flutter/material.dart';

///Normal Message bar with more actions
///
/// following attributes can be modified
///
///
/// # BOOLEANS
/// [replying] is additional reply widget top of the message bar
///
/// # STRINGS
/// [replyingTo] is a string to tag the replying message
///
/// # WIDGETS
/// [actions] are the additional leading action buttons like camera
/// and file select
///
/// # COLORS
/// [replyWidgetColor] is reply widget color
/// [replyIconColor] is the reply icon color on the left side of reply widget
/// [replyCloseColor] is the close icon color on the right side of the reply
/// widget
/// [messageBarColor] is the color of the message bar
/// [sendButtonColor] is the color of the send button
///
/// # METHODS
/// [onTextChanged] is function which triggers after text every text change
/// [onSend] is send button action
/// [onTapCloseReply] is close button action of the close button on the
/// reply widget usually change [replying] attribute to `false`

class MessageBar extends StatelessWidget {
  final bool replying;
  final String replyingTo;
  final List<Widget> actions;
  final TextEditingController _textController = TextEditingController();
  final Color replyWidgetColor;
  final Color replyIconColor;
  final Color replyCloseColor;
  final Color messageBarColor;
  final Color sendButtonColor;
  final void Function(String)? onTextChanged;
  final void Function(ConversationItem)? onSend;
  final void Function()? onTapCloseReply;

  /// [MessageBar] constructor
  MessageBar({
    this.replying = false,
    this.replyingTo = "",
    this.actions = const [],
    this.replyWidgetColor = const Color(0xffF4F4F5),
    this.replyIconColor = Colors.blue,
    this.replyCloseColor = Colors.black12,
    this.messageBarColor = const Color(0xffF4F4F5),
    this.sendButtonColor = Colors.blue,
    this.onTextChanged,
    this.onSend,
    this.onTapCloseReply,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// reply
            ..._buildReplying(),

            ///
            Container(
              color: messageBarColor,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              child: Row(
                children: <Widget>[
                  //...actions,
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 5,
                        onChanged: onTextChanged,
                        decoration: InputDecoration(
                          hintText: "Type your message here",
                          hintMaxLines: 1,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          hintStyle: TextStyle(
                            fontSize: 16,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 0.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                              width: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: InkWell(
                      child: Icon(
                        Icons.send,
                        color: sendButtonColor,
                        size: 24,
                      ),
                      onTap: () {
                        /// test
                        if (_textController.text.trim() != '') {
                          if (onSend != null) {
                            String metaJson = "{\"name\":\"640px-Flag_of_the_United_States_(1777-1795).svg.png\",\"url\":\"https://bafkreifhhi2qrfsqon3h7wvguif4b34ri534cled7qrzxgxkdjwg64mrke.ipfs.w3s.link\",\"type\":\"image/png\",\"size\":11095,\"msgType\":2}";
                            if (Random().nextInt(2) == 0) {
                              metaJson = "{\"name\":\"2023217_HPAY.pdf\",\"url\":\"https://bafkreiexoftbloevzqpzdm46mxlcvhng67qbu4egglfqcpdiy6i4p32vx4.ipfs.w3s.link\",\"type\":\"application/pdf\",\"size\":825755,\"msgType\":2}";
                            }
                            ConversationItem item = ConversationItem();
                            item.id = Random().nextInt(100000);
                            item.content = _textController.text.trim();
                            item.type = Random().nextInt(4);
                            item.type = 14; // 0, 1, 14
                            item.caption = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4QfiqWdPfgQz0GpSUoOzAQGnak0wQDahqdQ&usqp=CAU';
                            item.caption = 'https://camo.githubusercontent.com/bc4e646b3f99b4782ade21a9a2352b1af20544f8e51f0daed7c4ef980ec9a388/68747470733a2f2f646c2e64726f70626f7875736572636f6e74656e742e636f6d2f732f7435786667616832676768717477732f696f732d73657475702d7065726d69747465642d6964656e746966696572732e706e673f646c3d31';
                            item.metaJson = MetaJson.fromJson(json.decode(metaJson));
                            onSend!(item);
                          }
                          _textController.text = '';
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReplying() {
    return [
      replying
          ? Container(
              color: replyWidgetColor,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.reply,
                    color: replyIconColor,
                    size: 24,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Re : ' + replyingTo,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTapCloseReply,
                    child: Icon(
                      Icons.close,
                      color: replyCloseColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
      replying
          ? Container(
              height: 1,
              color: Colors.grey.shade300,
            )
          : SizedBox.shrink(),
    ];
  }
}
