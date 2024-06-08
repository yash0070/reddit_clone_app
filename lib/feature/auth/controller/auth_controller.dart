import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/models/user_model.dart';
import 'package:reddit_app/feature/auth/repository/auth_repository.dart';

import '../../../core/utils.dart';


/// We use here StateProvider because we want the update value in all case , provider only read widgets
/// So for get the updates and listen changes we using StateProvider
/// This userProvider get all of the user data related the name, profile, email and everything
final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) => AuthController(authRepository: ref.watch(authRepositoryProvider,), ref: ref));

final authStateChangeProvider = StreamProvider((ref){
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getDataProvider = StreamProvider.family((ref,String uid){
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool>{
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref}) :
        _authRepository = authRepository,
        _ref = ref,
        super(false); // there the state is for the loader part initially it's false


  Stream<User?> get authStateChange => _authRepository.authStateChanges;


  void googleSingIn(BuildContext context)async{
    state = true;
    final user = await _authRepository.singInWithGoogle();
    state = false;
    /// This is for get the response either it's failure or success
    user.fold((l) => showSnackBar(context,l.message),
            (userModel) => _ref.read(userProvider.notifier).update((state) => userModel));
  }


  Stream<UserModel> getUserData(String uid) {
   return _authRepository.getUserData(uid);
  }
}