import 'package:flutter/material.dart';
import 'package:notesapp/screen/appDrawer.dart';

import '../helper/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _hasError = false;
  String _errorMsg = "";

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();

    super.dispose();
  }

  TextFormField registerForm(ctrl, hint) {
    return TextFormField(
      controller: ctrl,
      decoration:
          InputDecoration(border: const OutlineInputBorder(), hintText: hint),
    );
  }

  Future submitRegisterForm() async {
    final res = await Auth().requestRegister({
      'name': _nameCtrl.text,
      'username': _usernameCtrl.text,
      'password': _passwordCtrl.text
    });

    if (res['status'] == true) {
      Navigator.pushNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Berhasil Register",
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      setState(() {
        _hasError = true;
        _errorMsg = res['error_msg'] ?? res['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterScreen'),
      ),
      drawerScrimColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            registerForm(_nameCtrl, 'Nama'),
            const SizedBox(height: 20),
            registerForm(_usernameCtrl, 'Username'),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: _hasError,
              child: Text(_errorMsg),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => submitRegisterForm(),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
