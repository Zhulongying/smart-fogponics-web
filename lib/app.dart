import 'package:flutter/material.dart';
import 'controllers/home_controller.dart';
import 'controllers/device_controller.dart';
import 'pages/home_page.dart';
import 'pages/control_page.dart';
import 'pages/analytics_page.dart';
import 'pages/settings_page.dart';

class SmartFogApp extends StatelessWidget {
  const SmartFogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Fogponics IoT',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2E7D32),
        useMaterial3: true,
        brightness: Brightness.light,
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
        ),
      ),
      home: const MainShell(),
    );
  }
}

/// Root shell — owns controllers and manages bottom navigation.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final HomeController _homeCtrl = HomeController();
  final DeviceController _deviceCtrl = DeviceController();

  static const _titles = ['首页', '控制', '数据', '设置'];

  @override
  void dispose() {
    _homeCtrl.dispose();
    _deviceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(homeCtrl: _homeCtrl, deviceCtrl: _deviceCtrl),
          ControlPage(deviceCtrl: _deviceCtrl),
          AnalyticsPage(homeCtrl: _homeCtrl),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        animationDuration: const Duration(milliseconds: 400),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.green),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.toggle_on_outlined),
            selectedIcon: Icon(Icons.toggle_on, color: Colors.green),
            label: '控制',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics, color: Colors.green),
            label: '数据',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Colors.green),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
