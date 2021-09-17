import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/main.dart';
import 'package:social_app/modules/settings/settings_provider.dart';
import 'package:social_app/shared/components/reuseable_components.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<SettingsProvider>(context, listen: false).getUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 270,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: Consumer<SettingsProvider>(
                  builder: (context, settingsProvider, _) => settingsProvider.userModel == null
                      ? Center(child: CircularProgressIndicator())
                      : Image.network(
                          settingsProvider.userModel?.cover ?? '',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  radius: 70,
                  child: Consumer<SettingsProvider>(
                    builder: (context, settingsProvider, _) => settingsProvider.userModel == null
                        ? Center(child: CircularProgressIndicator())
                        : CircleAvatar(
                            backgroundImage: NetworkImage(settingsProvider.userModel?.image ?? ''),
                            radius: 66,
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) => settingsProvider.userModel == null
                ? Container(width: 10, height: 10, child: Center(child: CircularProgressIndicator()))
                : Text(settingsProvider.userModel?.name ?? '', style: getTextTheme(context).subtitle1)),
        Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) => settingsProvider.userModel == null
                ? Container(width: 10, height: 10, child: Center(child: CircularProgressIndicator()))
                : Text(settingsProvider.userModel?.bio ?? '', style: getTextTheme(context).caption, maxLines: 2)),
        SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('100\nPosts', style: getTextTheme(context).bodyText1?.copyWith(height: 1.5), textAlign: TextAlign.center),
            Text('64\nFriends', style: getTextTheme(context).bodyText1?.copyWith(height: 1.5), textAlign: TextAlign.center),
            Text('32\nFollowing', style: getTextTheme(context).bodyText1?.copyWith(height: 1.5), textAlign: TextAlign.center),
            Text('10K\nFollowers', style: getTextTheme(context).bodyText1?.copyWith(height: 1.5), textAlign: TextAlign.center),
          ],
        ),
        Spacer(),
        Container(
          width: double.infinity,
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(child: Text('Edit Profile'), onPressed: () {
            navigateTo(context, editProfileRouteName);
          }),
        ),
      ],
    );
  }
}
