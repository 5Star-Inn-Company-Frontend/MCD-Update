import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/theme/lightTheme.dart';
// import 'package:mcd/core/navigators/go_router.dart';

class McdApp extends StatelessWidget {
  McdApp({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'MCD App',
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.SPLASH_SCREEN,
        getPages: AppPages.pages,
        theme: lightTheme,
      ),
    );
  }
}
