import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              reverse: true,
              itemCount: (snapshot.data! as QuerySnapshot).docs.length,
              itemBuilder: (context, index) => MessageBubble(
                message: (snapshot.data! as QuerySnapshot).docs[index]['text'],
                isMe: (snapshot.data! as QuerySnapshot).docs[index]['userId'] ==
                    FirebaseAuth.instance.currentUser!.uid,
                key: ValueKey((snapshot.data! as QuerySnapshot).docs[index].id),
                username: (snapshot.data! as QuerySnapshot).docs[index]
                    ['username'],
                userImage: (snapshot.data! as QuerySnapshot).docs[index]
                    ['userImage'],
              ),
            ),
    );
  }
}
