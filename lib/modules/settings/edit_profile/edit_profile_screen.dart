import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/modules/settings/settings_provider.dart';
import 'package:social_app/shared/components/reuseable_components.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<SettingsProvider>(context, listen: false).userModel;
    nameController.text = userModel?.name! ?? '';
    bioController.text = userModel?.bio! ?? '';
    phoneController.text = userModel?.phone! ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) => TextButton(
              child: settingsProvider.isPageLoading ? Center(child: CircularProgressIndicator()) : Text('UPDATE'),
              onPressed: settingsProvider.isPageLoading
                  ? null
                  : () async {
                      final result = await settingsProvider.updateUser(
                        name: nameController.text.trim(),
                        bio: bioController.text.trim(),
                        phone: phoneController.text.trim(),
                      );
                      if (result == 'error') {
                        showSnackbar(context, 'an error occurred');
                      } else {
                        showSnackbar(context, 'success');
                      }
                    },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                          : Uri.parse(settingsProvider.coverImage).isAbsolute
                              ? Image.network(settingsProvider.coverImage, fit: BoxFit.cover)
                              : Image.file(File(settingsProvider.coverImage), fit: BoxFit.cover),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Consumer<SettingsProvider>(
                      builder: (context, settingsProvider, _) => CircleAvatar(
                        child: IconButton(
                          icon: Icon(Icons.camera_alt_outlined),
                          onPressed: settingsProvider.isPageLoading
                              ? null
                              : () async {
                                  final coverImage = await settingsProvider.pickCoverImage();
                                  if (coverImage == 'error') showSnackbar(context, 'an error occurred');
                                },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          radius: 70,
                          child: Consumer<SettingsProvider>(
                              builder: (context, settingsProvider, _) => settingsProvider.userModel == null
                                  ? Center(child: CircularProgressIndicator())
                                  : Uri.parse(settingsProvider.profileImage).isAbsolute
                                      ? CircleAvatar(backgroundImage: NetworkImage(settingsProvider.userModel?.image ?? ''), radius: 66)
                                      : CircleAvatar(backgroundImage: FileImage(File(settingsProvider.profileImage)), radius: 66)),
                        ),
                        Consumer<SettingsProvider>(
                          builder: (context, settingsProvider, _) => CircleAvatar(
                            child: IconButton(
                              icon: Icon(Icons.camera_alt_outlined),
                              onPressed: settingsProvider.isPageLoading
                                  ? null
                                  : () async {
                                      final profileImage = await settingsProvider.pickProfileImage();
                                      if (profileImage == 'error') showSnackbar(context, 'an error occurred');
                                    },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            defaultFormField(context: context, label: 'name', inputType: TextInputType.name, controller: nameController),
            SizedBox(height: 8.0),
            defaultFormField(context: context, label: 'bio', inputType: TextInputType.text, controller: bioController),
            SizedBox(height: 8.0),
            defaultFormField(context: context, label: 'phone', inputType: TextInputType.phone, controller: phoneController),
          ],
        ),
      ),
    );
  }
}
