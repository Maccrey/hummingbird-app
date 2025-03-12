import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.radius,
  });

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Todo : 프로필 사진 변경 로직 추가
            print('프로필 사진 변경');
          },
          child: CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage('lib/core/imgs/images/StudyDuck.png'),
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
              radius: radius * 0.3,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.camera_alt,
                size: radius * 0.3,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
