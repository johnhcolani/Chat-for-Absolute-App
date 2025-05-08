
import 'package:chat_for_absolute_app/screens/auth/sign_in_screen.dart';
import 'package:chat_for_absolute_app/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';

class SigninOrSignupScreen extends StatelessWidget {
  const SigninOrSignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? "assets/images/ic_launcher.png"
                    : "assets/images/ic_launcher.png",
                height: 146,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                child: const Text("Sign In",style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: defaultPadding * 1.5),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: kSecondaryColor),
                child: const Text("Sign Up",style: TextStyle(color: Colors.white),),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
