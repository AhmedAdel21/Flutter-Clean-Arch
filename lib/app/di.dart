import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temp/app/app_prefs.dart';
import 'package:temp/data/data_source/remote_data_source.dart';
import 'package:temp/data/network/app_api.dart';
import 'package:temp/data/network/dio_factory.dart';
import 'package:temp/data/network/network_info.dart';
import 'package:temp/data/repository/repository_impl.dart';
import 'package:temp/domain/repository/repository.dart';
import 'package:temp/domain/usecase/forget_password_usecase.dart';
import 'package:temp/domain/usecase/login_usecase.dart';
import 'package:temp/domain/usecase/register_usecase.dart';
import 'package:temp/presentation/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:temp/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:temp/presentation/register/viewmodel/register_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app prefs
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  // network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  // app service client
  final dio = await instance<DioFactory>().getDio;
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));

  // repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance()));
}

void initLoginModule() {
  if (!(GetIt.instance.isRegistered<LoginUseCase>())) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

void initForgetPasswordModule() {
  if (!(GetIt.instance.isRegistered<ForgetPasswordViewModel>())) {
    instance.registerFactory<ForgetPasswordUseCase>(
        () => ForgetPasswordUseCase(instance()));
    instance.registerFactory<ForgetPasswordViewModel>(
        () => ForgetPasswordViewModel(instance()));
  }
}

void initRegisterModule() {
  if (!(GetIt.instance.isRegistered<RegisterUseCase>())) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}
