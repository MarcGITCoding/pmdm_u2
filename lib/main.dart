import 'package:flutter/material.dart';
import '../screens/home_page.dart';

void main() {
  runApp(PMPDM_U2());
}

class PMPDM_U2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPPMMD App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(124, 66, 255, 1),
        ),
      ),
      home: const HomePage(),
    );
  }
}
