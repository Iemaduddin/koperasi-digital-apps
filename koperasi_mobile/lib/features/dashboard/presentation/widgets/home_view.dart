import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class HomeView extends StatelessWidget {
  final String userName;
  final String userRole;
  final VoidCallback onLogout;

  const HomeView({
    super.key,
    required this.userName,
    required this.userRole,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildBalanceCard(),
          _buildQuickActions(),
          _buildRecentActivityHeader(),
          _buildRecentActivityList(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Halo,', style: TextStyle(color: Colors.grey, fontSize: 14)),
              Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary, // Solid color for performance
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Simpanan',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'Rp 12.500.000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BalanceDetail(title: 'Wajib', amount: 'Rp 2.0M'),
              _BalanceDetail(title: 'Sukarela', amount: 'Rp 10.5M'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionItem(icon: Icons.add_card, label: 'Setor'),
          _ActionItem(icon: Icons.outbox, label: 'Tarik'),
          _ActionItem(icon: Icons.swap_horiz, label: 'Transfer'),
          _ActionItem(icon: Icons.receipt_long, label: 'Tagihan'),
        ],
      ),
    );
  }

  Widget _buildRecentActivityHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Text(
        'Aktivitas Terakhir',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFF0FDF4),
                child: Icon(Icons.arrow_downward, color: Colors.green, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Simpanan Sukarela', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('3 Mei 2026', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              const Text(
                '+Rp 500rb',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BalanceDetail extends StatelessWidget {
  final String title;
  final String amount;
  const _BalanceDetail({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
