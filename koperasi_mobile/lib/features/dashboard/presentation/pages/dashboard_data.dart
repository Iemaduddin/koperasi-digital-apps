import 'package:flutter/material.dart';
import '../../../../core/models/nav_item.dart';
import '../widgets/home_view.dart';
import '../widgets/placeholder_page.dart';
import '../../../users/presentation/pages/users_list_page.dart';

class DashboardData {
  static List<NavigationItem> getNavItems({
    required String userName,
    required String userRole,
    required VoidCallback onLogout,
  }) {
    return [
      NavigationItem(
        label: 'Beranda',
        icon: Icons.home_rounded,
        page: HomeView(
          userName: userName,
          userRole: userRole,
          onLogout: onLogout,
        ),
      ),
      NavigationItem(
        label: 'Simpanan',
        icon: Icons.account_balance_wallet_rounded,
        page: const PlaceholderPage(title: 'Simpanan'),
      ),
      NavigationItem(
        label: 'Pinjaman',
        icon: Icons.monetization_on_rounded,
        children: [
          SubItem(
            label: 'Daftar Pinjaman',
            icon: Icons.list_alt_rounded,
            page: const PlaceholderPage(title: 'Daftar Pinjaman'),
          ),
          SubItem(
            label: 'Angsuran',
            icon: Icons.payments_rounded,
            page: const PlaceholderPage(title: 'Angsuran'),
          ),
        ],
      ),
      NavigationItem(
        label: 'Deposito',
        icon: Icons.savings_rounded,
        children: [
          SubItem(
            label: 'Daftar Deposito',
            icon: Icons.format_list_bulleted_rounded,
            page: const PlaceholderPage(title: 'Daftar Deposito'),
          ),
          SubItem(
            label: 'Bagi Hasil',
            icon: Icons.trending_up_rounded,
            page: const PlaceholderPage(title: 'Bagi Hasil'),
          ),
        ],
      ),
      NavigationItem(
        label: 'More',
        icon: Icons.grid_view_rounded,
        children: [
          if (userRole == 'MASTER_ADMIN' || userRole == 'SUPER_ADMIN')
            SubItem(
              label: 'Kelola User',
              icon: Icons.manage_accounts_rounded,
              page: const UsersListPage(),
            ),
          SubItem(
            label: 'Riwayat Transaksi',
            icon: Icons.history_rounded,
            page: const PlaceholderPage(title: 'Riwayat Transaksi'),
          ),
          SubItem(
            label: 'Rekapan Anggota',
            icon: Icons.analytics_rounded,
            page: const PlaceholderPage(title: 'Rekapan Anggota'),
          ),
        ],
      ),
    ];
  }
}
