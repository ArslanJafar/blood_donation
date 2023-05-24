import 'dart:io';

import 'package:blood_donation/Utills/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoSelector extends StatefulWidget {
  const PhotoSelector({Key? key, required this.onSelect, this.imageUrl}) : super(key: key);
  final Function(File?) onSelect;
  final String? imageUrl;
  @override
  State<PhotoSelector> createState() => _PhotoSelectorState();
}

class _PhotoSelectorState extends State<PhotoSelector> {
  File? image;
  showImage()
  {
    if(widget.imageUrl != "" && image == null)
      {
        image = null;
        return NetworkImage(widget.imageUrl.toString());
      }
    else if(widget.imageUrl == "" && image!= null)
      {
        return FileImage(image!);
      }
    else
      {
        image= null;
        return const AssetImage("assets/images/bdrop.png");
      }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.red,
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Colors.purple,
            backgroundImage: showImage(),
          ),
        ),
        Positioned(
          bottom: 0,
            right: 0,
            child: GestureDetector(
              child: CircleAvatar(
          radius: 16.sp,
          child: Icon(Icons.camera_alt),
        ),
              onTap: () async
              {
                image = await CommonFunctions.pickimage();
                widget.onSelect(image);
                setState(() {

                });
              },
            )
        )
      ],
    );
  }
}
