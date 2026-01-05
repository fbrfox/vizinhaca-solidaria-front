import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vizinhanca_solidaria/address/presentation/pages/address_data_register_page.dart';
import 'package:vizinhanca_solidaria/address/presentation/pages/address_register_page.dart';
import 'package:vizinhanca_solidaria/alert/category/domain/entities/category.dart';
import 'package:vizinhanca_solidaria/alert/create/presentation/blocs/create_alert_bloc.dart';
import 'package:vizinhanca_solidaria/alert/create/presentation/pages/create_alert_page.dart';
import 'package:vizinhanca_solidaria/core/di/injection_container.dart';
import 'package:vizinhanca_solidaria/core/ui/colors.dart';
import 'package:vizinhanca_solidaria/firebase_options.dart';
import 'package:vizinhanca_solidaria/home/presentation/blocs/home_bloc.dart';
import 'package:vizinhanca_solidaria/home/presentation/pages/home_page.dart';
import 'package:vizinhanca_solidaria/login/presentation/pages/login_page.dart';
import 'package:vizinhanca_solidaria/register/presentation/pages/register_page.dart';
import 'package:vizinhanca_solidaria/splash/presentation/pages/splash_page.dart';
import 'package:vizinhanca_solidaria/walkthrough/presentation/pages/walkthrough_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Carrega o arquivo .env baseado na variável de ambiente ENV
  // Padrão: development, mas pode ser definido como 'production' via --dart-define=ENV=production
  const env = String.fromEnvironment('ENV', defaultValue: 'development');
  final envFile = env == 'production' 
      ? 'assets/.env.production' 
      : 'assets/.env.development';
  
  await dotenv.load(fileName: envFile);
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vizinhança Solidária',
        home: const SplashPage(), // Define a SplashPage como rota inicial
        routes: {
          // Define as rotas
          '/walkthrough': (context) => const WalkthroughPage(),
          '/register': (context) => const RegisterPage(),
          '/login': (context) => const LoginPage(),
          '/address': (context) => const AddressRegisterPage(),
          '/addressRegister': (context) => AddressDataRegisterPage(
                location: ModalRoute.of(context)!.settings.arguments as LatLng,
              ),
          '/home': (context) => BlocProvider<HomeBloc>(
                create: (context) => sl<HomeBloc>(),
                child: const HomePage(),
              ), // Substitua HomePage pela sua tela principal
          'alert/create': (context) => BlocProvider<CreateAlertBloc>(
              create: (context) => sl<CreateAlertBloc>(),
              child: CreateAlertPage(
                  category:
                      ModalRoute.of(context)!.settings.arguments as Category))
        },
        theme: ThemeData(
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: Colors.white,
            hintColor: primaryColor,
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.teal, accentColor: primaryColor),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: primaryColor, // Defina a cor desejada aqui
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            inputDecorationTheme: InputDecorationTheme(
              // Cor da label quando o campo NÃO está em foco
              labelStyle: TextStyle(color: primaryColor),
              // Cor da linha quando o campo NÃO está em foco
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              // Cor da label quando o campo está em foco
              focusColor: primaryColor,
              // Cor da linha quando o campo está em foco
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 5, // Define a elevação do Card
              shadowColor: Colors.grey
                  .withAlpha((255.0 * 0.5).round()), // Define a cor da sombra
              color: Colors.grey[80], // Define a cor do Card
              // ... outras propriedades do Card
            )));
  }
}
