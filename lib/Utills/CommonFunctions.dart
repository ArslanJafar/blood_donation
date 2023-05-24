import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class CommonFunctions
{
  static showSnackBar( String title,  String message) async
  {
    GetSnackBar snackBar = GetSnackBar(
      title: title,
      message: message,
      duration: const Duration(seconds: 2),
    );
    Get.showSnackbar(snackBar);
  }
  static Future<File?> pickimage() async{
    ImagePicker picker = ImagePicker();
    XFile?  file = await picker.pickImage(source: ImageSource.gallery);
    if(file != null)
      {
        return File(file.path);
      }
    else
      {
        return null;
      }
  }
  static bool validateEmail(String email)
  {
    final bool emailValid = 
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }
  static bool validatePassword(String val)
  {
    final bool passwordValid =
        RegExp(r'^(?=.?[A-Z])(?=.?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(val);
    return passwordValid;
    }
    static Future<Position?> getCurrentPosition() async
    {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showSnackBar("Permission Denied", "Location permission denied by user");
          return null;
        }
      }
      else if(permission == LocationPermission.whileInUse || permission == LocationPermission.always)
        {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      //print(position);
      return position;
    }
      return null;
    }
 static String formatDate(DateTime date)
 {
   return DateFormat("dd-MM-yyyy").format(date);
 }
 static Future<String> getAddressFromCoordinates(double latitude, double longitude) async
 {
   String address = "";
   List<Placemark> placeMarks = await placemarkFromCoordinates(latitude, longitude);
   if(placeMarks.isNotEmpty)
     {
       Placemark position = placeMarks.first;
       address = "${position.locality}, ${position.administrativeArea}";
       //print(position);
     }
   return address;
 }
 static sendWhatsAppMessage ({required String phone, required message}) async
 {
    var mobile = phone.substring(1);
    mobile = "+92$mobile";
    await launchUrl(Uri.parse("https://wa.me/$mobile?text=message"),mode: LaunchMode.externalApplication);

 }
  static keepPhoneCall ({required String phone, required message}) async
  {
    var mobile = phone.substring(1);
    mobile = "tel:+92$mobile";
    await launchUrl(Uri.parse(mobile),mode: LaunchMode.platformDefault);
  }
  static sendEmail({required String email, required String subject, required String body}) async{
    await launchUrl(Uri.parse("mailto: $email?subject=$subject&body=$body"));
  }
  static Future<GeoPoint?> getCoordinatesFromAddress(String address) async
  {
    List<Location> locations = await locationFromAddress(address);
    if(locations.isNotEmpty)
    {
      Location location = locations.first;
      return GeoPoint(location.latitude, location.longitude);
      //print(position);
    }
    return null;
  }
}