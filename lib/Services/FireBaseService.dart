import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../Utills/CommonFunctions.dart';
import 'package:path/path.dart' as path;
import '../Views/SignUpVoew.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signupWithEmailAndPassword(
      { required String email, required String password}) async
  {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      user!.sendEmailVerification();
      CommonFunctions.showSnackBar(
          'Hello', "A verification email sent to: $email");
      return user;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        CommonFunctions.showSnackBar(
            "Error", "email already exist. Use another");
      }
      else if (e.code == "invalid-email") {
        CommonFunctions.showSnackBar("Error", "Please enter valid email.");
      }
      else if (e.code == "operation-not-allowed") {
        CommonFunctions.showSnackBar(
            "Error", "Operation Not Allowed. Please Enable ");
      }
      else if (e.code == "weak-password") {
        CommonFunctions.showSnackBar(
            "Error", "Password too weak. Please enter strong password.");
      }
      return null;
    }
  }

  static Future<User?> loginWithEmailAndPassword(
      { required String email, required String password}) async
  {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return user;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        CommonFunctions.showSnackBar(
            "Error", "user not found, please sign up first.");
        Get.to(() => const SignUpView());
      }
      else if (e.code == "invalid-email") {
        CommonFunctions.showSnackBar("Error", "Please enter valid email.");
      }
      else if (e.code == "user-disabled") {
        CommonFunctions.showSnackBar(
            "Error", "The user is disabled by the admin.");
      }
      else if (e.code == "wrong-password") {
        CommonFunctions.showSnackBar(
            "Error", "Wrong password. Please enter correct password.");
      }
      return null;
    }
  }

  static sendResetPassword({required String email}) async
  {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    }
    on FirebaseAuthException catch (e) {
      if (e.code == "auth/user-not-found") {
        CommonFunctions.showSnackBar(
            "User No Found", "User Account Not Exist on FireBase");
      }
    }
  }
static addUser({required Map<String, dynamic>doc, required String userId }) async
{
  try
      {
        await FirebaseFirestore.instance.collection("Users").doc(userId).set(doc);
      }
      on FirebaseException catch(e)
  {
    CommonFunctions.showSnackBar("Error", e.message.toString());

  }
}

static add({required String collection, required Map<String, dynamic> doc }) async
{
  try
  {
    await FirebaseFirestore.instance.collection(collection).add(doc);
  }
  on FirebaseException catch(e)
  {
    CommonFunctions.showSnackBar("Error", e.message.toString());

  }
}
//to update 
  static update({required String collection, required Map<String, dynamic> doc, required String docId }) async
  {
    try
    {
      await FirebaseFirestore.instance.collection(collection)..doc(docId).update(doc);
    }
    on FirebaseException catch(e)
    {
      CommonFunctions.showSnackBar("Error", e.message.toString());

    }
  }
  //to delete user
  static delete({required String collection,  required String docId }) async
  {
    try
    {
      await FirebaseFirestore.instance.collection(collection).doc(docId).delete();
    }
    on FirebaseException catch(e)
    {
      CommonFunctions.showSnackBar("Error", e.message.toString());

    }
  }
  static Future<DocumentSnapshot<Map<String,dynamic>>?> getOneDocById({required String collection, required String docId}) async
  {
    try
        {
          DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection(collection).doc(docId).get();
          if(data.exists)
            {
              return data;
            }
          else
            {
              return null;
            }
        }
        on FirebaseException catch(e)
    {
      CommonFunctions.showSnackBar("Error", e.message.toString());
    }
  }
  static Future<List<QueryDocumentSnapshot<Object?>>> getDocuments({required String collection,String? where1, dynamic where1Value, String? where2, dynamic where2value }) async
  {
    List<QueryDocumentSnapshot<Object?>> list = [];
    //get data on 2 condition
    if(where1 != null && where1Value != null && where2 != null && where2value != null)
      {
        var data = await FirebaseFirestore.instance.collection(collection).
            where(where1, isEqualTo: where1Value)
            .where(where2, isGreaterThanOrEqualTo: where2value)
            .where(where2, isLessThanOrEqualTo: "$where2value\uf8ff")
            .get();
        list =  data.docs;
      }
    // get data on 1 condition
    else if(where1 != null && where1Value != null)
      {
        var data = await FirebaseFirestore.instance.collection(collection).

            where(where1, isEqualTo: where1Value)

            .get();
        list =  data.docs;
      }
    //get whole collection data
    else
      {
        var data = await FirebaseFirestore.instance.collection(collection).
       get();
        list =  data.docs;
      }
    return list;
  }
  static Future<String> uploadFile(File file) async
  {
    String imageUrl = "";
    String fileName = path.basename(file.path);
    try {
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      print(snapshot.state.name);
      imageUrl = await reference.getDownloadURL();
    }
    on FirebaseException catch (e) {
      CommonFunctions.showSnackBar("Error", "${e.message}");
    }
    return imageUrl;
  }
}