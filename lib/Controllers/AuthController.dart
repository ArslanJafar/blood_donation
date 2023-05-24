import 'dart:io';
import 'package:blood_donation/Models/Models.dart';
import 'package:blood_donation/Services/FireBaseService.dart';
import 'package:blood_donation/Utills/CommonFunctions.dart';
import 'package:blood_donation/Views/Views.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Views/DashBoardView.dart';
class AuthController extends GetxController
{
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  bool _hidePassword = true;
  bool _isDonner = false;
  bool loading = false;
  String imgUrl = "";
  String _bloodGroup ="Select Blood Group";
  final List<String> bloodGroups = ['A+','B+','AB+','O+','A-','B-','AB-'];
  File? _image;
  GeoPoint _geoPoint = const GeoPoint(30.8012439,73.361896);
  List<UserModel> _donners = [];
  //getter
  List<UserModel> get donners => _donners;
  bool get hidePassword => _hidePassword;
  String get bloodGroup => _bloodGroup;
  File? get image => _image;
  bool get isDonner => _isDonner;
  //setters
  set bloodGroup(String val)
  {
    _bloodGroup = val;
    update();
  }
  set image (File? val)
  {
    _image = val;
    update();
  }
set hidePassword(bool val)
{
  _hidePassword = val;
  update();
}
set isDonner(bool val)
{
  _isDonner = val;
  update();
}
login() async
{
  SharedPreferences shared =  await SharedPreferences.getInstance();

  if(_validateLogin())
  {
    loading = true;
    update();
    var user = await FirebaseService.loginWithEmailAndPassword(email: emailController.text.trim(), password: passController.text.trim());
    if(user != null)
    {
      shared.setString("userId", user.uid);
      await checkUserExistOrNot();
      loading = false;
      update();
    }
    else
    {
      loading=false;
      update();
    }
    clearData();
  }
}
checkUserExistOrNot() async{
  SharedPreferences shared =  await SharedPreferences.getInstance();
  String? userId = shared.getString("userId");
  if(userId != null)
    {
      var data = await FirebaseService.getOneDocById(collection: "Users", docId: userId);
      if(data != null)
        {
          var phone = data['phone'].toString();
          shared.setString("phone", phone);
          Get.offAll(() => const DashboardView() );
        }
      else
        {
          Get.off(()=> const SignUpView());
        }
    }
else
  {
    Get.off(()=> const LoginView());
  }
}
  _uploadPhoto() async
  {
    loading =true;
    update();
    if(_image != null)
      {
        var url =  await Future.wait({FirebaseService.uploadFile(_image!)});
        if(url.isNotEmpty)
          {
            imgUrl = url.first;
            update();
          }
      }
  }
signUp() async
{
  SharedPreferences shared = await SharedPreferences.getInstance();
  Position? position = await CommonFunctions.getCurrentPosition();
  if(position != null)
    {
      _geoPoint = GeoPoint(position.latitude, position.latitude);
      shared.setDouble("latitude", position.latitude);
      shared.setDouble("longitude",  position.longitude);
    }
  else
    {
      shared.setDouble("latitude", _geoPoint.latitude);
      shared.setDouble("longitude",  _geoPoint.longitude);
    }
  if(_validate())
  {
    await _uploadPhoto();
    var user = await FirebaseService.signupWithEmailAndPassword(email: emailController.text.trim(), password: passController.text.trim());
    if(user != null)
      {
        shared.setString("userId", user.uid);
        shared.setString("phone", phoneController.text.trim());
        shared.setBool("isDonner", _isDonner);
        UserModel userModel = UserModel(
          id: user.uid,
          username: usernameController.text.trim(),
          imageUrl: imgUrl,
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          password: passController.text.trim(),
          createdOn: DateTime.now(),
            location: _geoPoint,
            isDonner: _isDonner,
            bloodGroup: _isDonner == false ? "" : _bloodGroup
        );
        await FirebaseService.addUser(doc: userModel.toSnapshot(), userId: user.uid);
        Get.offAll(() => const DashboardView());
        loading = false;
        update();
       }
    else
      {
        loading=false;
        update();
      }
    update();
   clearData();
  }
}
resetPassword() async
{
if(_validateReset())
  {
    loading =true;
    update();
    await FirebaseService.sendResetPassword(email: emailController.text.trim());
  }
}
clearData()
{
  usernameController.clear();
  emailController.clear();
  phoneController.clear();
  passController.clear();
  update();
}
//only for signUp method
bool _validate()
{
  bool check =true;
  if(usernameController.text.trim().isEmpty)
    {
      check = false;
      CommonFunctions.showSnackBar("Username Required", "Please Enter UserName");
    }
  else if(CommonFunctions.validateEmail(usernameController.text.trim()))
    {
      CommonFunctions.showSnackBar("Invalid UserName", "Please Enter valid Username", );
    }
  else if(passController.text.trim().isEmpty)
  {
    check = false;
    CommonFunctions.showSnackBar("Password Require", "Please Enter Password");
  }
  else if(!CommonFunctions.validatePassword(passController.text.trim()))
  {
    check = false;
    CommonFunctions.showSnackBar("Weak Password", "Password should contain a capital letter a special character and a number");
  }
  else if(emailController.text.trim().isEmpty)
  {
    check = false;
    CommonFunctions.showSnackBar("Email Require", "Please Enter Email");
  }
  else if(phoneController.text.trim().isEmpty)
    {
      check = false;
      CommonFunctions.showSnackBar("Phone Require", "Please Enter Phone Number");
    }
  else if(phoneController.text.trim().length != 11)
  {
    check = false;
    CommonFunctions.showSnackBar("Phone Require", "Please Enter Valid Phone Number");
  }
  else if(isDonner == true && _bloodGroup == "Select Blood Group")
    {
      check = false;
      CommonFunctions.showSnackBar("Select Blood Group", "Please Select Blood Group");
    }


  return check;
}
  bool _validateLogin()
  {
    bool check =true;
    if(emailController.text.trim().isEmpty)
    {
      check = false;
      CommonFunctions.showSnackBar("Email Require", "Please Enter Email");
    }
    else if(passController.text.trim().isEmpty)
    {
      check = false;
      CommonFunctions.showSnackBar("Password Require", "Please Enter Password");
    }
    else if(!CommonFunctions.validatePassword(passController.text.trim()))
    {
      check = false;
      CommonFunctions.showSnackBar("Weak Password", "Password should contain 8 character");
    }
    return check;
  }
  bool _validateReset()
  {
    bool check =true;
    if(emailController.text.trim().isEmpty)
    {
      check = false;
      CommonFunctions.showSnackBar("Email Require", "Please Enter Email");
    }
    else if(!CommonFunctions.validateEmail(emailController.text.trim()))
      {
        check =false;
        CommonFunctions.showSnackBar("Invalid email", "Please Enter valid email");
      }
    return check;
  }
  onInit()
  {
    super.onInit();
    getAllDonner();
  }
  getAllDonner() async
  {
    var data = await FirebaseService.getDocuments(collection: "Users", where1: "isDonner", where1Value: true);
    _donners = data.map((e) => UserModel.fromSnapshot(e)).toList();
    update();
  }
  loadData() async
  {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? userId = shared.getString("userId");
    if(userId  != null)
    {
      var x = await FirebaseService.getOneDocById(collection: "Users", docId: userId);
      if(x != null )
      {
        UserModel userModel = UserModel.fromSnapshot(x);
        _isDonner = userModel.isDonner!;
        usernameController.text = userModel.username.toString();
        usernameController.text = userModel.phone.toString();
        imgUrl  = userModel.imageUrl.toString();
        update();
      }
    }
  }
  updateUserData()async
  {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? userId = shared.getString("userId");
    if(userId != null)
    {
      var doc =  {
        "imageUrl" : imgUrl,
        "username" : usernameController.text.trim(),
        "phone" : phoneController.text.trim(),
      };
      await FirebaseService.update(collection: "Users", doc: doc, docId: userId);
      CommonFunctions.showSnackBar("Data Save ", "Profile Successfully saved");
    }

  }

  updateUserType(bool  val) async
  {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? userId = shared.getString("userId");
    var doc = {
      "isDonner" : val
    };
    if(userId != null){
      await FirebaseService.update(collection: "Users", doc: doc, docId: userId);
    }
    getAllDonner();
  }
}