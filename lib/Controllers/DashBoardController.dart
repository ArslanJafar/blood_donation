import 'package:blood_donation/Views/AddRequestView.dart';
import 'package:blood_donation/Views/Donner_View.dart';
import 'package:blood_donation/Views/LoginView.dart';
import 'package:blood_donation/Views/Requests_Views.dart';
import 'package:blood_donation/Views/SignUpVoew.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Views/Settings_View.dart';

class DashBoardController extends GetxController
{
  int _currentIndex = 1;
  int _maxCount = 3;
  final pageController = PageController(initialPage: 1);
  //getters
  int get currentIndex => _currentIndex;
  int get maxCount => _maxCount;
  //setters
  set currentIndex(int val)
  {
    _currentIndex = val;
   update();
  }
  final List<Widget> pages =[
    const DonnerView(),
    const  RequestsViews(),
    const  SettingView()
  ];
  @override
  void dispose()
  {
    pageController.dispose();
    super.dispose();
  }
}