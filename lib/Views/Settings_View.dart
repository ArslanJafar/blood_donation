import 'package:blood_donation/Views/ManageRequestsView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controllers/AuthController.dart';
import 'LoginView.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 0.32.sh,
                    child: Stack(

                      children: [
                        Container(
                          color: controller.isDonner == false ? Colors.red : Colors.green,
                          width: double.maxFinite,
                          height: 0.25.sh,
                          child: Padding(
                            padding:  EdgeInsets.all(18.sp),
                            child: Row(
                              children: [
                                CircleAvatar(radius: 30.r,
                                  backgroundImage: NetworkImage(controller.imgUrl!.isEmpty ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSj1sjl5xRyOPDTIIJHQOHkxreZVMEneKiJrA&usqp=CAU" : controller.imgUrl!),
                                ),
                                SizedBox(width: 18.sp,),
                                const Text("Ali ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            top: 145,
                            child: Padding(
                              padding:  EdgeInsets.all(10.sp),
                              child: Container(
                                height: 0.1.sh,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0, // soften the shadow
                                        spreadRadius: 2.0, //extend the shadow
                                        offset: Offset(
                                          2.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text("Donner Mode", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    Switch(
                                        value: controller.isDonner,
                                        onChanged: (val)
                                        {
                                          controller.isDonner = !controller.isDonner;
                                        }
                                    )
                                  ],
                                ),
                              ),
                            )

                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(10.sp),
                    child: Text(controller.isDonner == false ? "Requests" : "Donner Info",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  controller.isDonner == false ? InkWell(
                    onTap: (){},
                    child:  ListTile(
                      leading: Icon(Icons.receipt),
                      title: Text("Manage Requests"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                      onTap: (){
                        Get.to(() => ManageRequestsView());
                      },
                    ),
                  )
                      : InkWell(
                    onTap: (){},
                    child: const ListTile(
                      leading: Icon(Icons.bloodtype),
                      title: Text("Become a donner"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(10.sp),
                    child: const Text("General",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                  InkWell(
                    onTap: (){
                      //Get.to(() => const Profileview());
                    },
                    child: const ListTile(
                      leading: Icon(Icons.person),
                      title: Text("My Profile"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: const ListTile(
                      leading: Icon(Icons.share_sharp),
                      title: Text("Share App"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: const ListTile(
                      leading: Icon(Icons.star_border_purple500_outlined),
                      title: Text("Rate App"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: const ListTile(
                      leading: Icon(Icons.message_sharp),
                      title: Text("Feed back & Suggestions"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: const ListTile(
                      leading: Icon(Icons.shield_outlined),
                      title: Text("Privacy"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.logout,size: 25,),
                    title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),onTap: (){
                    Get.defaultDialog(
                        title: "Confirm Logout ",
                        content: const Text("Do You want to logout from your Account?"),
                        actions: [
                          ElevatedButton(
                              onPressed: ()async{
                                SharedPreferences shared = await SharedPreferences.getInstance();
                                shared.remove("userId");
                                var auth = FirebaseAuth.instance;
                                await auth.signOut();
                                // exit(0)    yh sari app ko band karny k lye hai
                                // exit(0);
                                Get.back();
                                Get.offAll(()=> const LoginView());
                              },
                              child: const Text("Yes")),
                          ElevatedButton(
                              onPressed: (){

                              },
                              child: const Text("No"))
                        ]
                    );
                  },
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}