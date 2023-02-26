import 'package:flutter/material.dart';
import "package:cached_network_image/cached_network_image.dart";

String getAssets(isPdf) {
  if (isPdf) {
    return 'assets/icon_pdf_color.svg';
  }
  return 'assets/icon_unknown_file.svg';
}

Widget buildAvatar(String tag, Color backgroundColor, {Function()? onTap}) {
  return Container(
    margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
    decoration: BoxDecoration(
      border: Border.all(color: backgroundColor, width: 0.5),
      borderRadius: BorderRadius.circular(50),
    ),
    child: GestureDetector(
      child: Hero(
        tag: tag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: buildImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4QfiqWdPfgQz0GpSUoOzAQGnak0wQDahqdQ&usqp=CAU',
            boxConstraints: BoxConstraints(
              maxHeight: 40.0,
              maxWidth: 40.0,
            ),
            width: 40,
            height: 40,
          ),
        ),
      ),
      onTap: onTap ??
              () {
            print('onTap');
          },
    ),
  );
}

///BoxConstraints(maxHeight: 48.0, maxWidth: 48.0)
Widget buildImage(String url, {double? width, double? height, BoxConstraints? boxConstraints}) {
  if (url == null || url == '') {
    return SizedBox.shrink();
  }
  return Container(
    constraints: boxConstraints ??
        BoxConstraints(
          minHeight: 48.0,
          minWidth: 48.0,
        ),
    child: _buildCachedNetworkImage(url, width: width, height: height),
  );
}

CachedNetworkImage _buildCachedNetworkImage(String url,
    {double? width, double? height}) {
  return width != null && height != null
      ? CachedNetworkImage(
          height: height,
          width: width,
          imageUrl: url,
          fit: BoxFit.fill,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
            color: Color(0xFFEC5428),
            value: downloadProgress.progress,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )
      : CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.fill,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
            color: Color(0xFFEC5428),
            value: downloadProgress.progress,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
}
