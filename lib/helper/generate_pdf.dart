import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:pdf/widgets.dart';

import '../constants/app_constant.dart';

Future<String> generatePdfFile(
    String date, String time, String name, String signaturePath) async {
  final pdf = pw.Document();
  final customFont =
      Font.ttf(await rootBundle.load('assets/fonts/Mali-Regular.ttf'));

  final signatureBytes = File(signaturePath).readAsBytesSync();
  final logoBytes =
      (await rootBundle.load(AppConstants.logo)).buffer.asUint8List();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: const EdgeInsets.all(16),
          child: pw.Column(
            children: [
              pw.ClipOval(
                child: pw.Image(
                  pw.MemoryImage(logoBytes),
                  width: 100.w,
                  height: 100.h,
                ),
              ),
              pw.SizedBox(height: 10.h),
              pw.Text(
                AppConstants.companyName,
                style: pw.TextStyle(font: customFont, fontSize: 12),
              ),
              pw.SizedBox(height: 30.h),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  date,
                  style: pw.TextStyle(font: customFont, fontSize: 12),
                ),
                // pw.Text(
                //   '$time',
                //   style: pw.TextStyle(font: customFont, fontSize: 12),
                // ),
              ),
              pw.SizedBox(height: 10.h),
              pw.Text("""
This agreement releases Arlington Threading & Waxing from all liability relating to injuries that may occur during personal services at Arlington Threading & Waxing. By signing this agreement, I agree to hold Arlington Threading & Waxing entirely free from any liability, including financial responsibility for injuries incurred, regardless of whether injuries are caused by negligence.
I also acknowledge the risks that might involved in personal services threading, waxing, beauty and skin care related activities. These include but are not limited to skin irritation and wax burn. I swear that I am participating voluntarily, and that all risks have been made clear to me.
Additionally, I do not have any conditions that will increase my likelihood of experiencing injuries while engaging in this activity.
By signing below I here as $name forfeit all right to bring a suit against Arlington Threading & Waxing for any reason. In return, I will receive services from Arlington Threading & Waxing. I will also make every effort to obey safety precautions as explained to me verbally. I will ask for clarification when needed.""",
                  style: pw.TextStyle(font: customFont, fontSize: 12),
                  textAlign: pw.TextAlign.justify),
              pw.Row(children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 30.h),
                      pw.Text(
                        '   $name',
                        style: pw.TextStyle(font: customFont, fontSize: 12),
                      ),
                      pw.SizedBox(height: 10.h),
                      pw.Image(
                        pw.MemoryImage(signatureBytes),
                        width: 100.w,
                        height: 100.h,
                      ),
                    ]),
              ]),
            ],
          ),
        );
      },
    ),
  );

  Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

  final filePath = '${generalDownloadDir.path}/${name}_$date.pdf';

  final file = File(filePath);

  await file.writeAsBytes(await pdf.save());

  // print("Saved PDF to ${file.path}");

  return filePath;
}
