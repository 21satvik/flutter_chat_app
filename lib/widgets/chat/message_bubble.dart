import 'package:chat_app/screens/image_preview_screen.dart';
import 'package:flutter/material.dart';

import '../extra/sound_player.dart';
import 'package:chat_app/widgets/extra/video_player.dart';

class MessageBubble extends StatefulWidget {
  final String message;
  final String chatImg;
  final String chatVid;
  final String chatAudio;
  final String userName;
  final String userImage;
  final bool isMe;
  final Key key;

  MessageBubble(
    this.message,
    this.chatImg,
    this.chatVid,
    this.chatAudio,
    this.userName,
    this.userImage,
    this.isMe,
    this.key,
  );

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  SoundPlayer soundPlayer = SoundPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    soundPlayer.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    soundPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.message.isNotEmpty)
          Row(
            mainAxisAlignment:
                widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.isMe
                      ? Colors.grey[300]
                      : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !widget.isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        widget.isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                ),
                width: 140,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline1!
                                .color,
                      ),
                    ),
                    Text(
                      widget.message,
                      style: TextStyle(
                          color: widget.isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline1!
                                  .color),
                      textAlign: widget.isMe ? TextAlign.end : TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          )
        else if (widget.chatImg.isNotEmpty)
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ImagePreviewScreen.routeName,
                  arguments: widget.chatImg);
            },
            child: Row(
              mainAxisAlignment:
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  width: 190,
                  // padding:
                  //     EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: widget.isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          backgroundColor: widget.isMe
                              ? Colors.grey[300]
                              : Theme.of(context).accentColor,
                          color: widget.isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline1!
                                  .color,
                        ),
                        textAlign:
                            widget.isMe ? TextAlign.end : TextAlign.start,
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.black,
                        child: AspectRatio(
                          aspectRatio: 3 / 5,
                          child: FadeInImage(
                            placeholder: AssetImage(
                              'assets/images/loading.png',
                            ),
                            image: NetworkImage(widget.chatImg),
                            placeholderFit: BoxFit.cover,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else if (widget.chatVid.isNotEmpty)
          Row(
            mainAxisAlignment:
                widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                width: 390,
                // padding:
                //     EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        backgroundColor: widget.isMe
                            ? Colors.grey[300]
                            : Theme.of(context).accentColor,
                        color: widget.isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline1!
                                .color,
                      ),
                      textAlign: widget.isMe ? TextAlign.end : TextAlign.start,
                    ),
                    Container(child: VideoPlayer(widget.chatVid)),
                  ],
                ),
              ),
            ],
          )
        else if (widget.chatAudio.isNotEmpty)
          Row(
            mainAxisAlignment:
                widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Card(
                child: Container(
                  width: 140,
                  // padding:
                  //     EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: widget.isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          backgroundColor: widget.isMe
                              ? Colors.grey[300]
                              : Theme.of(context).accentColor,
                          color: widget.isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline1!
                                  .color,
                        ),
                        textAlign:
                            widget.isMe ? TextAlign.end : TextAlign.start,
                      ),
                      Card(
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: isPlaying
                                    ? Icon(Icons.pause_circle_outline)
                                    : Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.black,
                                      ),
                                onPressed: () {
                                  soundPlayer.togglePlaying(() {
                                    setState(() {
                                      isPlaying = false;
                                    });
                                  }, widget.chatAudio);
                                  setState(() {
                                    isPlaying = !isPlaying;
                                  });
                                },
                              ),
                              Text(
                                'Audio',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        Positioned(
          left: widget.isMe ? null : 120,
          right: widget.isMe ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.userImage),
          ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
