import 'package:flutter/material.dart';
import 'package:notesapp/helper/auth.dart';
import 'package:notesapp/screen/appDrawer.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _hasError = false;
  String _errorMsg = "";

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();

    super.dispose();
  }

  TextFormField loginForm(ctrl, hint) {
    return TextFormField(
      controller: ctrl,
      decoration:
          InputDecoration(border: const OutlineInputBorder(), hintText: hint),
    );
  }

  Future submitLoginForm() async {
    final res = await Provider.of<Auth>(context, listen: false).requestLogin({
      'username': _usernameCtrl.text,
      'password': _passwordCtrl.text,
    });

    if (res['status'] == true) {
      Navigator.pushNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Berhasil Login",
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
        title: const Text('LoginScreen'),
      ),
      drawerScrimColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            loginForm(_usernameCtrl, 'Username'),
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
                onPressed: () => submitLoginForm(),
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                SizedBox(
                  height: 1,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'atau',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 1,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Create New Account'),
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
