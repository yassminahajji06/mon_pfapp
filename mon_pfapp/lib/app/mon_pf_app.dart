import 'package:flutter/material.dart';

import 'package:mon_pfapp/core/constants.dart';
import 'package:mon_pfapp/data/demo_data.dart';
import 'package:mon_pfapp/domain/models/cart_item.dart';
import 'package:mon_pfapp/domain/models/menu_item.dart';
import 'package:mon_pfapp/domain/models/user_model.dart';
import 'package:mon_pfapp/features/auth/presentation/login_screen.dart';
import 'package:mon_pfapp/features/auth/presentation/register_screen.dart';
import 'package:mon_pfapp/features/client/presentation/cart_screen.dart';
import 'package:mon_pfapp/features/client/presentation/home_screen.dart';
import 'package:mon_pfapp/features/client/presentation/menu_screen.dart';
import 'package:mon_pfapp/features/client/presentation/orders_screen.dart';
import 'package:mon_pfapp/features/client/presentation/profile_screen.dart';
import 'package:mon_pfapp/features/client/presentation/tracking_screen.dart';
import 'package:mon_pfapp/features/operations/presentation/admin_dashboard_screen.dart';
import 'package:mon_pfapp/features/operations/presentation/driver_dashboard_screen.dart';
import 'package:mon_pfapp/shared/widgets/app_ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.red),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: AppColors.red,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MonPfApp(),
    );
  }
}

class MonPfApp extends StatefulWidget {
  const MonPfApp({super.key});

  @override
  State<MonPfApp> createState() => _MonPfAppState();
}

class _MonPfAppState extends State<MonPfApp> {
  String _screen = 'login';
  UserModel? _user;
  List<CartItem> _cart = [
    CartItem(item: DemoData.menuItems[2], quantity: 1),
    CartItem(item: DemoData.menuItems[0], quantity: 2),
    CartItem(item: DemoData.menuItems[6], quantity: 1),
  ];

  int get _cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  void _navigate(String screen) {
    setState(() => _screen = screen == 'orders' ? 'orders' : screen);
  }

  void _authenticate(UserModel user) {
    setState(() {
      _user = user;
      _screen = 'home';
    });
  }

  void _logout() {
    setState(() {
      _user = null;
      _screen = 'login';
    });
  }

  void _addToCart(MenuItem item) {
    final index = _cart.indexWhere((cartItem) => cartItem.item.id == item.id);
    setState(() {
      if (index == -1) {
        _cart = [..._cart, CartItem(item: item, quantity: 1)];
      } else {
        _cart = [
          for (var i = 0; i < _cart.length; i++)
            if (i == index)
              _cart[i].copyWith(quantity: _cart[i].quantity + 1)
            else
              _cart[i],
        ];
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} ajoute au panier'),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _updateQuantity(String itemId, int delta) {
    setState(() {
      _cart = [
        for (final cartItem in _cart)
          if (cartItem.item.id == itemId)
            cartItem.copyWith(
              quantity: (cartItem.quantity + delta).clamp(1, 99).toInt(),
            )
          else
            cartItem,
      ];
    });
  }

  void _removeFromCart(String itemId) {
    setState(
      () => _cart = _cart.where((item) => item.item.id != itemId).toList(),
    );
  }

  void _checkout() {
    setState(() => _screen = 'tracking');
  }

  @override
  Widget build(BuildContext context) {
    final user = _user ?? DemoData.demoUser;

    final screen = switch (_screen) {
      'register' => RegisterScreen(
        onAuthenticated: _authenticate,
        onLoginTap: () => _navigate('login'),
      ),
      'home' => HomeScreen(
        user: user,
        cartCount: _cartCount,
        onNavigate: _navigate,
        onAddToCart: _addToCart,
      ),
      'menu' => MenuScreen(
        cartCount: _cartCount,
        onNavigate: _navigate,
        onAddToCart: _addToCart,
      ),
      'cart' => CartScreen(
        items: _cart,
        onNavigate: _navigate,
        onIncrease: (item) => _updateQuantity(item.item.id, 1),
        onDecrease: (item) => _updateQuantity(item.item.id, -1),
        onRemove: (item) => _removeFromCart(item.item.id),
        onCheckout: _checkout,
      ),
      'tracking' => TrackingScreen(onNavigate: _navigate),
      'orders' => OrdersScreen(cartCount: _cartCount, onNavigate: _navigate),
      'profile' => ProfileScreen(
        user: user,
        cartCount: _cartCount,
        onNavigate: _navigate,
        onLogout: _logout,
      ),
      'driver' => DriverDashboardScreen(onNavigate: _navigate),
      'admin' => AdminDashboardScreen(onNavigate: _navigate),
      _ => LoginScreen(
        onAuthenticated: _authenticate,
        onRegisterTap: () => _navigate('register'),
      ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 340),
      reverseDuration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.035, 0.018),
              end: Offset.zero,
            ).animate(curved),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.985, end: 1).animate(curved),
              child: child,
            ),
          ),
        );
      },
      child: KeyedSubtree(key: ValueKey(_screen), child: screen),
    );
  }
}
