import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../viewmodels/image_controller.dart';

class ProfileImageWidget extends StatefulWidget {
  ProfileImageWidget({
    super.key,
    required this.radius,
  });

  final double radius;

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  XFile? selectedImage; // 클래스 레벨로 이동

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            final image = await ImageController().pickImageFromGallery();
            if (image != null) {
              setState(() {
                selectedImage = image;
              });
            }
          },
          child: CircleAvatar(
            radius: widget.radius,
            backgroundImage: selectedImage != null
                ? FileImage(File(selectedImage!.path))
                : const AssetImage('lib/core/imgs/images/StudyDuck.png')
                    as ImageProvider,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // 프로필 사진 변경 로직 추가
            },
            child: CircleAvatar(
              radius: widget.radius * 0.3,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.camera_alt,
                size: widget.radius * 0.3,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
