import 'package:chat_online/chat_screen.dart';
import 'package:flutter/material.dart';

void main() async{
  runApp(MyApp());
  //Firestore.instance.collection("col").document("doc").setData({"texto":"Luiz"}); // Seta todos os dados para
  //Firestore.instance.collection("col").document("doc").updateData({"texto":"Luiz"}); // Seta dados especificados mantendo o resto
  //QuerySnapshot snapshot = await Firestore.instance.collection("col").getDocuments(); // Pega todos os documentos / Não atualiza quando alterar dado
  //DocumentSnapshot snapshot = await Firestore.instance.collection("col").document("doc").get(); //Pega um documento em especifico / Não atualiza quando alterar dado
  /*Firestore.instance.collection("col").snapshots().listen((dados){
    print(dados.documents[0].documentID);
    print(dados.documents[0].data);
  });*/
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Online",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.lightBlue,
        ),
      ),
      home: ChatScreen(),
    );
  }
}