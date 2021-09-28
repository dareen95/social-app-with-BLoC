import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/modules/feed/feed_provider.dart';
import 'package:social_app/modules/settings/settings_provider.dart';
import 'package:social_app/shared/components/reuseable_components.dart';

class PostScreen extends StatefulWidget {
  final int index;

  PostScreen({Key? key, required this.index}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final commentController = TextEditingController();

  @override
  void initState() {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    feedProvider.getComments(feedProvider.posts[widget.index].postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, _) {
        final posts = feedProvider.posts;
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(posts[widget.index].userImage), radius: 24),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(posts[widget.index].userName, style: getTextTheme(context).bodyText1?.copyWith(fontSize: 16)),
                            SizedBox(height: 8),
                            Text(posts[widget.index].dateTime, style: getTextTheme(context).caption),
                          ],
                        ),
                        Spacer(),
                        IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            posts[widget.index].text.length < 100 ? posts[widget.index].text : posts[widget.index].text.substring(100) + '...',
                            style: getTextTheme(context).bodyText1,
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: List.generate(
                                posts[widget.index].hashtags.length,
                                (indexHash) =>
                                    Text('#${posts[widget.index].hashtags[indexHash]} ', style: getTextTheme(context).bodyText1?.copyWith(color: Colors.blue)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (posts[widget.index].text.length > 100) TextButton(onPressed: () {}, child: Text('Read more')),
                    Wrap(
                      children: List.generate(
                        posts[widget.index].images.length,
                        (indexImages) => Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.network(
                            posts[widget.index].images[indexImages],
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red, size: 20.0),
                        Text(' ${posts[widget.index].likesNum} likes', style: getTextTheme(context).bodyText2),
                        Spacer(),
                        Icon(Icons.mode_comment_outlined, color: Colors.blue, size: 20),
                        Text(' ${feedProvider.postComments.length} comments', style: getTextTheme(context).bodyText2),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: List.generate(
                        feedProvider.postComments.length,
                        (index) {
                          final comment = feedProvider.postComments[index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(backgroundImage: NetworkImage(comment.userImage), radius: 18),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        padding: EdgeInsetsDirectional.only(start: 8.0),
                                        constraints: BoxConstraints(minHeight: 50),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                        ),
                                        child: Text(comment.text),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        CircleAvatar(backgroundImage: NetworkImage(userModel?.image ?? ''), radius: 18),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              padding: EdgeInsetsDirectional.only(start: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  border: Border.all(width: 1.0, color: Colors.grey[200]!)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(hintText: 'Write a comment..', border: InputBorder.none),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      controller: commentController,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send, color: Colors.blue),
                                    onPressed: () async {
                                      final result = await feedProvider.createComment(
                                          postId: feedProvider.posts[widget.index].postId, text: commentController.text.trim());
                                      if (result == 'success') {
                                        commentController.clear();
                                      }
                                      showSnackbar(context, result);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(posts[widget.index].isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                          onPressed: () async {
                            final result = await feedProvider.likePost(widget.index);
                            if (result != 'success') {
                              showSnackbar(context, 'an error occurred');
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
