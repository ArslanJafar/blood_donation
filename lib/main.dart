import 'package:blood_donation/Controllers/Controllers.dart';
import 'package:blood_donation/Views/AddRequestView.dart';
import 'package:blood_donation/Views/DashBoardView.dart';
import 'package:blood_donation/Views/Requests_Views.dart';
import 'package:blood_donation/Views/SearchView.dart';
import 'package:blood_donation/Views/SplashView.dart';
import 'package:blood_donation/Widgets/Requests_Widget.dart';
import 'package:blood_donation/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Controllers/SearchController.dart';

void main()  async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
    // color of navigation controls
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ScreenUtilInit(
      designSize: const Size(360, 670),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child){
         return GetMaterialApp(
          title: 'Blood Donation App',
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          theme: ThemeData(
            primarySwatch: Colors.red,
            textTheme: GoogleFonts.robotoTextTheme(textTheme).copyWith(
              bodyMedium: GoogleFonts.roboto(textStyle: textTheme.bodyMedium),
            ),
          ),


          home: const SearchView()
      );
    }
    );
  }
}

class InitialBinding  implements Bindings
{
  @override
  void dependencies()
  {
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => BloodController(), fenix: true );
  Get.lazyPut(() => DashBoardController(), fenix: true);
  Get.lazyPut(() => BloodSearchController(), fenix: true);
  }
}
