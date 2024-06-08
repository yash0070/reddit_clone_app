import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/core/constants/app_images.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/models/user_model.dart';
import 'package:reddit_app/core/types_def.dart';
import 'package:reddit_app/provider/firebase_provider/firebase_provider.dart';

final authRepositoryProvider = Provider((ref) =>
    AuthRepository(
        firebaseFireStore: ref.read(firebaseFirestoreProvider),
        firebaseAuth: ref.read(firebaseAuthProvider),
        googleSignIn: ref.read(googleSingInProvider),
    ));

class AuthRepository{
  final FirebaseFirestore _fireStore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firebaseFireStore,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }):_fireStore = firebaseFireStore,
  _googleSignIn = googleSignIn,
  _auth = firebaseAuth;

  CollectionReference get _users => _fireStore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> singInWithGoogle()async{
    try{

      /// To get the all Account that is signed in Device
      GoogleSignInAccount? googleUsers = await _googleSignIn.signIn();

      /// To get the credential of the account

      final googleAuth = await googleUsers?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      /// Now we have the credentials now create the credential in the firebase and store the credential in the firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      /// Save the user data into the User Model and store the firebase with firebaseStore

      /// We will check here if the user is first time login then store all information otherwise don't store all info
      late UserModel userModel;
      if(userCredential.additionalUserInfo!.isNewUser){
        userModel = UserModel(
            name: userCredential.user!.displayName??"No Name",
            profilePic: userCredential.user!.photoURL??AppImages.avatarDefault,
            banner: AppImages.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: []
        );
        print(jsonEncode(userModel));
        await _users.doc(userCredential.user!.uid).set(userModel.toJson());
      }else{
        userModel = await getUserData(userCredential.user!.uid).first;
        print("Old User");
      }
     /// for return the success message without any exception
     return right(userModel);
    }on FirebaseAuthException catch(e){
      throw e.message!;
    }catch(e){
      /// for return the failure message with an Failure message
      return left(Failure(e.toString()));
    }
  }


  Stream<UserModel> getUserData(String uid){
    return _users.doc(uid).snapshots().map((event){
      return UserModel.fromMap(event.data() as Map<String,dynamic>);
    });
  }


}
