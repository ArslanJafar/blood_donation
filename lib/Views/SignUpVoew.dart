import 'package:blood_donation/Constants/Constants.dart';
import 'package:blood_donation/Controllers/AuthController.dart';
import 'package:blood_donation/Widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

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
              image:  const DecorationImage(
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
               Center(child: PhotoSelector(
                 onSelect: (file){
                 controller.image = file;
               },
                 imageUrl: controller.imgUrl,
               ),
               ),
              SizedBox(height: 10.h,),
              InputField(
                controller: controller.usernameController,
                hintText: "Enter Username Here",
                labelText: "Username",
                preIcon: const Icon(Icons.person),
              ),
              InputField(
                controller: controller.phoneController,
                hintText: "Enter Phone Number Here",
                labelText: "Phone Number",
                preIcon: const Icon(Icons.phone),
                keyboard: TextInputType.phone,
              ),
              InputField(
                controller: controller.emailController,
                hintText: "Enter Email Address Here",
                labelText: "Email",
                preIcon: const Icon(Icons.email),
                keyboard: TextInputType.emailAddress,
              ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Are You blood Donner? ", style: TextStyle(fontWeight: FontWeight.w900),),
                  Switch(value: controller.isDonner,
                      onChanged: (val)
                      {
                        controller.isDonner  = !controller.isDonner;
                      }
                  )
                ],
              ),
               Padding(
                padding: EdgeInsets.all(18.w),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Appcolors.primaryColor, width: 1),

                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ExpansionTile(
                      leading: Icon(Icons.bloodtype, color: Appcolors.primaryColor,),
                      key: Key(controller.bloodGroup),
                      title: Text(controller.bloodGroup,style: TextStyle(color: Appcolors.primaryColor),),
                      children:
                      controller.bloodGroups.map(
                              (e) =>
                              ListTile(title: Text(e), onTap: ()
                              {
                                controller.bloodGroup = e;
                              },
                              )
                      ).toList()
                  ),
                ),
              ) ,
             // controller.isDonner == true ? const Center(child: CircularProgressIndicator(),):

              SizedBox(
                width: 1.sw,
                child: ElevatedButton(
                  onPressed: (){
                    controller.signUp();
                  },
                  child: const Text("Create Account"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}