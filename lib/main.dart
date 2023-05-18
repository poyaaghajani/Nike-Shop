import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nike/config/theme.dart';
import 'package:nike/core/widgets/main_screen.dart';
import 'package:nike/features/auth_feature/data/repository/auth_repository.dart';
import 'package:nike/features/home_feature/data/model/product.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox<Product>('favoriteBox');

  WidgetsFlutterBinding.ensureInitialized();
  authRepository.readAuthToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: MainScreen(),
      ),
    );
  }
}
