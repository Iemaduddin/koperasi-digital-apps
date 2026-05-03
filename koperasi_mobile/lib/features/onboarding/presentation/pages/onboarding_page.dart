import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/routes/app_routes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Selamat Datang di Koperasi Digital',
      'description': 'Kelola keuangan Anda dengan mudah, aman, dan transparan melalui Koperasi Digital.',
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'title': 'Simpanan & Pinjaman',
      'description': 'Nikmati layanan simpanan dengan bunga menarik dan pinjaman dengan proses cepat.',
      'icon': Icons.monetization_on_rounded,
    },
    {
      'title': 'Pantau Kapan Saja',
      'description': 'Akses laporan keuangan, histori transaksi, dan sisa tagihan secara real-time dari genggaman Anda.',
      'icon': Icons.insert_chart_rounded,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder for Illustration/SVG
                        Container(
                          height: 250,
                          width: 250,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _onboardingData[index]['icon'],
                            size: 100,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          _onboardingData[index]['title'],
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _onboardingData[index]['description'],
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyText1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingData.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.textSecondary,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Masuk',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Daftar',
                    isOutlined: true,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
