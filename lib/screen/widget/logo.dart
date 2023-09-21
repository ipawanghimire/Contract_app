import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_constant.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: SizedBox(
            height: 80.h,
            width: 80.w,
            child: Image.asset(
              AppConstants.logo,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          AppConstants.companyName,
          textAlign: TextAlign.justify,
          style: GoogleFonts.mali(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color.fromARGB(255, 29, 27, 27),
          ),
        ),
      ],
    );
  }
}
