import 'package:get_it/get_it.dart';
import 'package:clean_starter/core/network/api_client.dart';
import 'package:clean_starter/core/services/navigation_service.dart';
import 'package:clean_starter/env/flavor_config.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  _registerServices();
  _registerUseCases();
  _registerRepositories();
  _registerProviders();
}

void _registerServices() {
  getIt.registerSingleton(NavigationService());
  getIt.registerLazySingleton(
    () => ApiClient(baseUrl: FlavorConfig.instance.values.baseUrl),
  );
}

void _registerUseCases() {}

void _registerRepositories() {}

void _registerProviders() {}
