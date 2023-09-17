import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_constant.dart';
import '../helper/db_helper.dart';
import '../helper/generate_pdf.dart';
import 'widget/pdf_viewer_widget.dart';

class DisplayDataPage extends StatefulWidget {
  const DisplayDataPage({super.key});

  @override
  _DisplayDataPageState createState() => _DisplayDataPageState();
}

class _DisplayDataPageState extends State<DisplayDataPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final dbHelper = DatabaseHelper.instance; // Use your DatabaseHelper

    // Ensure that the database is initialized
    final db = await dbHelper.database;

    final queryResult =
        await db.query('your_table'); // Replace with your table name

    setState(() {
      data = queryResult.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.pinkColor,
        elevation: 0,
        title: Text(
          'History',
          style: GoogleFonts.mali(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Image.asset(
          //   'assets/images/bg.jpeg', // Replace with your image file path
          //   fit: BoxFit.cover, // Adjust the fit as needed
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          Container(
            color: AppConstants.pinkColor
                .withOpacity(0.1), // Adjust color and opacity
            width: double.infinity,
            height: double.infinity,
          ),
          ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final date = item['date'];
              final time = item['time'];
              final name = item['name'];
              // Assuming your signature is stored as a Uint8List
              final signature = item['signature_path'];

              if (index == 0 || date != data[index - 1]['date']) {
                // If it's the first entry or a new date, display the date
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0.w),
                      child: Text(
                        '$date',
                        style: GoogleFonts.mali(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildEntry(time, date, name, signature),
                  ],
                );
              } else {
                // Otherwise, continue displaying entries for the same date
                // final formattedTime = DateFormat('HH:mm').format(currentDateTime);
                return _buildEntry(time, date, name, signature);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEntry(String time, String date, String name, signaturePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w).copyWith(left: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: GoogleFonts.mali(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.mali(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 80.h,
                  width: 80.w,
                  child: Image.file(File(signaturePath)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () async {
              final result = await generatePdfFile(
                  date, time, name, signaturePath.toString());

              final file = File(result);

              if (await file.exists()) {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return PdfViewerWidget(
                        filePath: result); // Pass the PDF file path
                  },
                );
              } else {
                // File does not exist, show "Download Failed" snackbar
                showSnackbar('PDF File Not Found');
              }
            },
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf),
                Text(
                  'Download',
                  style: GoogleFonts.mali(fontSize: 12.sp),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.mali()),
        duration: const Duration(seconds: 1), // Adjust the duration as needed
      ),
    );
  }
}
