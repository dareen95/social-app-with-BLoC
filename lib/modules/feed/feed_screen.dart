import 'package:flutter/material.dart';
import 'package:social_app/shared/components/reuseable_components.dart';

final bodyT =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // buildTopCard(context),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: List.generate(
              5,
              (index) => Card(
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
                            ),
                            radius: 24,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mohamed Ahmed Shalabi', style: getTextTheme(context).bodyText1?.copyWith(fontSize: 16)),
                              SizedBox(height: 8),
                              Text('January 21, 2021 at 11:00 PM', style: getTextTheme(context).caption),
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
                          children: [
                            Text(
                              bodyT.length < 100 ? bodyT : bodyT.substring(100) + '...',
                              style: getTextTheme(context).bodyText1,
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: List.generate(
                                  4,
                                  (index) => Text('#Technology ', style: getTextTheme(context).bodyText1?.copyWith(color: Colors.blue)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (bodyT.length > 100) TextButton(onPressed: () {}, child: Text('Read more')),
                      Image.network(
                        'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red, size: 20.0),
                          Text(' 180 likes', style: getTextTheme(context).bodyText2),
                          Spacer(),
                          Icon(Icons.mode_comment_outlined, color: Colors.blue, size: 20),
                          Text(' 76 comments', style: getTextTheme(context).bodyText2),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
                            ),
                            radius: 18,
                          ),
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
                                child: TextField(
                                  decoration: InputDecoration(hintText: 'Write a comment..', border: InputBorder.none),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                ),
                              ),
                            ),
                          ),
                          Icon(Icons.favorite, color: Colors.red),
                          Text('  Like'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Container buildTopCard(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.network(
              'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
