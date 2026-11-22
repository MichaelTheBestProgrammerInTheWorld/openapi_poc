import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api/generated/api/user_api.dart';
import 'core/network/dio_client.dart';
import 'features/user/data/datasources/user_remote_datasource.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/domain/usecases/get_user_usecase.dart';
import 'features/user/presentation/bloc/user_bloc.dart';
import 'features/user/presentation/pages/user_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Clean Architecture Dependency Injection Setup
    // 1. Core Network Client (Dio)
    final dio = DioClientFactory.createDio();

    // 2. Generated OpenAPI API Service (Dio)
    final userApi = UserApi(dio);

    // 3. Data Layer (Remote Data Source & Repository Implementation)
    final UserRemoteDataSource remoteDataSource = UserRemoteDataSourceImpl(userApi);
    final UserRepository userRepository = UserRepositoryImpl(remoteDataSource);

    // 4. Domain Layer (Use Case)
    final getUserUseCase = GetUserUseCase(userRepository);

    return MaterialApp(
      title: 'OpenAPI Generator POC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => UserBloc(getUserUseCase: getUserUseCase),
        child: const UserPage(),
      ),
    );
  }
}
