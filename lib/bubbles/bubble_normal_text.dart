import 'package:chat_bubbles/models/conversation_item.dart';
import 'package:flutter/material.dart';

import 'bubble_comon.dart';

///basic chat bubble type
///
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
///[sent],[delivered] and [seen] can be used to display the message state
///chat bubble [TextStyle] can be customized using [textStyle]

class BubbleNormalText extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color backgroundColor;
  final ConversationItem node;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  static const double BUBBLE_RADIUS = 12;

  BubbleNormalText({
    Key? key,
    required this.node,
    this.bubbleRadius = BUBBLE_RADIUS,
    this.isSender = true,
    this.backgroundColor = Colors.transparent,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    // _buildContent(context, isImage, stateIcon, stateTick)
    List<Widget> widgets = [_buildContent(context, stateIcon, stateTick)];
    if (isSender) {
      widgets.add(buildAvatar(node.content!, backgroundColor));
    } else {
      widgets.insert(0, buildAvatar(node.content!, backgroundColor));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildExpanded(),

        ...widgets

      ],
    );
  }

  Widget _buildContent(BuildContext context, Icon? stateIcon, bool stateTick) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      //padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      color: Colors.transparent,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
      child: Container(
        decoration: _buildBoxDecoration(),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: stateTick
                  ? EdgeInsets.fromLTRB(12, 6, 28, 6)
                  : EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Text(
                node.content!,
                style: textStyle,
                textAlign: TextAlign.left,
              ),
            ),

            ///
            _buildDeliveredAndSeen(stateIcon, stateTick),
          ],
        ),
      ),
    );
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

  Widget _buildDeliveredAndSeen(Icon? stateIcon, bool stateTick) {
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
            ? isSender ? bubbleRadius : 0
            : BUBBLE_RADIUS),
        bottomRight: Radius.circular(tail
            ? isSender ? 0 : bubbleRadius
            : BUBBLE_RADIUS),
      ),
    );
  }
}
