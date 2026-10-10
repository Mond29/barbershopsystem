import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/dashboard_screen.dart';
import 'screens/services_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/products_screen.dart';
import 'screens/about_screen.dart';
import 'screens/hairstyle_guide_screen.dart';
import 'models/service.dart';
import 'data/sample_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF0F0F0F),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0F0F0F),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const BarbershopApp());
}

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gentleman Barbershop",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4A853),
          onPrimary: Color(0xFF0F0F0F),
          secondary: Color(0xFFB8892E),
          onSecondary: Color(0xFF0F0F0F),
          surface: Color(0xFF1A1A1A),
          onSurface: Colors.white,
          error: Colors.redAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F0F),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF1A1A1A),
          contentTextStyle: const TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF2A2A2A)),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  BarberService? _pendingService;
  Branch? _pendingBranch;
  final List<GlobalKey<NavigatorState>> _navKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _pushScreen(int tabIndex, Widget screen) {
    final ctx = _navKeys[tabIndex].currentContext;
    if (ctx == null) return;
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _navigateToIndex(int index, {BarberService? preselectedService, Branch? selectedBranch}) {
    if (index == 2) {
      _pendingService = preselectedService ?? _pendingService;
      _pendingBranch = selectedBranch ?? _pendingBranch;
    }
    if (_currentIndex == index) {
      _navKeys[index].currentState?.popUntil((r) => r.isFirst);
      setState(() {});
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _onBookService(int index, {BarberService? preselectedService}) {
    _pendingService = preselectedService;
    _pendingBranch = null;
    setState(() => _currentIndex = index);
  }

  void _onBookBranch(int index, {Branch? selectedBranch}) {
    _pendingBranch = selectedBranch;
    _pendingService = null;
    setState(() => _currentIndex = index);
  }

  void _onBookHairstyle(BarberService? service) {
    _pendingService = service ?? SampleData.services.firstWhere((s) => s.id == 'haircut-main');
    _pendingBranch = null;
    setState(() => _currentIndex = 2);
  }

  void _openProductsFromDashboard() {
    _pushScreen(0, const ProductsScreen());
  }

  void _openAboutFromDashboard() {
    _pushScreen(0, const AboutScreen());
  }

  void _openHairstyleFromDashboard() {
    _pushScreen(0, HairstyleGuideScreen(onBookHairstyle: _onBookHairstyle));
  }

  void _openHairstyleFromServices() {
    _pushScreen(1, HairstyleGuideScreen(onBookHairstyle: _onBookHairstyle));
  }

  @override
  Widget build(BuildContext context) {
    final bookingKey = ValueKey(
      'booking-${_pendingService?.id ?? 'svc-none'}-${_pendingBranch?.id ?? 'br-none'}',
    );

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildOffstageNavigator(
            0,
            DashboardScreen(
              onNavigate: _navigateToIndex,
              onOpenProducts: _openProductsFromDashboard,
              onOpenAbout: _openAboutFromDashboard,
              onOpenHairstyle: _openHairstyleFromDashboard,
            ),
          ),
          _buildOffstageNavigator(
            1,
            ServicesScreen(
              onBookService: _onBookService,
              onOpenHairstyle: _openHairstyleFromServices,
            ),
          ),
          _buildOffstageNavigator(
            2,
            BookingScreen(
              key: bookingKey,
              preselectedService: _pendingService,
              preselectedBranch: _pendingBranch,
            ),
          ),
          _buildOffstageNavigator(
            3,
            ContactsScreen(onBookBranch: _onBookBranch),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildOffstageNavigator(int index, Widget page) {
    return Navigator(
      key: _navKeys[index],
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => page,
      ),
      observers: [HeroController()],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(
          top: BorderSide(color: Color(0xFF1F1F1F), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, "Home"),
              _buildNavItem(1, Icons.content_cut, Icons.content_cut_outlined, "Services"),
              _buildNavItem(2, Icons.calendar_month, Icons.calendar_month_outlined, "Booking"),
              _buildNavItem(3, Icons.contact_phone, Icons.contact_phone_outlined, "Contacts"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _navigateToIndex(index),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFD4A853).withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? activeIcon : icon,
                  key: ValueKey(isActive),
                  color: isActive
                      ? const Color(0xFFD4A853)
                      : const Color(0xFF666666),
                  size: 26,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isActive
                      ? const Color(0xFFD4A853)
                      : const Color(0xFF666666),
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
