import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  TextComposer(this.sendMessage);

  final Function({String texto, File fileImg}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  bool _isComposing = false;
  final TextEditingController _sendController = TextEditingController();

  void _reset(){
    widget.sendMessage(texto: _sendController.text);
    _sendController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: () async {
              final File fileImg = await ImagePicker.pickImage(source: ImageSource.gallery);
              if(fileImg == null){
                return;
              }else{
                widget.sendMessage(fileImg: fileImg);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              final File fileImg = await ImagePicker.pickImage(source: ImageSource.camera);
              if(fileImg == null){
                return;
              }else{
                widget.sendMessage(fileImg: fileImg);
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: _sendController,
              decoration: InputDecoration(
                hintText: "Enviar uma mensagem",
                border: null,
              ),
              onChanged: (text){
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text){
                widget.sendMessage(texto: text);
                _reset();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? (){
              _reset();
            } : null,
          ),
        ],
      ),
    );
  }
}