import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:chat_for_absolute_app/providers/message_provider.dart';
import 'package:chat_for_absolute_app/providers/user_provider.dart';
import 'package:chat_for_absolute_app/screens/auth/signin_or_signup_screen.dart';
import 'package:chat_for_absolute_app/screens/welcome/welcome_screen.dart';
import 'package:chat_for_absolute_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_auth_cognito_dart/amplify_auth_cognito_dart.dart';
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await configureAmplify();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MessageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> configureAmplify() async {
  try {

      final auth=AmplifyAuthCognitoDart();
       final api= AmplifyAPI(
          options: APIPluginOptions(modelProvider: ModelProvider.instance));
      await Amplify.addPlugin([api, auth]);

      debugPrint("✅ Amplify configured successfully");
  } catch (e) {
    debugPrint("❌ Error configuring Amplify: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Flutter Way',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      themeMode: ThemeMode.light,
      home: const SigninOrSignupScreen(),
    );
  }
}
