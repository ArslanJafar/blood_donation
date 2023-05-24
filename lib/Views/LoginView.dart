import 'package:blood_donation/Constants/Constants.dart';
import 'package:blood_donation/Controllers/AuthController.dart';
import 'package:blood_donation/Views/Views.dart';
import 'package:blood_donation/Widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace:  Container(
          width: 1.sw,
          height: 0.20.sh,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(120.w, 50.h), bottomRight: Radius.elliptical(120.w, 50.h)),
              image: const DecorationImage(
                  image:  AssetImage(AppAssets.logInImage),
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
        builder: (controller)
        {
          return ListView(
            padding: EdgeInsets.all(18.w),
            children: [
              SizedBox(height: 10.h,),
              Center(
                child: Text("Donate Blood, Save Humanity", style: TextStyle(color: Appcolors.primaryColor, fontSize: 22.sp, fontWeight: FontWeight.w600),),
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
              InputField(
                controller: controller.passController,
                hintText: "Enter Password Here",
                labelText: "Password",
                preIcon: const Icon(Icons.lock),
                isPassword: controller.hidePassword,
                trailIcon: IconButton(
                  onPressed: (){
                    controller.hidePassword = !controller.hidePassword;
                  },
                  splashRadius: 20.w,
                  icon: Icon(controller.hidePassword ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              SizedBox(height: 10.h,),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: (){
                        Get.to(() => ResetPasswordView());
                    },
                    child: const Text("Forgot Password ? ")
                ),
              ),
              SizedBox(height: 10.h,),

              controller.loading ? const Center(child: CircularProgressIndicator(),) :
              SizedBox(
                width: 1.sw,
                child: ElevatedButton(
                  onPressed: (){
                    controller.login();
                    Get.to(() => DashboardView());

                  },
                  child: const Text("Login"),
                ),
              ),
            SizedBox(height: 10.h,),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    const Text("Don,t have account "),
                    TextButton(
                        onPressed: ()
                        {
                          controller.signUp();
                          Get.off(() => const SignUpView());
                        },
                        child: const Text("Create Account")
                    )
                  ],
                ),
              )

            ],
          );
        },
      ),
    );
  }
}