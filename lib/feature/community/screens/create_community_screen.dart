import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/feature/community/controller/controller.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:reddit_app/widgets/loader.dart';


class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {

  final communityController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    communityController.dispose();
  }

  void crateCommunity(){
    ref.watch(communityControllerProvider.notifier).createCommunity(communityController.text.trim(), context);
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title:const Text("Create Community"),
      ),
      body:isLoading?const Loader(): Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Community Name"),
            const SizedBox(height: 10),
            TextFormField(
              controller: communityController,
              autofocus: false,
              decoration:const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Pallete.drawerColor,
                contentPadding: EdgeInsets.all(18),
                hintText: "r/community-name"
              ),
              maxLength: 21,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: (){
                if(communityController.text.isNotEmpty){
                  crateCommunity();
                }else{
                  showSnackBar(context, "Please Enter Details");
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize:const Size(double.infinity, 50),
                backgroundColor:Colors.blue,
              ),
              child:const Text("Create Community",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
