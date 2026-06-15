library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressCtrl;
  late AnimationController _bgCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _progressAnim = CurvedAnimation(
      parent: _progressCtrl,
      curve: Curves.easeInOutCubic,
    );

    _progressCtrl.forward().then((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) context.go(RoutePaths.dashboard);
        });
      }
    });
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _bgCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgCtrl,
            // ignore: unnecessary_underscores
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _SplashAuroraPainter(progress: _bgCtrl.value),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, child) {
                    final glow = 0.3 + (_pulseCtrl.value * 0.4);
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF7C3AED,
                            ).withValues(alpha: glow * 0.5),
                            blurRadius: 60 + (_pulseCtrl.value * 30),
                            spreadRadius: 5 + (_pulseCtrl.value * 10),
                          ),
                          BoxShadow(
                            color: const Color(
                              0xFF14B8A6,
                            ).withValues(alpha: glow * 0.3),
                            blurRadius: 80,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  child:
                      Image.asset(
                            'assets/logo/Screenshot_2026-04-30_at_9.08.42_PM-removebg-preview.png',
                            width: 180,
                            height: 180,
                            fit: BoxFit.contain,
                          )
                          .animate()
                          .fadeIn(duration: 700.ms, curve: Curves.easeOut)
                          .scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1.0, 1.0),
                            duration: 900.ms,
                            curve: Curves.easeOutBack,
                          ),
                ),

                const SizedBox(height: 36),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _progressAnim,
                        // ignore: unnecessary_underscores
                        builder: (_, __) => Column(
                          children: [
                            Container(
                              height: 4,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _progressAnim.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7C3AED),
                                        Color(0xFF14B8A6),
                                        Color(0xFFF59E0B),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF7C3AED,
                                        ).withValues(alpha: 0.6),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${(_progressAnim.value * 100).toInt()}%',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 900.ms, duration: 500.ms),

                const SizedBox(height: 24),

                _LoadingDots().animate().fadeIn(
                  delay: 1000.ms,
                  duration: 400.ms,
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 40 + MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: Text(
              'Powered by Saif MUstafa',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.25),
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ).animate().fadeIn(delay: 1200.ms, duration: 600.ms),
          ),
        ],
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      // ignore: unnecessary_underscores
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = (_ctrl.value - delay).clamp(0.0, 1.0);
            final opacity = math.sin(t * math.pi).clamp(0.2, 1.0);
            final scale = 0.6 + (math.sin(t * math.pi) * 0.4);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7C3AED).withValues(alpha: opacity),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _SplashAuroraPainter extends CustomPainter {
  final double progress;
  const _SplashAuroraPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * math.pi * 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0A0A1A),
    );

    void drawBlob(double bx, double by, double r, Color col, double alpha) {
      final paint = Paint()
        ..shader =
            RadialGradient(
              colors: [
                col.withValues(alpha: alpha),
                col.withValues(alpha: 0.0),
              ],
            ).createShader(
              Rect.fromCenter(
                center: Offset(bx, by),
                width: r * 2,
                height: r * 2,
              ),
            );
      canvas.drawCircle(Offset(bx, by), r, paint);
    }

    drawBlob(
      size.width * 0.2 + math.sin(t * 0.5) * 40,
      size.height * 0.25 + math.cos(t * 0.4) * 30,
      size.width * 0.45,
      const Color(0xFF7C3AED),
      0.18,
    );

    drawBlob(
      size.width * 0.85 + math.cos(t * 0.6) * 30,
      size.height * 0.2 + math.sin(t * 0.5) * 25,
      size.width * 0.35,
      const Color(0xFF14B8A6),
      0.14,
    );

    drawBlob(
      size.width * 0.5 + math.sin(t * 0.8) * 20,
      size.height * 0.75 + math.cos(t * 0.7) * 20,
      size.width * 0.3,
      const Color(0xFFF59E0B),
      0.10,
    );

    drawBlob(
      size.width * 0.15 + math.cos(t * 0.9) * 15,
      size.height * 0.8 + math.sin(t * 0.6) * 20,
      size.width * 0.28,
      const Color(0xFF4C1D95),
      0.15,
    );
  }

  @override
  bool shouldRepaint(_SplashAuroraPainter old) => old.progress != progress;
}
