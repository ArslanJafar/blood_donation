import 'package:blood_donation/Controllers/AuthController.dart';
import 'package:blood_donation/Utills/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonnerView extends StatelessWidget {
  const DonnerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(
        builder: (controller)
        {
          return ListView.builder(
            itemCount: controller.donners.length,
              itemBuilder: (context, index)
                  {
                    return controller.loading == true ? const Center(child: CircularProgressIndicator(),) :
                      Card(
                      elevation: 5.0,
                      child: ListTile(
                        tileColor: Colors.red.shade50,
                        leading: CircleAvatar(
                          child: Text("${controller.donners[index].bloodGroup}"),
                        ),
                        title: Text("${controller.donners[index].username}"),
                        subtitle: FutureBuilder(
                          future: CommonFunctions.getAddressFromCoordinates(controller.donners[index].location!.latitude,controller.donners[index].location!.longitude),
                          builder: (context, AsyncSnapshot<String> snapshot)
                          {
                            if(!snapshot.hasData)
                              {
                                return const SizedBox.shrink();
                              }
                            return Text("${snapshot.data}");
                          },
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
