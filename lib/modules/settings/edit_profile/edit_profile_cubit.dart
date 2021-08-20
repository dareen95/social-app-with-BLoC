import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:social_app/modules/settings/edit_profile/edit_profile_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfileCubit extends Cubit<EditProfileStates> {
  EditProfileCubit() : super(EditProfileInitialState());

  static EditProfileCubit of(context) => BlocProvider.of<EditProfileCubit>(context);

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  File? profilePhoto;
  void setProfilePhoto(String? profilePhotoPath) {
    if (profilePhotoPath != null) {
      profilePhoto = File(profilePhotoPath);
      emit(EditProfilePhotoTempState());
    }
  }

  File? coverPhoto;
  void setCoverPhoto(String? coverPhotoPath) {
    if (coverPhotoPath != null) {
      coverPhoto = File(coverPhotoPath);
      emit(EditProfileCoverTempState());
    }
  }

  void uploadProfilePhoto(
    String? uid,
    void Function() whenComplete,
  ) {
    if (uid != null) {
      try {
        storage
            .ref()
            .child('users/')
            .child('$uid/${uid}_profile.png')
            .putFile(File(profilePhoto!.path))
            .whenComplete(whenComplete);
      } catch (e, s) {
        print(e);
        print(s);
      }
    } else {}
  }

  void uploadCoverPhoto(
    String? uid,
    void Function() whenComplete,
  ) {
    if (uid != null) {
      try {
        storage.ref().child('users/').child('$uid/${uid}_cover.png').putFile(File(coverPhoto!.path)).then(
          (snapshot) {
            whenComplete();
          },
        );
      } catch (e, s) {
        print(e);
        print(s);
      }
    } else {}
  }

  void upload({
    required String? uid,
    required String? name,
    required String? bio,
    required String? phone,
  }) async {
    try {
      emit(EditProfileLoadingState());

      if (profilePhoto != null) {
        uploadProfilePhoto(
          uid,
          () async {
            String profileLink = await firebase_storage.FirebaseStorage.instance
                .ref()
                .child('/users')
                .child(
                  '$uid/${uid}_profile.png',
                )
                .getDownloadURL();
            FirebaseFirestore.instance.collection('/users').doc(uid).update({'image': profileLink});
          },
        );
      }

      if (coverPhoto != null) {
        uploadCoverPhoto(
          uid,
          () async {
            String coverLink = await firebase_storage.FirebaseStorage.instance
                .ref()
                .child('/users')
                .child(
                  '$uid/${uid}_cover.png',
                )
                .getDownloadURL();
            FirebaseFirestore.instance.collection('/users').doc(uid).update({'cover': coverLink});
          },
        );
      }
      await FirebaseFirestore.instance.collection('/users').doc(uid).update(
        {
          'bio': bio,
          'name': name,
          'phone': phone,
        },
      );
      emit(EditProfileSuccessfulState());
    } catch (e, s) {
      print(e);
      print(s);
      emit(EditProfileFailedState());
    }
  }
}
