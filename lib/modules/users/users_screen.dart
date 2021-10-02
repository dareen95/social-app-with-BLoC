import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/main.dart';
import 'package:social_app/modules/users/users_provider.dart';
import 'package:social_app/shared/components/reuseable_components.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: userProvider..getUsers(),
      child: Consumer<UsersProvider>(
        builder: (context, usersProvider, _) => ListView.separated(
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              navigateTo(context, chatScreenRouteName, arguments: usersProvider.users[index]);
            },
            child: Row(
              children: [
                SizedBox(width: 16),
                CircleAvatar(radius: 24, backgroundImage: NetworkImage(usersProvider.users[index].image ?? '')),
                SizedBox(width: 16),
                Text(usersProvider.users[index].name ?? ''),
                SizedBox(width: 16),
              ],
            ),
          ),
          separatorBuilder: (context, index) => Divider(),
          itemCount: userProvider.users.length,
        ),
      ),
    );
  }
}
