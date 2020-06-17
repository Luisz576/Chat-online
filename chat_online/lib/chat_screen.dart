import 'dart:io';
import 'package:chat_online/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GoogleSignIn sign = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseUser _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<FirebaseUser> _getUser() async {
    if(_currentUser != null){ return _currentUser; }
    try{
      final GoogleSignInAccount googleSignInAccount = await sign.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
      );
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      return user;
    }catch(error){
      return null;
    }
  }

  void _sendMessage({String texto, File fileImg}) async{
    final FirebaseUser user = await _getUser();
    if(user == null){
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Não foi possivel fazer o login. Tente novamente"),
          backgroundColor: Colors.red,
        )
      );
    }
    Map<String, dynamic> dados = {
      'uid': user.uid,
      'senderName':user.displayName,
      'senderPhoto':user.photoUrl,
      'time':Timestamp.now(),
    };
    if(fileImg != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child("ChatOnline").child(DateTime.now().millisecondsSinceEpoch.toString()+_currentUser.uid).putFile(fileImg);
      setState(() {
        _isLoading = true;
      });
      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      dados['imgUrl'] = url;
      setState(() {
        _isLoading = false;
      });
    }
    if(texto != null && texto.isNotEmpty){
      dados['texto'] = texto;
    }
    Firestore.instance.collection("messages").add(dados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _currentUser != null ? "Olá, ${_currentUser.displayName}" : "Chat Online",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        actions: <Widget>[
          _currentUser != null ? IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: (){
              FirebaseAuth.instance.signOut();
              sign.signOut();
              _scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text("Você saiu com sucesso!"), duration: Duration(seconds: 2),)
              );
            },
          ) : Container(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("messages").orderBy('time').snapshots(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();
                    return ListView.builder(
                      reverse: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index){
                        return ChatMessage(documents[index].data, documents[index].data['uid']==_currentUser?.uid);
                      }
                    );
                }
              },
            ),
          ),
          _isLoading ?
          LinearProgressIndicator() : Container(),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}