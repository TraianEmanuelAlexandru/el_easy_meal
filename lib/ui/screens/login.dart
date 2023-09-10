import 'dart:html';

import 'package:el_easy_meal/ui/screens/home.dart';
import 'package:el_easy_meal/ui/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BoxDecoration _buildBackground() {
      return BoxDecoration(
        image: DecorationImage(
          image: AssetImage("brooke-lark-wMzx2nBdeng-unsplash.jpg"),
          fit: BoxFit.cover,
        ),
      );
    }

    Text _buildText() {
      return Text(
        '',
        style: Theme.of(context).textTheme.headline,
      );
    }

    return Scaffold(
      body: Container(
        decoration: _buildBackground(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildText(),
              SizedBox(height: 50.0),
              // Passing function callback as constructor argument:
              MaterialButton(// New c/
              // / ode
                onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                child: Text(
                  "Let's cook",
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.center,
                ),// New code
              ), // New code
            ],
          ),
        ),
      ),
    );
  }
}