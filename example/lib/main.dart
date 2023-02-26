import 'dart:math';

import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat bubble example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'chat bubble2 example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  //AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  final ScrollController _scrollController = ScrollController();
  List<Widget> _chatList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 70),
            child: SingleChildScrollView(
              reverse: true,
              controller: _scrollController,
              child: Column(
                children: _chatList,
              ),
            ),
          ),

          /// send bar
          MessageBar(
            onTextChanged: (_) {
              //print('###### onTextChanged ${_}');
            },
            onSend: (item) {
              if (!mounted) {
                return;
              }
              bool isSender = Random().nextInt(2) == 0;
              setState(() {
                if (item.type == 1) {
                  Widget imageWidget = BubbleNormalTextImage(
                    id: 'id001',
                    node: item,
                    isSender: isSender,
                    backgroundColor: Color(0xFFEC5428),
                    delivered: true,
                  );
                  _chatList.add(imageWidget);
                } else if (item.type == 0) {
                  Widget textWidget = BubbleNormalText(
                    node: item,
                    isSender: isSender,
                    backgroundColor: Color(0xFF1B97F3),
                    delivered: true,
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  );
                  _chatList.add(textWidget);
                } else if (item.type == 14) {
                  // Random().nextInt(2) == 0 ? item.content! : ''
                  MetaJson? metaJson = item.metaJson;
                  if (metaJson != null) {
                    Widget fileWidget = BubbleNormalTextFile(
                      node: item,
                      text: '${item.content},${metaJson.type}',
                      isSender: isSender,
                      backgroundColor: Color(0xFFEC5428),
                      delivered: true,
                    );
                    _chatList.add(fileWidget);
                  }
                } else if (item.type == 3) {
                  /// audio
                  // Widget audioWidget = BubbleNormalAudio(
                  //   color: Color(0xFFE8E8EE),
                  //   duration: duration.inSeconds.toDouble(),
                  //   position: position.inSeconds.toDouble(),
                  //   isPlaying: isPlaying,
                  //   isLoading: isLoading,
                  //   isPause: isPause,
                  //   onSeekChanged: _changeSeek,
                  //   onPlayPauseButtonClick: _playAudio,
                  //   sent: true,
                  // );
                  // _chatList.add(audioWidget);
                }
              });
              if (_chatList!.isNotEmpty && _chatList!.length > 1) {
                _scrollController.jumpTo(0);
              }
            },
            actions: _buildActions(),
            //replying: true,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      InkWell(
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 24,
        ),
        onTap: () {},
      ),
      Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: InkWell(
          child: Icon(
            Icons.camera_alt,
            color: Colors.green,
            size: 24,
          ),
          onTap: () {},
        ),
      ),
    ];
  }

  // void _changeSeek(double value) {
  //   setState(() {
  //     audioPlayer.seek(new Duration(seconds: value.toInt()));
  //   });
  // }
  //
  // void _playAudio() async {
  //   final url =
  //       'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
  //   if (isPause) {
  //     await audioPlayer.resume();
  //     setState(() {
  //       isPlaying = true;
  //       isPause = false;
  //     });
  //   } else if (isPlaying) {
  //     await audioPlayer.pause();
  //     setState(() {
  //       isPlaying = false;
  //       isPause = true;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await audioPlayer.play(UrlSource(url));
  //     setState(() {
  //       isPlaying = true;
  //     });
  //   }
  //
  //   audioPlayer.onDurationChanged.listen((Duration d) {
  //     setState(() {
  //       duration = d;
  //       isLoading = false;
  //     });
  //   });
  //   audioPlayer.onPositionChanged.listen((Duration p) {
  //     setState(() {
  //       position = p;
  //     });
  //   });
  //   audioPlayer.onPlayerComplete.listen((event) {
  //     setState(() {
  //       isPlaying = false;
  //       duration = new Duration();
  //       position = new Duration();
  //     });
  //   });
  // }
}
