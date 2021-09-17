import 'package:social_app/shared/components/shared_preferences_keys.dart';
import 'package:social_app/shared/local/CachHelper.dart';

final emailRegex =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
String get uid => CacheHelper.getData(key: uidKey);