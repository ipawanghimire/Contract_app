import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import '../constants/app_constant.dart';
import '../helper/db_helper.dart';
import 'history.dart';
import 'widget/logo.dart';
import 'widget/paragraph_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a single stream controller and stream to emit the current time
  late StreamController<DateTime> _timeStreamController;
  late Stream<DateTime> _timeStream;
  TextEditingController nameController = TextEditingController();

  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  @override
  void initState() {
    super.initState();
    // Initialize the stream controller and stream in the initState method
    _timeStreamController = StreamController<DateTime>();
    _timeStream = _timeStreamController.stream;

    // Create a timer to emit the current time every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeStreamController.add(DateTime.now());
    });
  }

  @override
  void dispose() {
    // Close the stream controller when the widget is disposed
    _timeStreamController.close();
    super.dispose();
  }

  Future<void> _saveDataToDatabase() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Name field is required.',
            style: GoogleFonts.mali(),
          ),
        ),
      );
      return;
    }

    if (control.isFilled == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please provide a signature.',
            style: GoogleFonts.mali(),
          ),
        ),
      );
      return;
    }

    final date = DateFormat('MMM d,yyyy', 'en_US').format(DateTime.now());
    final time = DateFormat('HH:mm').format(DateTime.now());
    final name = nameController.text;

    // Call the toImage method on the control instance
    final signature = await control.toImage();

    final databaseHelper = DatabaseHelper.instance;
    final result = await databaseHelper.insertData(
      date,
      time,
      name,
      signature!.buffer.asUint8List(),
    );

    if (result > 0) {
      control.clear();
      nameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
            'Thankyou for signing in!',
            style: GoogleFonts.mali(),
          ),
        ),
      );
    } else {
      // Data insertion failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
            'Oops! Something went wrong.',
            style: GoogleFonts.mali(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide the keyboard when the user taps outside the text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppConstants.pinkColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Clarendon Threading LLC",
                style: GoogleFonts.mali(),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DisplayDataPage(),
                  ));
                },
                icon: const Icon(Icons.menu),
              ),
            ],
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0).copyWith(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    StreamBuilder<DateTime>(
                      stream: _timeStream,
                      builder: (context, snapshot) {
                        final currentDateTime = snapshot.data ?? DateTime.now();
                        final formattedDate = DateFormat('MMM d,yyyy', 'en_US')
                            .format(DateTime.now());
                        final formattedTime =
                            DateFormat('HH:mm:ss').format(currentDateTime);

                        return Column(
                          children: [
                            const SizedBox(
                                // height: 200.h,
                                // width: 200.w,
                                child: Logo()),
                            const SizedBox(
                              height: 10,
                            ),
                            const TextParagraph(),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$formattedDate $formattedTime',
                                      style: GoogleFonts.mali(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Full Name:",
                                        style: GoogleFonts.mali(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(),
                                    ),
                                    child: TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Your name',
                                        hintStyle: GoogleFonts.mali(),
                                        icon: const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.person,
                                            color: AppConstants.pinkColor,
                                          ),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Signature:",
                                      style: GoogleFonts.mali(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                _showSignatureDialog(
                                    context, nameController.text);
                              },
                              child: Container(
                                height: 80.h,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  border: Border.all(
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    control.isFilled
                                        ? 'Click to Edit'
                                        : 'Click to Sign',
                                    style: GoogleFonts.mali(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ElevatedButton(
                              onPressed: _saveDataToDatabase,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.pinkColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Text(
                                'Submit',
                                style: GoogleFonts.mali(),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignatureDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) {
        // Add your drawing widget or logic here
        return AlertDialog(
          title: Text(
            'Draw Your Signature',
            style: GoogleFonts.mali(),
          ),
          content: Container(
            height: 200.h,
            width: 300.w,
            decoration: BoxDecoration(
              color: AppConstants.pinkColor.withOpacity(0.1),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  constraints: const BoxConstraints.expand(),
                  child: HandSignature(
                    control: control,
                    type: SignatureDrawType.shape,
                  ),
                ),
                CustomPaint(
                  painter: DebugSignaturePainterCP(
                    control: control,
                    cp: false,
                    cpStart: false,
                    cpEnd: false,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.pinkColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.mali(),
                )),
            TextButton(
              onPressed: () {
                control.clear();
              },
              child: Text(
                'Reset',
                style: GoogleFonts.mali(),
              ),
            ),
          ],
        );
      },
    );
  }
}
