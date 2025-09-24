import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcd/app/theme/lightTheme.dart';
// import 'package:mcd/core/navigators/go_router.dart';
import 'package:mcd/features/transaction/presentation/notifiers/transaction.provider.dart';
import 'package:mcd/routes/app_pages.dart';
import 'package:mcd/routes/app_routes.dart';
import 'package:provider/provider.dart';

class McdApp extends StatelessWidget {
  const McdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TransactionNotifier()),
        ],
        child: GetMaterialApp(
          title: 'MCD App',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          theme: lightTheme,
        ),
      ),
    );
  }
}