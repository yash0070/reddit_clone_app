import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/constants/app_images.dart';
import 'package:reddit_app/feature/auth/controller/auth_controller.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:reddit_app/widgets/loader.dart';
import 'package:reddit_app/widgets/sign_in_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AppImages.logoImage,height: 40),
        actions: [
          TextButton(onPressed: (){}, child:Text("Skip",style: TextStyle(fontWeight: FontWeight.bold,color: Pallete.blueColor))),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text("Dive into your communities",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 0.5,color: Colors.white)),
          const SizedBox(height: 30),
          Image.asset(AppImages.loginEmoteImage,height: 400),
          const SizedBox(height: 30),
          isLoading?const Loader(): const SignInButton(),
        ]
      ),
    );
  }
}
