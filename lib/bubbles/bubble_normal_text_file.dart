import 'package:chat_bubbles/models/conversation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class BubbleNormalTextFile extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );
  static const double BUBBLE_RADIUS = 12;

  BubbleNormalTextFile({
    Key? key,
    required this.node,
    this.bubbleRadius = BUBBLE_RADIUS,
    this.isSender = true,
    this.backgroundColor = Colors.transparent,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.text,
    this.onTap,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  }) : super(key: key);

  final ConversationItem node;
  final double bubbleRadius;
  final bool isSender;
  final Color backgroundColor;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final void Function()? onTap;
  final String? text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    bool isImage = node.metaJson!.type!.toLowerCase().contains('image');
    print('###### node.metaJson!.type!: ${node.metaJson!.type!}');

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

    List<Widget> widgets = [_buildContent(context, isImage, stateIcon, stateTick)];
    if (isSender) {
      widgets.add(buildAvatar(node.metaJson!.name!, backgroundColor));
    } else {
      widgets.insert(0, buildAvatar(node.metaJson!.name!, backgroundColor));
    }

    return Row(
      mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: widgets,
      // children: <Widget>[
      //
      //   if(!isSender)_buildAvatar(),
      //
      //   /// 内容
      //   _buildContent(context, isImage, stateIcon, stateTick),
      //
      //   if(isSender)_buildAvatar(),
      // ],
    );
  }

  Widget _buildContent(BuildContext context, bool isImage, Icon? stateIcon, bool stateTick) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      padding: const EdgeInsets.all(8),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .75,
        //maxHeight: MediaQuery.of(context).size.width * .75,
      ),
      decoration: _buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: Hero(
                  tag: node.metaJson!.name!,
                  child: Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: ClipRRect(
                      borderRadius: _buildBorderRadius(),
                      child: isImage
                          ? buildImage(
                              node.metaJson!.url!,
                              boxConstraints: BoxConstraints(
                                maxHeight: 60.0,
                                maxWidth: 60.0,
                              ),
                            )
                          : SvgPicture.asset(
                              getAssets(node.metaJson!.type!.toLowerCase().contains('pdf')),
                              width: 48,
                              height: 48,
                            ),
                    ),
                  ),
                ),
                onTap: onTap ??
                    () {
                      print('onTap');
                    },
              ),
              SizedBox(width: 6),

              /// 文件名 size
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// name
                    Text(
                      '${node.metaJson!.name!}',
                      style: textStyle,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    /// size
                    Text(
                      '${(node.metaJson!.size! / 1024.0).toStringAsFixed(2)}KB',
                      style: textStyle,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// 如有，显示文本
          _buildShowText(context, stateIcon, stateTick),
        ],
      ),
    );
  }

  /// 文本内容
  Widget _buildShowText(BuildContext context, Icon? stateIcon, bool stateTick) {
    bool showText = text != null && text != '';
    return showText
        ? Container(
            color: Colors.transparent,
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * .8,
            ),
            child: Container(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: stateTick
                        ? EdgeInsets.fromLTRB(0, 6, 6, 6)
                        : EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                    child: Text(
                      text!,
                      style: textStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),

                  ///
                  _buildDeliveredAndSeen(stateIcon, stateTick),
                ],
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

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(bubbleRadius),
        topRight: Radius.circular(bubbleRadius),
        bottomLeft: Radius.circular(isSender ? bubbleRadius : 0),
        bottomRight: Radius.circular(isSender ? 0 : bubbleRadius),
      ),
    );
  }

  BorderRadius _buildBorderRadius({double radius = BUBBLE_RADIUS}) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

// BoxDecoration _buildTextBoxDecoration() {
//   return BoxDecoration(
//     color: backgroundColor,
//     borderRadius: BorderRadius.only(
//       topLeft: Radius.circular(0),
//       topRight: Radius.circular(0),
//       bottomLeft: Radius.circular(tail
//           ? isSender
//           ? bubbleRadius
//           : 0
//           : BUBBLE_RADIUS),
//       bottomRight: Radius.circular(tail
//           ? isSender
//           ? 0
//           : bubbleRadius
//           : BUBBLE_RADIUS),
//     ),
//   );
// }
}
