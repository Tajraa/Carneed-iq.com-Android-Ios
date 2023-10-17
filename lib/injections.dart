import 'package:get_it/get_it.dart';

import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:progiom_cms/notifications.dart';
import 'package:tajra/Ui/Blog/data/datasources/HomeSettingsApi.dart';
import 'package:tajra/Ui/Blog/data/repositories/settings_repo_impl.dart';
import 'package:tajra/Ui/Blog/presentation/bloc/bloc.dart';
import './/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'App/App.dart';
import 'Ui/Blog/domain/repositories/settings_repository.dart';
import 'data/httpService/http_Service.dart';
import 'data/repository/Repository.dart';
import 'data/sharedPreferences/SharedPrefHelper.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  sl.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  await sl.isReady<SharedPreferences>();

  // dio , logger   // depend on shredPreferences.
  await initAuthInjection(
      BaseUrl,
      SecretModel(
        ClientPasswordSecret: ClientPasswordSecret,
        ClientPasswordId: ClientPasswordId,
        ClientPersonalSecret: ClientPersonalSecret,
        ClientPersonalId: ClientPersonalId,
      ), () {
    navigatorKey.currentState?.pushReplacementNamed("/login", arguments: false);
  });

  // depend on shredpreferences and dio.
  initSettingsInjections();
  initEcommerceInjections();
  initNotificationsInjections();

  sl.registerLazySingleton<HomesettingsBloc>(() => HomesettingsBloc());

  sl.registerLazySingleton<BlogApi>(() => BlogApi());

  sl.registerLazySingleton<BlogRepository>(() => BlogRepositoryImpl(
        sl(),
      ));

  sl.registerLazySingleton<PrefsHelper>(() => PrefsHelper.pref);
  sl.registerLazySingleton<HttpSerivce>(() => HttpSerivce());
  sl.registerLazySingleton<Repository>(() => Repository(sl(), sl()));
  return;
}
