import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/constants/app_images.dart';
import 'package:reddit_app/core/models/community_model.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/feature/auth/controller/auth_controller.dart';
import 'package:reddit_app/feature/community/repository/repository.dart';
import 'package:routemaster/routemaster.dart';

final userCommunityProvider = StreamProvider((ref){
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final userCommunityByNameProvider = StreamProvider.family((ref,String name){
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref){
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(communityRepository: communityRepository, ref: ref);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref}) :
        _communityRepository = communityRepository,
        _ref = ref, super(false);

  void createCommunity(String name, BuildContext context)async{
    state = true;
    final uid = _ref.read(userProvider)?.uid??'';
    Community community = Community(
      id: name,
      name: name,
      banner: AppImages.bannerDefault,
      avatar: AppImages.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final result = await _communityRepository.createCommunity(community);
    state = false;
    result.fold((l) => showSnackBar(context,l.message),
            (r) {
          showSnackBar(context,"Community Created Successfully");
          Routemaster.of(context).pop();
        });
  }

  /// get user community
 Stream<List<Community>> getUserCommunities(){
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid!);
 }

 /// get the community by name
 Stream<Community> getCommunityByName(String name){
    return _communityRepository.getCommunityByName(name);
 }

}