import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:stray_bookstore_app/app/core/router_manager.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';

final inject = GetIt.instance;

void setup() {
  inject.registerLazySingleton<Dio>(() => Dio());

  inject.registerLazySingleton<AuthRepository>(() => AuthRepository());

  inject.registerLazySingleton<FriendRepository>(() => FriendRepository());

  inject.registerFactory<RouterManager>(() => RouterManager());
}
