import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final Map<String, dynamic> data;
  final bool isMine;

  ChatMessage(this.data, this.isMine);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          !isMine ?
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhoto']),
            ),
          ) : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                data['imgUrl'] != null ?
                Image.network(
                  data['imgUrl'],
                  width: 250.0,
                ) :
                Text(
                  data['texto'],
                  textAlign: isMine ? TextAlign.end : TextAlign.start,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  data['senderName'],
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          isMine ?
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhoto']),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
