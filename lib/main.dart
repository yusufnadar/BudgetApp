import 'package:budget/src/home/view/home_view.dart';
import 'package:budget/src/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelperService.init();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget',
      home: const HomeView(),
      theme: ThemeData(fontFamily: GoogleFonts.cabin().fontFamily),
      debugShowCheckedModeBanner: false,
    );
  }
}
