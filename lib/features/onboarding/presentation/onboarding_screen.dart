library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_PageData> _pages = const [
    _PageData(
      gradient: AppColors.violetGradient,
      accentColor: AppColors.primaryLight,
      icon: Icons.beach_access_rounded,
      emoji: '☂️',
      title: 'Smart Umbrella',
      subtitle: 'Your intelligent beach companion with full remote control.',
    ),
    _PageData(
      gradient: AppColors.tealGradient,
      accentColor: AppColors.tealLight,
      icon: Icons.solar_power_rounded,
      emoji: '☀️',
      title: 'Solar Powered',
      subtitle: 'Built-in solar charging. Monitor energy in real-time.',
    ),
    _PageData(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
      ),
      accentColor: AppColors.ambient,
      icon: Icons.lightbulb_rounded,
      emoji: '💡',
      title: 'RGB Lighting',
      subtitle: 'Set the perfect mood. Static, ambient, or party mode.',
    ),
    _PageData(
      gradient: AppColors.emberGradient,
      accentColor: AppColors.roseLight,
      icon: Icons.music_note_rounded,
      emoji: '🎵',
      title: 'Sound System',
      subtitle: 'Premium speakers built in. Your playlist, your beach.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _complete();
    }
  }

  void _complete() {
    context.go(RoutePaths.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(gradient: page.gradient),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, right: 20),
                  child: GestureDetector(
                    onTap: _complete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (ctx, i) => _OnboardingPageView(data: _pages[i]),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOutBack,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: isActive ? 36 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        label: _currentPage < _pages.length - 1
                            ? 'Continue'
                            : 'Get Started',
                        icon: _currentPage < _pages.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.rocket_launch_rounded,
                        onPressed: _nextPage,
                        gradient: const LinearGradient(
                          colors: [Colors.white, Color(0xFFEDE9FE)],
                        ),
                        textStyle: TextStyle(
                          color: page.gradient.colors.first,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageData {
  final LinearGradient gradient;
  final Color accentColor;
  final IconData icon;
  final String emoji;
  final String title;
  final String subtitle;

  const _PageData({
    required this.gradient,
    required this.accentColor,
    required this.icon,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });
}

class _OnboardingPageView extends StatelessWidget {
  final _PageData data;

  const _OnboardingPageView({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 4),
                Icon(data.icon, color: Colors.white, size: 36),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1.0, 1.0),
                curve: Curves.easeOutBack,
                duration: 600.ms,
              ),

          const SizedBox(height: 52),

          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 150.ms, duration: 400.ms)
              .slideY(begin: 0.3, end: 0, delay: 150.ms, duration: 400.ms),

          const SizedBox(height: 20),

          Text(
            data.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 17,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 280.ms, duration: 400.ms)
              .slideY(begin: 0.3, end: 0, delay: 280.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
