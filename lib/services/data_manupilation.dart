import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RitcoUser {
  final uid;
  // final String name;

  RitcoUser({
    required this.uid,
  });
}

class RitcoAPI {
  //initialize firestore
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a collection ref

  CollectionReference createCollectionRef({@required String? collectionPath}) {
    return _firebaseFirestore.collection(collectionPath!);
  }

  //Adding data to firestor

  //set a doc
  Future setDoc(String collection, String docId, data) async {
    return await createCollectionRef(collectionPath: collection)
        .doc(docId)
        .set(data);
  }

  //reading data to firestor......

  // authChanges() {
  //   return _auth.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       return user.uid;
  //     }
  //   });
  // }

  //listen to auth changes about the user streams
  RitcoUser firebaseUser(User? user) {
    // ignore: unnecessary_null_comparison
    return RitcoUser(uid: user!.uid);
  }

  //future get user

  //listen to auth changes
  Stream<RitcoUser> get userChanges {
    return _auth.authStateChanges().map(firebaseUser);
  }

  //Users stream
  Stream<QuerySnapshot> get users {
    return createCollectionRef(collectionPath: 'users').snapshots();
  }

  //indinvidual user Snapshot
  Future<DocumentSnapshot> userSnapShot({@required String? uid}) {
    return createCollectionRef(collectionPath: 'users').doc(uid).get();
  }

  //individual userStream
  Stream<DocumentSnapshot> userStream({@required String? uid}) {
    return createCollectionRef(collectionPath: 'users').doc(uid).snapshots();
  }

  //Comments stream
  Stream<QuerySnapshot> get comments {
    return createCollectionRef(collectionPath: 'comments').snapshots();
  }

  Stream<QuerySnapshot> get services {
    return createCollectionRef(collectionPath: 'services').snapshots();
  }

  //individual coment stream
  Stream<DocumentSnapshot> commentStream({@required String? id}) {
    return createCollectionRef(collectionPath: 'comments').doc(id).snapshots();
  }

  //like a motivation
  // Future likeMotivation(
  //     {@required String? motivationId, @required int incrementedLikes}) async {
  //   try {
  //     await createCollectionRef(collectionPath: 'motivations')
  //         .doc(motivationId)
  //         .update({'likes': incrementedLikes});
  //     return true;
  //   } catch (e) {
  //     print('was not able to like the motivation');
  //     print(e);
  //     return false;
  //   }
  // }

  //set comment
  Future setComment(
    String uid,
    String thread,
    String surveyId,
  ) async {
    try {
      createCollectionRef(collectionPath: 'comments').doc().set({
        'comments': {},
        'created-at': DateTime.now(),
        'created-by': uid,
        'likes': {},
        'survey-id': surveyId,
        'thread': thread
      });
      return true;
    } catch (e) {
      print('failed to set a motivation');
      print(e);
      return false;
    }
  }
}
