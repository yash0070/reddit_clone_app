import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/feature/auth/controller/auth_controller.dart';
import 'package:reddit_app/feature/drawers/community_list_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  openDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title:const Text("Home"),
        leading: Builder(builder: (context){
          return IconButton(
            onPressed: ()=> openDrawer(context),
            icon:const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: (){},
            icon:const Icon(Icons.search),
          ),
          IconButton(
            onPressed: (){},
            icon:CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic!),
            )
          ),
        ],
      ),
      drawer: CommunityListDrawer(),
    );
  }
}
