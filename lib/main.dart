import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';



import 'package:flutter_bloc_dio/features/users/data/datasources/user_remote_datasource.dart';
import 'package:flutter_bloc_dio/features/users/data/repositories/user_repository.dart';
import 'package:flutter_bloc_dio/features/users/presentation/bloc/user_bloc.dart';
import 'package:flutter_bloc_dio/features/users/presentation/bloc/user_event.dart';
import 'package:flutter_bloc_dio/features/users/presentation/screens/home_screen.dart';

void main() {
  
  final Dio dio = Dio(); 
  final UserRemoteDataSource dataSource = UserRemoteDataSource(dio);
  final UserRepository userRepository = UserRepository(dataSource);

  runApp(
   
    BlocProvider(
      create: (context) => UserBloc(repository: userRepository)..add(FetchUsersEvent()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
          primary: Colors.indigoAccent,
          secondary: Colors.amberAccent,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      
      home: const HomeScreen(), 
    );
  }
}