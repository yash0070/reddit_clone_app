import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/models/community_model.dart';
import 'package:reddit_app/feature/community/controller/controller.dart';
import 'package:reddit_app/widgets/error_text_widget.dart';
import 'package:reddit_app/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';

import '../../theme/routes.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context){
    Routemaster.of(context).push(createCommunityScreenRoute);
  }

  void navigateToCommunityScreen(BuildContext context,Community community){
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title:const Text("Create a community"),
                leading:const Icon(Icons.add),
                onTap: ()=> navigateToCreateCommunity(context),
              ),
              
              ref.watch(userCommunityProvider).when(
                  data: (communities){
                    return Expanded(
                        child: ListView.builder(
                          itemCount: communities.length,
                          itemBuilder: (context,index){
                            final community = communities[index];
                            return ListTile(
                              title: Text('r/${community.name}'),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                              onTap:()=> navigateToCommunityScreen(context,community),
                            );
                          },
                        ),
                    );
                  },
                  error: (error,stackTrace) => ErrorText(error: error.toString()),
                  loading: ()=> const Loader()),
            ],
          )
      ),
    );
  }
}
