import 'package:blood_donation/Widgets/AppBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/DashBoardController.dart';
class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text(controller. currentIndex == 0 ? "Blood Donner" : controller.currentIndex == 1 ? "Donate Blood, Save Humanity": "Settings" ),
              actions: [
                IconButton(onPressed: (){}, icon: Icon(Icons.search))
              ],
            ),
            body:  controller.pages[controller.currentIndex],
            bottomNavigationBar:AppBottomBar(onTap: (int i  ) {
              controller.currentIndex = i;
            }, currentIndex: controller.currentIndex,),
            );
        }
    );
  }
}
