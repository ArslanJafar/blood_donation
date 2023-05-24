import 'package:blood_donation/Controllers/BloodController.dart';
import 'package:blood_donation/Utills/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageRequestsView extends StatelessWidget {
  const ManageRequestsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Requests"),
      ),
      body: GetBuilder<BloodController>(
        builder: (controller)
        {
          return controller.myrequests.isEmpty ? const Text("No Requests Found"):
            ListView.builder(
              itemCount: controller.myrequests.length,
              itemBuilder: (context, index)
                  {
                    return Card(
                      elevation: 5.0,
                      child: ListTile(
                        leading: CircleAvatar(
                        child: Text("${controller.myrequests[index].bloodGroup}"),
                        ),
                        title: Text("${controller.myrequests[index].message}"),
                        subtitle: Text(CommonFunctions.formatDate(controller.myrequests[index].dueDate!)),
                        trailing: IconButton(
                          onPressed: (){
                            Get.defaultDialog(
                              title: "Confirm Delete",
                              content: const Text("Do you want to delete this request"),
                              actions: [
                                ElevatedButton(
                                    onPressed: (){
                                      controller.deleteRequest(controller.myrequests[index]);
                                      Get.back();}, child: const Text("Yes")),
                                ElevatedButton(onPressed: (){Get.back();}, child: const Text("No"))
                              ]
                            );
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    );
                  }
          );
        },
      ),
    );
  }
}
