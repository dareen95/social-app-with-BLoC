import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/layout/home_layout_cubit.dart';
import 'package:social_app/layout/home_layout_states.dart';
import 'package:social_app/shared/components/reuseable_components.dart';
import 'package:hashtagable/hashtagable.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return HomeLayoutCubit()..getUserData();
      },
      child: BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            width: double.infinity,
            child: ListView(
              shrinkWrap: false,
              children: [
                buildTopCard(context),
                SizedBox(height: 16),
                Container(
                  width: (MediaQuery.of(context).size.width - 8),
                  child: Card(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildPostProfileImage(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Mohamed Ahmed Shalabi'),
                                    SizedBox(width: 4),
                                    Icon(Icons.check_circle, color: Colors.blue, size: 16),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'January 21, 2021, at 11:00 PM',
                                  style: getTextTheme(context).caption,
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(Icons.more_horiz),
                            SizedBox(width: 8)
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: HashTagText(
                            text:
                                '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. \n#Tecnology #Software #Computer_Science''',
                            basicStyle: getTextTheme(context).bodyText2!,
                            decoratedStyle: getTextTheme(context).bodyText2!.copyWith(color: Colors.blue),
                          ),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width - 8),
                          height: (MediaQuery.of(context).size.width - 8) * 9.0 / 13.0,
                          child: Image.network(
                            'https://image.freepik.com/free-photo/studio-shot-attractive-bearded-guy-posing-against-white-wall_273609-20600.jpg',
                            fit: BoxFit.cover,
                            cacheWidth: (MediaQuery.of(context).size.width - 8).toInt(),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        buildLikeAndCommentRow(context),
                        Divider(height: 0),
                        buildRightACommentRow(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Row buildRightACommentRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://image.freepik.com/free-photo/handsome-confident-smiling-man-with-hands-crossed-chest_176420-18743.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 120,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                hintText: 'Write a comment',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding buildLikeAndCommentRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.favorite_border, size: 24, color: Colors.red),
            onTap: () {},
          ),
          SizedBox(width: 4),
          Text('120', style: getTextTheme(context).bodyText1),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(Icons.comment_rounded, size: 24, color: Colors.grey[400]),
                SizedBox(width: 4),
                Text('120 comment', style: getTextTheme(context).caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPostProfileImage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(
              'https://image.freepik.com/free-photo/handsome-confident-smiling-man-with-hands-crossed-chest_176420-18743.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Stack buildTopCard(BuildContext context) {
    return Stack(
      children: [
        Card(
          child: Container(
            width: (MediaQuery.of(context).size.width - 8),
            height: (MediaQuery.of(context).size.width - 8) * 9.0 / 13.0,
            child: Image.network(
              'https://image.freepik.com/free-photo/studio-shot-attractive-bearded-guy-posing-against-white-wall_273609-20600.jpg',
              fit: BoxFit.cover,
              cacheWidth: (MediaQuery.of(context).size.width - 8).toInt(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
        Positioned(
          right: 64,
          top: 64,
          child: Text(
            'Communicate with friends',
            style: getTextTheme(context).bodyText1?.copyWith(color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }
}
