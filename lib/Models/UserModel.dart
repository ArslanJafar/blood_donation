import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel
{
  final String? id;
  final String? imageUrl;
  final String? username;
  final String? phone;
  final String? email;
  final String? password;
  final DateTime? createdOn;
  final bool? isDonner;
  final GeoPoint? location;
  final String? bloodGroup;

  UserModel( {this.id,this.imageUrl, this.username, this.phone,this.email, this.password,this.createdOn, this.isDonner, this.location, this.bloodGroup});
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot)
  {
    return UserModel(
      id: snapshot.id,
      imageUrl: snapshot['imageUrl'],
      username: snapshot['username'],
      phone: snapshot['phone'],
      email: snapshot['email'],
      password: snapshot['password'],
        createdOn: DateTime.fromMicrosecondsSinceEpoch(
            snapshot['createdOn']
        ),
        isDonner: snapshot['isDonner'],
      location: snapshot['location'],
      bloodGroup: snapshot['bloodGroup']

    );
  }
  toSnapshot()
  {
    return{
      "id": id,
      "imageUrl": imageUrl,
      "username":username,
      "phone":phone,
      "email":email,
      "password":password,
      "createdOn":createdOn!.millisecondsSinceEpoch,
      "isDonner": isDonner ?? false,
      "location" : location,
      "bloodGroup" : bloodGroup
    } ;
  }


}