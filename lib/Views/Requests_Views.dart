import 'package:blood_donation/Controllers/BloodController.dart';
import 'package:blood_donation/Views/AddRequestView.dart';
import 'package:blood_donation/Widgets/Requests_Widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsViews extends StatelessWidget {
  const RequestsViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: GetBuilder<BloodController>(
       builder: (controller)
       {
         return controller.loading == true ? const Center(child: CircularProgressIndicator(color: Colors.black,),):
           ListView.builder(
           itemCount: controller.requests.length,
             itemBuilder: (context, index)
             {
               return RequestsWidgetCard(request: controller.requests[index]);
             }
         );

       },

     ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          Get.to(() => AddRequestView());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
