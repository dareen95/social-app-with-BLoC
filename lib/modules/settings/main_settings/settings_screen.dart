import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout_cubit.dart';
import 'package:social_app/main.dart';
import 'package:social_app/models/auth/user_model.dart';
import 'package:social_app/modules/settings/main_settings/settings_cubit.dart';
import 'package:social_app/modules/settings/main_settings/settings_states.dart';
import 'package:social_app/shared/components/reuseable_components.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return SettingsCubit(context);
      },
      child: BlocConsumer<SettingsCubit, SettingsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var homeLayoutCubit = HomeLayoutCubit.of(context);
          return RefreshIndicator(
            onRefresh: () async {
              await homeLayoutCubit.getUserData();
              homeLayoutCubit = HomeLayoutCubit.of(context);
              setState(() {});
            },
            child: Center(
              child: ListView(
                children: [
                  Container(
                    height: 300,
                    child: SettingsCoverAndImage(homeLayoutCubit: homeLayoutCubit),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: Text(
                      homeLayoutCubit.userModel?.name ?? '',
                      style: getTextTheme(context).headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: Text(
                      homeLayoutCubit.userModel?.bio ?? '',
                      style: getTextTheme(context).subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SettingsDataRow(),
                  Divider(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: () {}, child: Text('Add Post'))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: OutlinedButton(
                            onPressed: () => navigateTo(
                              context,
                              editProfileRouteName,
                              arguments: homeLayoutCubit,
                            ),
                            child: Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SettingsDataRow extends StatelessWidget {
  const SettingsDataRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text('100', style: getTextTheme(context).headline6),
              SizedBox(height: 8),
              Text('posts', style: getTextTheme(context).bodyText1),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text('265', style: getTextTheme(context).headline6),
              SizedBox(height: 8),
              Text('photos', style: getTextTheme(context).bodyText1),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text('10k', style: getTextTheme(context).headline6),
              SizedBox(height: 8),
              Text('followers', style: getTextTheme(context).bodyText1),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text('64', style: getTextTheme(context).headline6),
              SizedBox(height: 8),
              Text('following', style: getTextTheme(context).bodyText1),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsCoverAndImage extends StatelessWidget {
  const SettingsCoverAndImage({
    Key? key,
    required this.homeLayoutCubit,
  }) : super(key: key);

  final HomeLayoutCubit homeLayoutCubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 220,
              child: Image.network(homeLayoutCubit.userModel?.cover ?? '', fit: BoxFit.cover),
            ),
            const SizedBox(height: 60),
          ],
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(80)),
            height: 160,
            width: 160,
            child: CircleAvatar(
              backgroundImage: NetworkImage(homeLayoutCubit.userModel?.image ?? ''),
            ),
          ),
        )
      ],
    );
  }
}
