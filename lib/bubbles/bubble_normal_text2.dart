import 'package:chat_bubbles/models/conversation_item.dart';
import 'package:flutter/material.dart';

import 'bubble_comon.dart';
import 'key_value.dart';

class BubbleNormalText2 extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color backgroundColor;
  final ConversationItem node;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final bool hasImage;
  static const double BUBBLE_RADIUS = 12;

  BubbleNormalText2({
    Key? key,
    required this.node,
    this.bubbleRadius = BUBBLE_RADIUS,
    this.isSender = true,
    this.backgroundColor = Colors.transparent,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.hasImage = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.75 - 60;

    KeyValue<bool, Widget> kv = buildIconState(sent: false, delivered: false);

    List<Widget> widgets = [_buildContent(context, maxWidth, kv.value, kv.key!)];
    if (isSender) {
      widgets.add(buildAvatar(node.content!, backgroundColor));
      //widgets.add(_buildAvatar(context));
    } else {
      widgets.insert(0, buildAvatar(node.content!, backgroundColor));
      //widgets.insert(0, _buildAvatar(context));
    }

    return Row(
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
      child: CircleAvatar(
        radius: 24.0,
        backgroundColor: isSender ? Colors.grey[200] : Colors.blue[200],
        child: Icon(
          isSender ? Icons.person : Icons.account_circle,
          color: isSender ? Colors.grey[600] : Colors.blue[600],
          size: 32.0,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double maxWidth, Widget? stateIcon, bool stateTick) {
    return
      Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        //margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSender ? Colors.blue : Colors.grey,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                if (hasImage)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        node.caption!,
                        width: maxWidth,
                        height: maxWidth,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),

                ///
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: <Widget>[
                        // Padding(
                        //   padding: stateTick
                        //       ? EdgeInsets.fromLTRB(12, 6, 28, 6)
                        //       : EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        //   child: Text(
                        //     node.content!,
                        //     style: textStyle,
                        //     textAlign: TextAlign.left,
                        //   ),
                        // ),
                        Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              Text(
                                node.content!,
                              ),
                            ],
                          ),
                        ),
                        ///
                        _buildDeliveredAndSeen(stateIcon, stateTick),
                      ],
                    ),
                    // Container(
                    //   constraints: BoxConstraints(maxWidth: maxWidth),
                    //   child: Wrap(
                    //     alignment: WrapAlignment.start,
                    //     children: [
                    //       Text(
                    //         node.content!,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    //   Container(
    //   margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
    //   //padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    //   color: Colors.transparent,
    //   constraints:
    //       BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
    //   child: Container(
    //     decoration: _buildBoxDecoration(),
    //     child: Stack(
    //       children: <Widget>[
    //         Padding(
    //           padding: stateTick
    //               ? EdgeInsets.fromLTRB(12, 6, 28, 6)
    //               : EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    //           child: Text(
    //             node.content!,
    //             style: textStyle,
    //             textAlign: TextAlign.left,
    //           ),
    //         ),
    //
    //         ///
    //         _buildDeliveredAndSeen(stateIcon, stateTick),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildExpanded() {
    return isSender
        ? Expanded(
            child: SizedBox(
              width: 5,
            ),
          )
        : Container();
  }

  Widget _buildDeliveredAndSeen(Widget? stateIcon, bool stateTick) {
    return stateIcon != null && stateTick
        ? Positioned(
            bottom: 4,
            right: 6,
            child: stateIcon,
          )
        : SizedBox(
            width: 1,
          );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(bubbleRadius),
        topRight: Radius.circular(bubbleRadius),
        bottomLeft: Radius.circular(tail
            ? isSender
                ? bubbleRadius
                : 0
            : BUBBLE_RADIUS),
        bottomRight: Radius.circular(tail
            ? isSender
                ? 0
                : bubbleRadius
            : BUBBLE_RADIUS),
      ),
    );
  }
}
