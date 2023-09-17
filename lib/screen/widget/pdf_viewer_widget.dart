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
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    path.basename(filePath),
                    style: GoogleFonts.mali(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.pinkColor,
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
                // Set other PDFView properties here
              ),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppConstants.pinkColor,
            //     foregroundColor: Colors.white,
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: const Text('Close'),
            // ),
          ],
        ),
      ),
    );
  }
}
