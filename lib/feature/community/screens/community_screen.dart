import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/feature/auth/controller/auth_controller.dart';
import 'package:reddit_app/feature/community/controller/controller.dart';
import 'package:reddit_app/widgets/error_text_widget.dart';
import 'package:reddit_app/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context){
    Routemaster.of(context).push('/mod-tools');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: ref.watch(userCommunityByNameProvider(name)).when(
          data: (community){
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxScrolled){
                  return [
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                              child: Image.network(community.banner,fit: BoxFit.cover),
                          )
                        ],
                      ),
                    ),
                    SliverPadding(
                        padding:const EdgeInsets.all(10),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 35,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('r/${community.name}',style:const TextStyle(fontSize: 19,fontWeight: FontWeight.bold)),
                                community.mods.contains(user!.uid)?
                                OutlinedButton(
                                    onPressed: (){
                                      navigateToModTools(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child:const Text("Mod Tools",style: TextStyle(fontSize: 12,color: Colors.blue),
                                )):OutlinedButton(
                                    onPressed: (){},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                    ),
                                    child:Text(community.members.contains(user.uid)?"Joined": "Join",style: TextStyle(fontSize: 12,color: Colors.blue),
                                    )),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text("${community.members.length} members")

                          ]
                        ),

                      ),
                    )
                  ];
                },
                body: Text("Detaile"),
            );
          },
          error: (error,stk) => ErrorText(error: error.toString()),
          loading: ()=> const Loader(),
      )
    );
  }
}
