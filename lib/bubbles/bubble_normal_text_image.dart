import 'package:chat_bubbles/models/conversation_item.dart';
import 'package:flutter/material.dart';

import 'bubble_comon.dart';

///basic image bubble type
///
///
/// image bubble should have [id] to work with Hero animations
/// [id] must be a unique value
///chat bubble [BorderRadius] can be customized using [bubbleRadius]
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display image can be changed using [image]
///[image] is a required parameter
///[id] must be an unique value for each other
///[id] is also a required parameter
///message sender can be changed using [isSender]
///[sent],[delivered] and [seen] can be used to display the message state

class BubbleNormalTextImage extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );
  static const double BUBBLE_RADIUS = 12;

  BubbleNormalTextImage({
    Key? key,
    required this.id,
    required this.node,
    this.bubbleRadius = BUBBLE_RADIUS,
    this.isSender = true,
    this.backgroundColor = Colors.transparent,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onTap,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  }) : super(key: key);

  final String id;
  final ConversationItem node;
  final double bubbleRadius;
  final bool isSender;
  final Color backgroundColor;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final void Function()? onTap;
  final TextStyle textStyle;

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

    List<Widget> widgets = [_buildContent(context, stateIcon, stateTick)];
    if (isSender) {
      widgets.add(buildAvatar(node.id.toString(), backgroundColor));
    } else {
      widgets.insert(0, buildAvatar(node.id.toString(), backgroundColor));
    }

    return Row(
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: widgets,
    );
  }

  Widget _buildContent(BuildContext context, Icon? stateIcon, bool stateTick) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      //padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .75,
        //maxHeight: MediaQuery.of(context).size.width * .75,
      ),
      child: GestureDetector(
        child: Hero(
          tag: id,
          child: Column(
            children: [
              ///
              Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * .75,
                  //maxHeight: MediaQuery.of(context).size.width * .75,
                ),
                decoration: _buildImageBoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(0.5),
                  child: ClipRRect(
                    borderRadius: _buildBorderRadius(),
                    child: buildImage(node.caption ?? ''),
                  ),
                ),
              ),

              /// 如有，显示文本
              _buildShowText(context, stateIcon, stateTick),
            ],
          ),
        ),
        onTap: onTap ??
                () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return _DetailScreen(
                  tag: id,
                  image: buildImage(node.caption ?? ''),
                );
              }));
            },
      ),
    );
  }

  /// 文本内容
  Widget _buildShowText(BuildContext context, Icon? stateIcon, bool stateTick) {
    bool showText = node.content != null && node.content != '';
    return showText
        ? Container(
            color: Colors.transparent,
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * .75,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: Container(
                decoration: _buildTextBoxDecoration(),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: stateTick
                          ? EdgeInsets.fromLTRB(12, 6, 28, 6)
                          : EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
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
            ),
          )
        : SizedBox.shrink();
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

  double _buildImageBottomLeft() {
    bool showText = node.content != null && node.content != '';
    return tail
        ? isSender
            ? showText ? 0 : bubbleRadius
            : showText ? 0 : bubbleRadius
        : BUBBLE_RADIUS;
  }

  double _buildImageBottomRight() {
    bool showText = node.content != null && node.content != '';
    return tail
        ? isSender
            ? showText ? 0 : bubbleRadius
            : showText ? 0 : bubbleRadius
        : BUBBLE_RADIUS;
  }

  BorderRadius _buildBorderRadius() {
    return BorderRadius.only(
      topLeft: Radius.circular(bubbleRadius),
      topRight: Radius.circular(bubbleRadius),
      bottomLeft: Radius.circular(_buildImageBottomLeft()),
      bottomRight: Radius.circular(_buildImageBottomRight()),
    );
  }

  BoxDecoration _buildImageBoxDecoration() {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(bubbleRadius),
        topRight: Radius.circular(bubbleRadius),
        bottomLeft: Radius.circular(_buildImageBottomLeft()),
        bottomRight: Radius.circular(_buildImageBottomRight()),
      ),
    );
  }

  BoxDecoration _buildTextBoxDecoration() {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
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

/// detail screen of the image, display when tap on the image bubble
class _DetailScreen extends StatefulWidget {
  final String tag;
  final Widget image;

  const _DetailScreen({Key? key, required this.tag, required this.image})
      : super(key: key);

  @override
  DetailScreenState createState() => DetailScreenState();
}

/// created using the Hero Widget
class DetailScreenState extends State<_DetailScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: widget.image,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
