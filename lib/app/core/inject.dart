import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:stray_bookstore_app/app/core/root_context_holder.dart';
import 'package:stray_bookstore_app/app/core/router_manager.dart';
import 'package:stray_bookstore_app/app/repositories/auth_repository.dart';
import 'package:stray_bookstore_app/app/repositories/borrow_repository.dart';
import 'package:stray_bookstore_app/app/repositories/box_repository.dart';
import 'package:stray_bookstore_app/app/repositories/comic_repository.dart';
import 'package:stray_bookstore_app/app/repositories/friend_repository.dart';

final inject = GetIt.instance;

void setup() {
  final rootContextHolder = RootContextHolder();

  inject.registerSingleton<RootContextHolder>(rootContextHolder, instanceName: 'rootContext');

  inject.registerLazySingleton<Dio>(() => Dio());

  inject.registerLazySingleton<AuthRepository>(() => AuthRepository());

  inject.registerLazySingleton<FriendRepository>(() => FriendRepository());

  inject.registerLazySingleton<ComicRepository>(() => ComicRepository());

  inject.registerLazySingleton<BorrowRepository>(() => BorrowRepository());

  inject.registerLazySingleton<BoxRepository>(() => BoxRepository());

  inject.registerFactory<RouterManager>(() => RouterManager());
}
