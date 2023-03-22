import 'package:flutter/material.dart';
import 'package:notesapp/helper/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future submitLogout() async {
    final res = await Provider.of<Auth>(context, listen: false).requestLogout();
    if (res['status'] == true) {
      Navigator.pushNamed(context, '/login');
    }
  }

  ListTile buttonMenu(text, route, icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Column menuList;

    //Membaca nilai var isAuthenticated di class Auth
    var isLogin = context.watch<Auth>().isAuthenticated;

    if (isLogin) {
      menuList = Column(
        children: [
          buttonMenu('Catatan', '/home', Icons.notes),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              submitLogout();
              Navigator.pop(context);
            },
          ),
        ],
      );
    } else {
      menuList = Column(children: [
        buttonMenu('Register', '/register', Icons.app_registration),
        buttonMenu('Login', '/login', Icons.login),
      ]);
    }

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Drawer(
          width: MediaQuery.of(context).size.width / 1.7,
          elevation: 0,
          backgroundColor: Colors.grey.shade300,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: menuList,
          ),
        ),
      ),
    );
  }
}
