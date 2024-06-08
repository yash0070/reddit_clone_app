import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/models/community_model.dart';
import 'package:reddit_app/core/types_def.dart';
import 'package:reddit_app/provider/firebase_provider/firebase_provider.dart';

final communityRepositoryProvider = Provider((ref){
  return CommunityRepository(fireStore: ref.watch(firebaseFirestoreProvider));
});

class CommunityRepository{
  final FirebaseFirestore _fireStore;
  CommunityRepository({required FirebaseFirestore fireStore}): _fireStore = fireStore;


  CollectionReference get _communities => _fireStore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(Community model) async{
    try{
      final communityDoc = await _communities.doc(model.name).get();
      if(communityDoc.exists){
        throw 'Community with the same name already exists!';
      }
      
     return right(_communities.doc(model.name).set(model.toMap()));
    }on FirebaseException catch(e) {
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  /// function for get all the communities
  Stream<List<Community>> getUserCommunities(String uid){
    return _communities.where('members',arrayContains: uid).snapshots().map((event){
      List<Community> community = [];
      for(var doc in event.docs){
        community.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return community;
    });
  }

  /// function for get the community by the name
 Stream<Community> getCommunityByName(String name){
    return _communities.doc(name).snapshots().map((event) => Community.fromMap(event.data() as Map<String,dynamic>));
 }
}