import 'package:blood_donation/Controllers/SearchController.dart';
import 'package:blood_donation/Widgets/Widgets.dart';
import 'package:blood_donation/Widgets/type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Constants/AppColors.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: GetBuilder<BloodSearchController>(
        builder: (controller)
        {
          return Padding(padding: EdgeInsets.all(8.w),
          child: Column(
            children: [
              TypeSelector(
                selectedType: controller.searchType,
                  onSelect: (val)
                      {
                        controller.searchType = val;
                      }
              ),
              SizedBox(height: 10.h,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Appcolors.primaryColor, width: 1),

                    borderRadius: BorderRadius.circular(10)
                ),
                child: ExpansionTile(
                  leading: Icon(Icons.bloodtype, color: Appcolors.primaryColor,),
                  key: Key(controller.bloodGroup),
                  title:  Text(controller.bloodGroup),
                  children:  controller.bloodGroups.map((e) =>
                      ListTile(
                        title: Text(e),
                        onTap: ()
                        {
                          controller.bloodGroup = e;
                        },
                      )
                  ).toList() ,
                ),
              ),
              SizedBox(height: 10.h,),
              InputField(controller: controller.locationController,
              hintText: "Enter City/ Location Here",
                preIcon: const Icon(Icons.search),
              ),
              SizedBox(
                width: 1.sw,
                child: ElevatedButton(
                  onPressed: ()
                  {
              controller.getResults();
                  },
                  child: const Text("Search"),
                ),
              )
            ],
          ),
          );
        },
      ),
    );
  }
}
