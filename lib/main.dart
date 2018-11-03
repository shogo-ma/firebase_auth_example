import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_example/page/account.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  FirebaseUser _user;

  Future<FirebaseUser> _signIn(String email, String password) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  void _onPressed() {
    var _email = this._emailController.text;
    var _password = this._passwordController.text;

    if (_email == "" || _password == "") {
      return;
    }

    this._signIn(_email, _password).then((user) {
      setState(() {
        _user = user;
      });

      Navigator.push(
          context,
          new MaterialPageRoute(
              settings: const RouteSettings(name: "/account"),
              builder: (BuildContext context) =>
                  new AccountPage(user: this._user)));
    }).catchError((error) {
      debugPrint(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new TextField(
                controller: this._emailController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'メールアドレス'),
                style: new TextStyle(
                    fontSize: 12.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"),
              ),
              padding: const EdgeInsets.all(15.0),
              alignment: Alignment.center,
            ),
            new Container(
              child: new TextField(
                obscureText: true,
                controller: this._passwordController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'パスワード'),
                style: new TextStyle(
                    fontSize: 12.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"),
              ),
              padding: const EdgeInsets.all(15.0),
              alignment: Alignment.center,
            ),
            new FlatButton(
                key: null,
                onPressed: this._onPressed,
                child: new Text(
                  "ログイン",
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                ))
          ],
        ),
      ),
    );
  }
}
