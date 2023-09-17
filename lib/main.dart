import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants/app_constant.dart';
import 'screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure initialization here
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(412, 732),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Arlington Wavier',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            focusColor: AppConstants.pinkColor,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor:
                  AppConstants.pinkColor, // Set your desired cursor color
            ),
          ),
          home: child,
        );
      },
      child: const HomePage(),
    );
  }
}
