import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/models/user_model.dart';
import 'package:reddit_app/feature/auth/controller/auth_controller.dart';
import 'package:reddit_app/feature/auth/screens/login_screen.dart';
import 'package:reddit_app/firebase_options.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:reddit_app/theme/routes.dart';
import 'package:reddit_app/widgets/error_text_widget.dart';
import 'package:reddit_app/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  UserModel? userModel;

  void getUserData(WidgetRef ref, User data)async{
    userModel = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
      data: (data) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Reddit App',
        theme: Pallete.darkModeAppTheme,
        routerDelegate: RoutemasterDelegate(
            routesBuilder: (context) {
              if(data!=null){
                getUserData(ref, data);
                if(userModel!=null){
                  return loggedInRoute;
                }
              }
              return loggedOutRoute;
            }),
        routeInformationParser:const RoutemasterParser(),
        // home: LoginScreen()
      ),
      error: (error,stackTrace) =>ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}


