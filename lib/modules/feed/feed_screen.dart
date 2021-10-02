import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/main.dart';
import 'package:social_app/modules/feed/feed_provider.dart';
import 'package:social_app/modules/post/post_screen.dart';
import 'package:social_app/modules/settings/settings_provider.dart';
import 'package:social_app/shared/components/reuseable_components.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  //
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: feedProvider..getPosts(),
      builder: (context, _) => Consumer<FeedProvider>(
        builder: (context, feedProvider, _) => RefreshIndicator(
          onRefresh: () async {
            feedProvider.getPosts();
          },
          child: ListView.builder(
            itemCount: feedProvider.posts.length,
            itemBuilder: (context, index) {
              final posts = feedProvider.posts;
              try {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(value: feedProvider, child: PostScreen(index: index)),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(backgroundImage: NetworkImage(posts[index].userImage), radius: 24),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(posts[index].userName, style: getTextTheme(context).bodyText1?.copyWith(fontSize: 16)),
                                  SizedBox(height: 8),
                                  Text(posts[index].dateTime, style: getTextTheme(context).caption),
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
                                  posts[index].text.length < 100 ? posts[index].text : posts[index].text.substring(100) + '...',
                                  style: getTextTheme(context).bodyText1,
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: List.generate(
                                      posts[index].hashtags.length,
                                      (indexHash) =>
                                          Text('#${posts[index].hashtags[indexHash]} ', style: getTextTheme(context).bodyText1?.copyWith(color: Colors.blue)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (posts[index].text.length > 100) TextButton(onPressed: () {}, child: Text('Read more')),
                          Column(children: [
                            if (posts[index].images.length == 1)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.network(
                                  posts[index].images[0],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: (MediaQuery.of(context).size.width - 100) / 3,
                                      width: (MediaQuery.of(context).size.width - 100) / 3,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  },
                                ),
                              ),
                            if (posts[index].images.length > 1 && posts[index].images.length < 10)
                              Wrap(
                                children: List.generate(
                                  posts[index].images.length,
                                  (indexImages) => Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.network(
                                      posts[index].images[indexImages],
                                      fit: BoxFit.cover,
                                      width: (MediaQuery.of(context).size.width - 100) / 3,
                                      height: (MediaQuery.of(context).size.width - 100) / 3,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          height: (MediaQuery.of(context).size.width - 100) / 3,
                                          width: (MediaQuery.of(context).size.width - 100) / 3,
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            if (posts[index].images.length >= 10)
                              Wrap(children: [
                                for (var indexImages = 0; indexImages < 8; indexImages++)
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.network(
                                      posts[index].images[indexImages],
                                      fit: BoxFit.cover,
                                      width: (MediaQuery.of(context).size.width - 100) / 3,
                                      height: (MediaQuery.of(context).size.width - 100) / 3,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          height: (MediaQuery.of(context).size.width - 100) / 3,
                                          width: (MediaQuery.of(context).size.width - 100) / 3,
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      },
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width - 100) / 3,
                                    height: (MediaQuery.of(context).size.width - 100) / 3,
                                    color: Colors.grey,
                                    child: Center(child: Text('More images', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                  ),
                                )
                              ]),
                          ]),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.red, size: 20.0),
                              Text(' ${posts[index].likesNum} likes', style: getTextTheme(context).bodyText2),
                              Spacer(),
                              Icon(Icons.mode_comment_outlined, color: Colors.blue, size: 20),
                            ],
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
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.send, color: Colors.blue),
                                          onPressed: () async {
                                            final result = await feedProvider.likePost(index);
                                            if (result != 'success') {
                                              showSnackbar(context, 'an error occurred');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(posts[index].isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                                onPressed: () async {
                                  final result = await feedProvider.likePost(index);
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
                );
              } catch (e) {
                return Center(child: Text('Loading'));
              }
            },
          ),
        ),
      ),
    );
  }
}
