import 'package:chat_for_absolute_app/screens/auth/sign_in_screen.dart';
import 'package:chat_for_absolute_app/screens/messages/message_screen.dart';
import 'package:chat_for_absolute_app/shared/extentions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/user_provider.dart';
import 'components/logo_with_title.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key, required this.username})
    : super(key: key);
  final String username;
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _otpCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LogoWithTitle(
        title: 'Verification',
        subText: "Verification code has been sent to your mail",
        children: [
          const SizedBox(height: defaultPadding),
          Form(
            key: _formKey,
            child: TextFormField(
              onSaved: (otpCode) {
                _otpCode = otpCode!;
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.send,
              decoration: const InputDecoration(hintText: "Enter OTP"),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final result = await context.read<UserProvider>().confirmSignUp(
                  username: widget.username,
                  code: _otpCode,
                );

                result.fold(
                      (error) => context.showError(error),
                      (success) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Email confirmed! Please sign in.')),
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignInScreen(),
                        ),
                            (route) => false,
                      );
                    });
                  },
                );
              }
            },

            child: context.watch<UserProvider>().isLoading
              ? const CircularProgressIndicator(color: Colors.white,)
              : const Text("Validate",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
