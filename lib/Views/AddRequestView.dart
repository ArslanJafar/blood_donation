import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Constants/AppColors.dart';
import '../Controllers/BloodController.dart';
import '../Widgets/input_field.dart';

class AddRequestView extends StatelessWidget {
  const AddRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your Request"),
      ),
      body: GetBuilder<BloodController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
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
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Appcolors.primaryColor, width: 1),

                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ExpansionTile(
                        leading: Icon(Icons.category, color: Appcolors.primaryColor,),
                        key: Key(controller.category),
                        title: Text(controller.category) ,
                        children:
                        controller.requestedCategories.map((e) =>
                            ListTile(
                              title: Text(e),
                              onTap: ()
                              {
                                controller.category = e;
                              },
                            )
                        ).toList()
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  InputField(
                    hintText: "Enter Hospital Name And Address",
                    labelText: "Hospital Name & Address",
                    controller: controller.addressController,
                    // leading: const Icon(Icons.location_city_rounded),
                  ),
                  SizedBox(height: 10.h,),
                  InputField(
                    hintText: "Enter Due Date Here",
                    labelText: "Due Date",
                    controller: controller.dueDateController,
                    readOnly: true,
                    // leading: const Icon(Icons.calendar_month),
                    onTap: ()async{

                      Future<void> _showDatePicker(BuildContext context)async
                      {
                        DateTime? date = await showDatePicker(context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900), lastDate: DateTime(2200));
                        if(date != null)
                        {
                          // controller.selectedDate = date;
                          controller.dueDateController.text = "${date.day}-${date.month}-${date.year}";
                        }
                      }
                      await _showDatePicker(context);

                    },
                  ),
                  SizedBox(height: 10.h,),
                  InputField(
                    hintText: "Enter Your Message Here",
                    labelText: "Message",
                    controller: controller.messageController,
                    maxLines: 1,
                    keyboard: TextInputType.multiline,

                  ),
                  SizedBox(height: 10.h,),
                  ClipRRect(
                    child: Container(
                      width: 1.sw,
                      height: 150.h,
                      decoration: BoxDecoration(
                        //border: Border.all(color: Appcolors.primaryColor),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: GoogleMap(
                        initialCameraPosition: controller.cameraPosition,

                        onMapCreated: (con)
                        {
                          controller.mapController.complete(con);
                        },
                        mapType: MapType.terrain,
                        markers: <Marker>{
                          Marker(
                              markerId: const MarkerId('current_position'),
                              position: LatLng(controller.geoPoint.latitude, controller.geoPoint.longitude)
                          )
                        },
                        onTap: (val)
                        {
                          controller.setCurrentPosition(val);
                        },
                        zoomControlsEnabled: true,
                      ),
                    ),
                  ),
                  controller.isDonner == true ? Padding(
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
                  ) :
                  SizedBox(height: 10.sp,),
                  //controller.loading ? const Center(child: CircularProgressIndicator(),):
                  SizedBox(
                      width: 1.sw,
                      child: ElevatedButton(onPressed: (){
                        controller.saveRequest();
                      }, child: const Text("Add Request")))
                ],
              ),
            );
          }
      ),
    );
  }

}
