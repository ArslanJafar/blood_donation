import 'package:blood_donation/Models/Models.dart';
import 'package:blood_donation/Services/FireBaseService.dart';
import 'package:blood_donation/Utills/CommonFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class BloodSearchController extends GetxController {
  final locationController = TextEditingController();
  final List<String> bloodGroups = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-'];
  String _searchType = "Donners";
  String _bloodGroup = "Select Blood Group";
  List<UserModel> _donners = [];
  List<BloodRequest> _requests = [];

  //getters
  List<UserModel> get donners => _donners;

  List<BloodRequest> get requests => _requests;

  String get bloodGroup => _bloodGroup;

  String get searchType => _searchType;

  //setters
  set bloodGroup(String val) {
    _bloodGroup = val;
    update();
  }

  set searchType(String val) {
    _searchType = val;
    update();
  }

  getResults() async
  {
    if (_validate())
    {
    GeoPoint? geoPoint = await CommonFunctions.getCoordinatesFromAddress(locationController.text.trim());
    if(_searchType == "Donners")
      {
        if(geoPoint !=null)
          {
            var data = await FirebaseService.getDocuments(
                collection: "Users",
              where1: "bloodGroup",
              where1Value: _bloodGroup,
              where2: "location",
              where2value: geoPoint
            );
            _donners = data.map((e) => UserModel.fromSnapshot(e)).toList();
            update();
          }
      }
    else 
    {
        if(geoPoint !=null)
        {
          var data = await FirebaseService.getDocuments(
              collection: "BloodRequests",
              where1: "bloodGroup",
              where1Value: _bloodGroup,
              where2: "location",
              where2value: geoPoint
          );
          _requests = data.map((e) => BloodRequest.fromSnapshot(e)).toList();
          print(data);
          update();
        }
      }
    }
  }
  bool _validate()
  {
    bool check = true;
    if (_bloodGroup == "Select Blood Group") {
      check = false;
      CommonFunctions.showSnackBar(
          "Data Required", "Please Select Blood Group");
    }
    else if(locationController.text.trim().isEmpty)
    {
    check = false;
    CommonFunctions.showSnackBar("Data Require", "Please Enter City/Location");
    }
     return check;
    }

  }
