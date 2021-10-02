import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/modules/feed/feed_provider.dart';
import 'package:social_app/modules/new_post/new_post_provider.dart';
import 'package:social_app/modules/settings/settings_provider.dart';
import 'package:social_app/shared/components/reuseable_components.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<NewPostProvider>(
      builder: (context, postProvider, _) => WillPopScope(
        onWillPop: () async {
          postProvider.emptyImages();
          Provider.of<FeedProvider>(context, listen: false).getPosts();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create Post'),
            actions: [
              TextButton(
                child: postProvider.isLoading ? Center(child: CircularProgressIndicator()) : Text('POST'),
                onPressed: postProvider.isLoading
                    ? null
                    : () async {
                        //TODO: Add hashtags
                        final result =
                            await postProvider.createPost(dateTime: DateTime.now().toString(), text: postTextController.text.trim(), hashtags: ['Technology']);
                        if (result == 'success') {
                          showSnackbar(context, 'post created successfully');

                          Navigator.of(context).pop();
                        } else {
                          showSnackbar(context, 'an error occurred');
                        }
                      },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(userModel?.image ?? ''), radius: 24),
                      SizedBox(width: 15.0),
                      Text(userModel?.name ?? '', style: TextStyle(height: 1.4, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: TextFormField(
                      enabled: !postProvider.isLoading,
                      controller: postTextController,
                      decoration: InputDecoration(
                        hintText: 'what is on your mind ...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (postProvider.postImages.isNotEmpty)
                    Container(
                      height: 160,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: postProvider.postImages.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Stack(
                            children: [
                              Image.file(
                                File(postProvider.postImages[index]),
                                fit: BoxFit.cover,
                              ),
                              if (!postProvider.isLoading) IconButton(icon: Icon(Icons.close), onPressed: () => postProvider.removeImage(index)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            postProvider.addImages();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, color: Colors.blue),
                              SizedBox(width: 10),
                              Text('Add photos', style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(onPressed: () {}, child: Text('#tags')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
