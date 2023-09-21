import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:path/path.dart' as path;

import '../../constants/app_constant.dart';

class PdfViewerWidget extends StatelessWidget {
  final String filePath;

  const PdfViewerWidget({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      width: 350.w,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200.w,
                  child: Text(
                    path.basename(filePath),
                    style: GoogleFonts.mali(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.pinkColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppConstants.pinkColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PDFView(
              filePath: filePath,
            ),
          ),
        ],
      ),
    );
  }
}
