import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout_cubit.dart';
import 'package:social_app/modules/settings/edit_profile/edit_profile_cubit.dart';
import 'package:social_app/modules/settings/edit_profile/edit_profile_states.dart';
import 'package:social_app/shared/components/reuseable_components.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final homeLayoutCubit = ModalRoute.of(context)!.settings.arguments as HomeLayoutCubit;
    final userModel = homeLayoutCubit.userModel;

    nameController.text = userModel?.name ?? '';
    bioController.text = userModel?.bio ?? '';
    phoneController.text = userModel?.phone ?? '';

    return BlocProvider(
      create: (context) {
        return EditProfileCubit();
      },
      child: BlocConsumer<EditProfileCubit, EditProfileStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit profile'),
            ),
            body: ListView(
              children: [
                EditProfileImageAndCoverStack(homeLayoutCubit: homeLayoutCubit),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: defaultFormField(
                    context: context,
                    label: 'name',
                    inputType: TextInputType.name,
                    controller: nameController,
                    prefix: Icon(Icons.person_outline_outlined),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: defaultFormField(
                    context: context,
                    label: 'bio',
                    inputType: TextInputType.text,
                    controller: bioController,
                    prefix: Icon(Icons.warning_amber_outlined),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: defaultFormField(
                    context: context,
                    label: 'phone',
                    inputType: TextInputType.phone,
                    controller: phoneController,
                    prefix: Icon(Icons.call),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditProfileImageAndCoverStack extends StatelessWidget {
  EditProfileImageAndCoverStack({
    Key? key,
    required this.homeLayoutCubit,
  }) : super(key: key);

  final HomeLayoutCubit homeLayoutCubit;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  child: Image.network(homeLayoutCubit.userModel?.cover ?? '', fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    child: IconButton(
                      icon: Icon(Icons.camera_alt_outlined),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
        Positioned(
          bottom: 0,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(80)),
                height: 160,
                width: 160,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(homeLayoutCubit.userModel?.image ?? ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    child: IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: () async {
                    final XFile? image = await this.picker.pickImage(source: ImageSource.gallery);
                  },
                )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
