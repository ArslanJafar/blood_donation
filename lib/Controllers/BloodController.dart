import 'dart:async';
import 'package:blood_donation/Models/BloodRequest.dart';
import 'package:blood_donation/Models/Models.dart';
import 'package:blood_donation/Services/FireBaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utills/CommonFunctions.dart';
class BloodController extends GetxController
{
  final Completer<GoogleMapController> mapController = Completer();
   String _bloodGroup = "Select  Blood Group";
   final List<String> bloodGroups = ['A+','B+','AB+','O+', 'A-', 'B-', 'AB-'];
   final List<String> requestedCategories = ['Accidental Case', 'Delivery Case', 'Other Case'];
   String _category = "Select Request Category";
  final addressController = TextEditingController();
  final dueDateController = TextEditingController();
  final messageController = TextEditingController();
  GeoPoint _geoPoint = const GeoPoint(30.8012439,73.361896);
  DateTime _selectedDate = DateTime.now();
  bool loading = false;
  bool _isDonner = false;
  List <UserModel> _donners = [];
  List<BloodRequest> _requests = [];
  List<BloodRequest> _myrequests = [];
  List<BloodRequest> get requests => _requests;
  List<BloodRequest> get myrequests => _myrequests;
  String get bloodGroup => _bloodGroup;
  String get category => _category;
   GeoPoint get geoPoint => _geoPoint;
  DateTime get selectedDate => _selectedDate;
  bool get isDonner => _isDonner;


  set bloodGroup (String val)
  {
    _bloodGroup = val;
    update();
  }
   set geoPoint (GeoPoint val)
   {
     _geoPoint = val;
     update();
   }

  set category (String val)
  {
    _category = val;
    update();
  }
  set selectedDate(DateTime val)
  {
    _selectedDate = val;
    dueDateController.text = CommonFunctions.formatDate(val);
    update();
  }
  set isDonner(bool val)
  {
    _isDonner = val;
    update();
  }
  bool _validate()
  {
    bool check = true;
    if(_bloodGroup == "Select Blood Group")
    {
      check = false;
      CommonFunctions.showSnackBar("Data Required", "Please Select  Blood Group.");
    }
    else if(_category == "Select Request Category")
    {
      check = false;
      CommonFunctions.showSnackBar("Data Required", "Please Select  Requested Category.");
    }
    else if(addressController.text.trim().isEmpty)
    {
      check = false;
      CommonFunctions.showSnackBar("Data Required", "Pleas Enter Hospital name here");
    }
    else if(messageController.text.trim().isEmpty)
    {
      check = false;
      CommonFunctions.showSnackBar("Data Required", "Please Enter a Message for the Donner to Add your Request.");
    }

    return check;
  }
  CameraPosition cameraPosition = const CameraPosition(
      target: LatLng(30.8012439, 73.361896)
  );
  @override
   onInit()
  {
    super.onInit();
    _getCurrentPosition();
    getAllRequests();
    getMyRequests();
  }
  getAllRequests() async
  {
    loading = true;
    update();
    var data = await FirebaseService.getDocuments(collection: "BloodRequests");
    print(data);
    _requests = data.map((e) => BloodRequest.fromSnapshot(e)).toList();
    _requests.sort((a,b) => b.requestedDate!.compareTo(a.requestedDate!));
    loading = false;
    update();
  }
  getMyRequests() async
  {
    loading = true;
    update();
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? userId = shared.getString("userId");
    var data = await FirebaseService.getDocuments(collection: "BloodRequests", where1: "userId");
   // print(data);
    _myrequests = data.map((e) => BloodRequest.fromSnapshot(e)).toList();
    _myrequests.sort((a,b) => b.requestedDate!.compareTo(a.requestedDate!));
    loading = false;
    update();
  }
  deleteRequests (BloodRequest myRequest) async
  {
    await FirebaseService.delete(collection: "BloodRequests", docId: myRequest.id.toString());
    await getMyRequests();
    await getAllRequests();
    update();
  }
  _getCurrentPosition() async
  {
    Position? position = await CommonFunctions.getCurrentPosition();
    if(position != null)
      {

        _geoPoint = GeoPoint(position.latitude, position.longitude);
        cameraPosition = CameraPosition(target: LatLng(position.latitude,position.longitude),
        zoom: 14.4746
        );
        update();
      }
  }
  setCurrentPosition(LatLng val)
  {
    _geoPoint = GeoPoint(val.latitude, val.longitude);
    update();
  }

  saveRequest() async
  {
    SharedPreferences shared =  await SharedPreferences.getInstance();
    String? userId =  shared.getString("userId");
    String? phone=  shared.getString("phone");

    if(_validate())
      {
        loading = true;
        update();
        BloodRequest request = BloodRequest(
          bloodGroup: _bloodGroup,
          category: _category,
          location: _geoPoint,
          hospital: addressController.text.trim(),
          message: messageController.text.trim(),
          userId: userId.toString(),
          dueDate: _selectedDate,
          phone: phone

        );
       await FirebaseService.add(collection: "BloodRequests", doc: request.toSnapShot());
       _bloodGroup = "Select Blood Group";
       _category = "Select Requested Category";
       addressController.clear();
       messageController.clear();
       selectedDate = DateTime.now();
       await getAllRequests();
       await getMyRequests();
       loading = false;
       update();
       CommonFunctions.showSnackBar("Required Sent", "Blood Request Sent to Donner");
      }
  }
  deleteRequest(BloodRequest myRequest)  async
  {

    await FirebaseService.delete(collection: "BloodRequests", docId: myRequest.id.toString());
    await getMyRequests();
    await getAllRequests();
    update();
  }
}