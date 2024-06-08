import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/constants/app_images.dart';
import 'package:reddit_app/feature/auth/controller/auth_controller.dart';
import 'package:reddit_app/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signWithGoogle(BuildContext context,WidgetRef ref){
    ref.read(authControllerProvider.notifier).googleSingIn(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
          onPressed: () => signWithGoogle(context,ref),
          icon: Image.asset(AppImages.googleImage,width: 35),
          label:const Text("Continue with Google",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Pallete.greyColor,
            minimumSize:const Size(double.infinity,50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )
          ),
      ),
    );
  }
}
