import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:notesapp/helper/auth.dart';
import 'package:notesapp/screen/addNotesScreen.dart';
import 'package:notesapp/screen/homeScreen.dart';
import 'package:notesapp/screen/loginScreen.dart';
import 'package:notesapp/screen/registerScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Auth(),
      child: FutureBuilder(
        future: _initializeDateFormatting(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const LoginScreen(),
              routes: {
                '/register': (context) => const RegisterScreen(),
                '/login': (context) => const LoginScreen(),
                '/home': (context) => const HomeScreen(),
                '/notes': ((context) => const AddNotes()),
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting("id", "");
  }
}
