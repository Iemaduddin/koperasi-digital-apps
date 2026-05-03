import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/data/services/auth_service.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/models/nav_item.dart';
import '../../../../core/constants/colors.dart';
import 'dashboard_data.dart';
import '../widgets/dashboard_upward_menu.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _userName = '';
  String _userRole = '';
  int _currentIndex = 0;
  Widget? _activeSubPage;
  String? _activeSubPageTitle;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Pengguna';
      _userRole = prefs.getString('user_role') ?? '';
    });
  }

  void _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
  }

  void _onTap(int index) {
    final navItems = DashboardData.getNavItems(
      userName: _userName,
      userRole: _userRole,
      onLogout: _logout,
    );
    final item = navItems[index];

    if (item.hasChildren) {
      DashboardUpwardMenu.show(context, item, onSubItemTap: (subItem) {
        setState(() {
          _currentIndex = index;
          _activeSubPage = subItem.page;
          _activeSubPageTitle = subItem.label;
        });
      });
    } else {
      setState(() {
        _currentIndex = index;
        _activeSubPage = null;
        _activeSubPageTitle = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final navItems = DashboardData.getNavItems(
      userName: _userName,
      userRole: _userRole,
      onLogout: _logout,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _activeSubPage != null 
        ? AppBar(
            title: Text(_activeSubPageTitle ?? ''),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() {
                _activeSubPage = null;
                _activeSubPageTitle = null;
              }),
            ),
          )
        : null,
      body: SafeArea(
        child: _activeSubPage ?? IndexedStack(
          index: _currentIndex,
          children: navItems.map((e) => e.page ?? const SizedBox()).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          showUnselectedLabels: true,
          elevation: 0,
          items: navItems
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(e.icon),
                  ),
                  label: e.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
