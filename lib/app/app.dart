import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/theme/lightTheme.dart';
import 'package:mcd/app/widgets/no_connection_banner.dart';
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
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: NoConnectionBanner(),
              ),
            ],
          );
        },
      ),
    );
  }
}
