import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/balance_screen.dart';
import 'screens/create_item_screen.dart';
import 'screens/transactions/transactions_list_screen.dart';
import 'screens/login_screen.dart';
import 'services/transaction_service.dart';
import 'services/category_service.dart';
import 'services/account_service.dart';
import 'models/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TransactionService().init();
  await CategoryService().init();
  await AccountService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DetaGastos',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      locale: const Locale('es', 'ES'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(4, 60, 92, 1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
        '/transactions': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return TransactionsListScreen(
            type: args['type'] == 'expense'
                ? TransactionType.expense
                : TransactionType.income,
            title: args['type'] == 'expense' ? 'Gastos' : 'Ingresos',
          );
        },
        '/create': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>?;
          return CreateItemScreen(
            initialType: args?['type'] == 'expense'
                ? TransactionType.expense
                : TransactionType.income,
          );
        },
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  TransactionType? _createType;

  static List<Widget> _screens = [];

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Inicio',
    ),
    NavigationDestination(
      icon: Icon(Icons.bar_chart_outlined),
      selectedIcon: Icon(Icons.bar_chart),
      label: 'Estadísticas',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_balance_wallet_outlined),
      selectedIcon: Icon(Icons.account_balance_wallet),
      label: 'Balance',
    ),
    NavigationDestination(
      icon: Icon(Icons.add_circle_outline),
      selectedIcon: Icon(Icons.add_circle),
      label: 'Crear',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
    // Obtener los argumentos de navegación si existen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args.containsKey('selectedIndex')) {
          setState(() {
            _selectedIndex = args['selectedIndex'] as int;
          });
        }
        if (args.containsKey('createType')) {
          setState(() {
            _createType = args['createType'] == 'expense'
                ? TransactionType.expense
                : TransactionType.income;
          });
          _initializeScreens();
        }
      }
    });
  }

  void _initializeScreens() {
    _screens = [
      const HomeScreen(),
      const StatisticsScreen(),
      const BalanceScreen(),
      CreateItemScreen(initialType: _createType),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
            if (index != 3) {
              _createType = null;
              _initializeScreens();
            }
          });
        },
        destinations: _destinations,
      ),
    );
  }
}
