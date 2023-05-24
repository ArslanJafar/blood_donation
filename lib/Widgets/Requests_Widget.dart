import 'package:blood_donation/Constants/AppColors.dart';
import 'package:blood_donation/Controllers/BloodController.dart';
import 'package:blood_donation/Models/BloodRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Utills/CommonFunctions.dart';

class RequestsWidgetCard extends StatelessWidget {
  final BloodRequest request;

  const RequestsWidgetCard({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showBottomSheet(context);
      },
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.sw),
          border: Border.all(width: 2.0, color: Appcolors.primaryColor),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Appcolors.primaryColor,
              child: Text("${request.bloodGroup}"),
            ),
            Column(
              children: [
                Text("${request.category}"),
                Text("${request.message}"),
                Text("${request.hospital}"),
                Text("${request.dueDate}")
              ],
            )
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context, builder: (context) {
      return SizedBox(
        width: 1.sw,
        height: 0.25.sh,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.
          children: [
            ListTile(
              leading: const Icon(Icons.whatshot),
              title: const Text("WhatsApp"),
              onTap: () {
                CommonFunctions.sendWhatsAppMessage(
                    phone: request.phone.toString(),
                    message: "I want to donate ${request
                        .bloodGroup} Blood to save humanity. Message me "
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Call"),
              onTap: () async
              {
                await CommonFunctions.keepPhoneCall(
                    phone: request.phone.toString(), message: "message");
              },
            ),
          ],
        ),
      );
    }
    );
  }
}
