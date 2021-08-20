import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/settings/main_settings/settings_states.dart';

class SettingsCubit extends Cubit<SettingsStates> {
  BuildContext context;
  SettingsCubit(this.context) : super(SettingsInitialState());

  static SettingsCubit of(context) => BlocProvider.of<SettingsCubit>(context);
}
