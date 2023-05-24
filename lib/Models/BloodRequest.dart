import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequest
{
  final String? id;
  final String? bloodGroup;
  final GeoPoint? location;
  final String? hospital;
  final String? message;
  final String? userId;
  final String? category; // for which disease or patient
  final DateTime? requestedDate;
  final DateTime? dueDate;
  final String? phone;
  BloodRequest({this.id,this.bloodGroup, this.location, this.hospital, this.message, this.userId, this.category, this.requestedDate, this.dueDate, this.phone});

  factory BloodRequest.fromSnapshot(DocumentSnapshot snapshot)
  {
    return BloodRequest(
      id: snapshot.id,
      bloodGroup: snapshot['bloodGroup'],
      location: snapshot['location'],
      hospital: snapshot['hospital'],
      message: snapshot['message'],
      userId: snapshot['userId'],
      category: snapshot['category'],
      phone: snapshot['phone'],
      requestedDate: DateTime.fromMillisecondsSinceEpoch(snapshot['requestedDate']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(snapshot['dueDate']),

    );
  }
  toSnapShot()
  {
    return{
      "bloodGroup" : bloodGroup,
      "location" : location,
      "hospital" : hospital,
      "message" : message,
      "userId" : userId,
      "category" : category,
      "phone" : phone,
      "requestedDate" : DateTime.now().millisecondsSinceEpoch,
      "dueDate" : dueDate!.millisecondsSinceEpoch


    };
  }
}