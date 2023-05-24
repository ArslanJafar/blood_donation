import 'package:blood_donation/Constants/Constants.dart';
import 'package:blood_donation/Controllers/AuthController.dart';
import 'package:blood_donation/Views/Views.dart';
import 'package:blood_donation/Widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          width: 1.sw,
          height: 0.20.sh,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(120.w, 50.h),
                  bottomRight: Radius.elliptical(120.w, 50.h)),
              image:  DecorationImage(
                  image: AssetImage(AppAssets.logInImage),
                  fit: BoxFit.cover
              )
          ),
        ),
        toolbarHeight: 0.22.sh,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark
        ),
      ),
      body: GetBuilder<AuthController>(
        builder: (controller) {
          return ListView(
            padding: EdgeInsets.all(18.w),
            children: [
              SizedBox(height: 10.h,),
              Center(
                child: Text("Donate Blood, Save Humanity", style: TextStyle(
                    color: Appcolors.primaryColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 10.h,),
              InputField(
                controller: controller.emailController,
                hintText: "Enter Email Address Here",
                labelText: "Email",
                preIcon: const Icon(Icons.email),
                keyboard: TextInputType.emailAddress,
              ),
              SizedBox(height: 10.h,),

              controller.loading ? const Center(
                child: CircularProgressIndicator(),) :
              SizedBox(
                width: 1.sw,
                child: ElevatedButton(
                  onPressed: () {
                    //controller.signUp();
                    controller.resetPassword();
                  },
                  child: const Text("Reset Password"),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}