/// Smart Umbrella App – High-Fidelity 3D Solar Umbrella Viewer
///
/// Renders a futuristic solar-panel smart umbrella inspired by sci-fi design:
///   • Dark angled canopy segments with solar panel textures
///   • Glowing blue tech LED rim & base
///   • Metallic pole with chrome shading
///   • Hexagonal glowing base platform
///   • Drag to rotate · Animated open/close · Light-on RGB glow
library;

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────
// Public widget
// ─────────────────────────────────────────────────────────────
class Umbrella3DViewer extends StatefulWidget {
  /// 0.0 = fully closed, 1.0 = fully open
  final double openProgress;
  final bool lightOn;
  final Color lightColor;

  const Umbrella3DViewer({
    super.key,
    required this.openProgress,
    this.lightOn = false,
    this.lightColor = const Color(0xFF00BFFF),
  });

  @override
  State<Umbrella3DViewer> createState() => _Umbrella3DViewerState();
}

class _Umbrella3DViewerState extends State<Umbrella3DViewer>
    with TickerProviderStateMixin {
  late AnimationController _openCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _ledCtrl;
  late Animation<double> _openAnim;

  double _rotY = 0.25; // start slightly angled like the photo
  double _rotX = -0.22; // top-down tilt
  bool _hintVisible = true;

  @override
  void initState() {
    super.initState();

    _openCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _openAnim = CurvedAnimation(parent: _openCtrl, curve: Curves.easeOutBack);
    _openCtrl.value = widget.openProgress;

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _ledCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 4),
        () { if (mounted) setState(() => _hintVisible = false); });
  }

  @override
  void didUpdateWidget(Umbrella3DViewer old) {
    super.didUpdateWidget(old);
    if (widget.openProgress != old.openProgress) {
      widget.openProgress > 0.5
          ? _openCtrl.animateTo(1.0, duration: const Duration(milliseconds: 1100), curve: Curves.easeOutBack)
          : _openCtrl.animateTo(0.0, duration: const Duration(milliseconds: 750), curve: Curves.easeInCubic);
    }
  }

  @override
  void dispose() {
    _openCtrl.dispose();
    _glowCtrl.dispose();
    _ledCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) => setState(() {
        _rotY += d.delta.dx * 0.011;
        _rotX = (_rotX + d.delta.dy * 0.007).clamp(-0.55, 0.05);
      }),
      child: SizedBox(
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── 3-D model ───────────────────────────────────
            AnimatedBuilder(
              animation: Listenable.merge([_openAnim, _glowCtrl, _ledCtrl]),
              builder: (_, __) => Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateX(_rotX)
                  ..rotateY(_rotY),
                child: CustomPaint(
                  size: const Size(260, 240),
                  painter: _SmartUmbrellaPainter(
                    openP: _openAnim.value,
                    rotY: _rotY,
                    glowP: _glowCtrl.value,
                    ledP: _ledCtrl.value,
                    lightOn: widget.lightOn,
                    lightColor: widget.lightColor,
                  ),
                ),
              ),
            ),

            // ── Hint ────────────────────────────────────────
            if (_hintVisible)
              Positioned(
                bottom: 2,
                child: AnimatedOpacity(
                  opacity: _hintVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF001830).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00CFFF).withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.drag_indicator_rounded, color: Color(0xFF00CFFF), size: 14),
                        SizedBox(width: 4),
                        Text('Drag to rotate',
                            style: TextStyle(color: Color(0xFF00CFFF), fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Main Painter
// ─────────────────────────────────────────────────────────────
class _SmartUmbrellaPainter extends CustomPainter {
  final double openP;   // 0..1
  final double rotY;
  final double glowP;   // 0..1 slow pulse
  final double ledP;    // 0..1 fast LED pulse
  final bool lightOn;
  final Color lightColor;

  const _SmartUmbrellaPainter({
    required this.openP,
    required this.rotY,
    required this.glowP,
    required this.ledP,
    required this.lightOn,
    required this.lightColor,
  });

  // ── Design constants ──────────────────────────────────────
  static const _techBlue   = Color(0xFF00BFFF);
  static const _techBlue2  = Color(0xFF0066CC);
  static const _panelEdge  = Color(0xFF252B3E);
  static const _solarBlue  = Color(0xFF1A3A5C);
  static const _solarCell  = Color(0xFF0D2640);
  static const _chrome1    = Color(0xFF8A8D9A);
  static const _chrome2    = Color(0xFFD0D3E0);
  static const _chromeDark = Color(0xFF3A3D4A);
  static const _ledOn      = Color(0xFF00EEFF);
  static const _glowColor  = Color(0xFF00BBFF);
  static const int _segN   = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.38;

    // Canvas-level perspective squash from rotX
    // (handled by Transform widget above; here we capture the
    //  visual cosine flattening from rotY only)
    final xCos = math.cos(rotY).abs().clamp(0.15, 1.0);

    final maxRx = size.width * 0.41;
    final maxRy = size.width * 0.16; // ellipse y-radius
    final rx = maxRx * openP * xCos;
    final ry = maxRy * openP;

    _drawGroundGlow(canvas, cx, size.height * 0.84, rx);
    _drawBase(canvas, cx, size.height * 0.75, rx * 0.38);
    _drawPole(canvas, cx, cy + 14, size.height * 0.76);

    if (openP > 0.02) {
      _drawCanopyUnder(canvas, cx, cy, rx, ry);
      _drawCanopyTop(canvas, cx, cy, rx, ry);
      _drawSolarPanels(canvas, cx, cy, rx, ry);
      _drawRibs(canvas, cx, cy, rx, ry);
      _drawCanopyRim(canvas, cx, cy, rx, ry);
    }
    _drawHub(canvas, cx, cy);

    if (lightOn && openP > 0.3) {
      _drawLightGlow(canvas, cx, cy, rx, ry);
    }
  }

  // ── Ground shadow glow ────────────────────────────────────
  void _drawGroundGlow(Canvas canvas, double cx, double sy, double rx) {
    final p = Paint()
      ..shader = RadialGradient(
        colors: [
          _glowColor.withValues(alpha: 0.15 * openP),
          _glowColor.withValues(alpha: 0.0),
        ],
      ).createShader(
          Rect.fromCenter(center: Offset(cx, sy), width: rx * 2.2, height: rx * 0.6))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, sy), width: rx * 2.2, height: rx * 0.4), p);
  }

  // ── Hexagonal tech base ───────────────────────────────────
  void _drawBase(Canvas canvas, double cx, double by, double r) {
    // Base body
    final bodyRect = Rect.fromCenter(
        center: Offset(cx, by + r * 0.5), width: r * 2.2, height: r * 1.1);

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2A3050), Color(0xFF10152A), Color(0xFF0A0E1C)],
      ).createShader(bodyRect);
    canvas.drawRRect(
        RRect.fromRectAndRadius(bodyRect, Radius.circular(r * 0.25)), bodyPaint);

    // LED strip on base
    final ledAlpha = (0.6 + ledP * 0.4).clamp(0.0, 1.0);
    final ledPaint = Paint()
      ..color = _ledOn.withValues(alpha: ledAlpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, by + r * 0.1),
            width: r * 2.0,
            height: r * 0.14),
        Radius.circular(r * 0.07),
      ),
      ledPaint,
    );

    // Base top plate edge
    final topEdge = Paint()
      ..shader = LinearGradient(
        colors: [_chromeDark, _chrome1, _chromeDark],
      ).createShader(Rect.fromLTWH(cx - r, by - r * 0.05, r * 2, r * 0.15));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(cx, by + r * 0.04),
              width: r * 2.1,
              height: r * 0.18),
          Radius.circular(r * 0.08)),
      topEdge,
    );

    // Corner glowing buttons
    for (final dx in [-r * 0.72, r * 0.72]) {
      final btnCenter = Offset(cx + dx, by + r * 0.5);
      canvas.drawCircle(
          btnCenter,
          r * 0.15,
          Paint()
            ..color = _techBlue2
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
      canvas.drawCircle(
          btnCenter,
          r * 0.09,
          Paint()
            ..color = _ledOn.withValues(alpha: 0.5 + ledP * 0.5));
    }
  }

  // ── Metallic pole ─────────────────────────────────────────
  void _drawPole(Canvas canvas, double cx, double top, double bottom) {
    final poleRect = Rect.fromLTWH(cx - 5, top, 10, bottom - top);
    final polePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [_chromeDark, _chrome2, _chrome1, _chrome2, _chromeDark],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(poleRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(poleRect, const Radius.circular(5)),
      polePaint,
    );

    // Pole blue highlight band
    final bandH = 6.0;
    for (final t in [0.3, 0.55, 0.75]) {
      final by = top + (bottom - top) * t;
      canvas.drawRect(
        Rect.fromLTWH(cx - 5, by - bandH / 2, 10, bandH),
        Paint()
          ..color = _techBlue.withValues(alpha: 0.5 + ledP * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  // ── Canopy underside (darker) ─────────────────────────────
  void _drawCanopyUnder(Canvas canvas, double cx, double cy, double rx, double ry) {
    const sweepAngle = (math.pi * 2) / _segN;
    for (int i = 0; i < _segN; i++) {
      final start = i * sweepAngle - math.pi / 2;
      final path = Path()
        ..moveTo(cx, cy + ry * 0.25) // slight downward shift for underside
        ..arcTo(
          Rect.fromCenter(
              center: Offset(cx, cy + ry * 0.25), width: rx * 1.96, height: ry * 1.96),
          start,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF0D1220)
          ..style = PaintingStyle.fill,
      );
    }
  }

  // ── Canopy top segments ───────────────────────────────────
  void _drawCanopyTop(Canvas canvas, double cx, double cy, double rx, double ry) {
    const sweepAngle = (math.pi * 2) / _segN;

    for (int i = 0; i < _segN; i++) {
      final start = i * sweepAngle - math.pi / 2;
      // Alternate slightly lighter for realistic shading
      final isAlt = i % 2 == 0;

      final segRect = Rect.fromCenter(
          center: Offset(cx, cy), width: rx * 2, height: ry * 2);

      final path = Path()
        ..moveTo(cx, cy)
        ..arcTo(segRect, start, sweepAngle, false)
        ..close();

      // Segment base gradient (dark charcoal → slightly lighter toward edge)
      final midAngle = start + sweepAngle / 2;

      final segPaint = Paint()
        ..shader = ui.Gradient.radial(
          Offset(cx, cy),
          rx * 0.85,
          [
            isAlt ? const Color(0xFF252C40) : const Color(0xFF1E2438),
            isAlt ? const Color(0xFF1A2030) : const Color(0xFF151B2A),
          ],
        );

      canvas.drawPath(path, segPaint);

      // Segment border
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = _panelEdge.withValues(alpha: 0.7)
          ..strokeWidth = 0.8,
      );
    }
  }

  // ── Solar panel cells on each segment ────────────────────
  void _drawSolarPanels(Canvas canvas, double cx, double cy, double rx, double ry) {
    const sweepAngle = (math.pi * 2) / _segN;

    for (int i = 0; i < _segN; i++) {
      final midAngle = i * sweepAngle - math.pi / 2 + sweepAngle / 2;
      final panelDist = rx * 0.55; // distance from center to panel center

      final px = cx + panelDist * math.cos(midAngle);
      final py = cy + ry / rx * panelDist * math.sin(midAngle);

      // Rotate canvas to align panel with segment direction
      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(midAngle + math.pi / 2);

      // Panel width/height scales with open progress
      final pw = rx * 0.28 * openP;
      final ph = ry * 1.1 * openP;

      // Panel outer frame
      final panelRect = Rect.fromCenter(center: Offset.zero, width: pw, height: ph);
      canvas.drawRRect(
        RRect.fromRectAndRadius(panelRect, Radius.circular(pw * 0.1)),
        Paint()..color = const Color(0xFF2A3252),
      );

      // Solar cell grid (2 × 3)
      const cols = 2;
      const rows = 3;
      final cw = pw * 0.82 / cols;
      final ch = ph * 0.82 / rows;
      final ox = -pw * 0.41 + cw * 0.5 + pw * 0.09;
      final oy = -ph * 0.41 + ch * 0.5 + ph * 0.09;

      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          final cellRect = Rect.fromCenter(
            center: Offset(ox + c * cw, oy + r * ch),
            width: cw * 0.86,
            height: ch * 0.86,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(cellRect, Radius.circular(cw * 0.1)),
            Paint()
              ..shader = ui.Gradient.linear(
                cellRect.topLeft,
                cellRect.bottomRight,
                [_solarBlue, _solarCell],
              ),
          );
          // Cell grid lines
          canvas.drawRRect(
            RRect.fromRectAndRadius(cellRect, Radius.circular(cw * 0.1)),
            Paint()
              ..style = PaintingStyle.stroke
              ..color = _techBlue2.withValues(alpha: 0.5)
              ..strokeWidth = 0.5,
          );
        }
      }

      // Blue shine reflection on panel
      final shineAlpha = (0.12 + glowP * 0.08).clamp(0.0, 1.0);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-pw * 0.4, -ph * 0.4, pw * 0.5, ph * 0.3),
          Radius.circular(pw * 0.08),
        ),
        Paint()
          ..color = Colors.white.withValues(alpha: shineAlpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      canvas.restore();
    }
  }

  // ── Structural ribs ───────────────────────────────────────
  void _drawRibs(Canvas canvas, double cx, double cy, double rx, double ry) {
    const sweepAngle = (math.pi * 2) / _segN;
    final ribPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [_chrome1, _chrome2.withValues(alpha: 0.5)],
      ).createShader(Rect.fromLTWH(cx - rx, cy - ry, rx * 2, ry * 2));

    for (int i = 0; i < _segN; i++) {
      final angle = i * sweepAngle - math.pi / 2;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + rx * math.cos(angle), cy + ry * math.sin(angle)),
        ribPaint,
      );
    }
  }

  // ── LED rim edge ──────────────────────────────────────────
  void _drawCanopyRim(Canvas canvas, double cx, double cy, double rx, double ry) {
    final ledAlpha = (0.55 + ledP * 0.45).clamp(0.0, 1.0);

    // Glow outer
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: rx * 2.05, height: ry * 2.05),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..color = _glowColor.withValues(alpha: ledAlpha * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Solid edge line
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = _ledOn.withValues(alpha: ledAlpha),
    );

    // Small LED dots around rim (8 points, one per rib end)
    const sweepAngle = (math.pi * 2) / _segN;
    for (int i = 0; i < _segN; i++) {
      final angle = i * sweepAngle - math.pi / 2;
      final dx = cx + rx * math.cos(angle);
      final dy = cy + ry * math.sin(angle);

      // Glow
      canvas.drawCircle(
          Offset(dx, dy),
          5,
          Paint()
            ..color = _ledOn.withValues(alpha: ledAlpha * 0.6)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
      // Core
      canvas.drawCircle(Offset(dx, dy), 2.5,
          Paint()..color = _ledOn.withValues(alpha: ledAlpha));
    }
  }

  // ── Central hub ──────────────────────────────────────────
  void _drawHub(Canvas canvas, double cx, double cy) {
    // Hub glow ring
    canvas.drawCircle(
        Offset(cx, cy),
        18,
        Paint()
          ..color = _glowColor.withValues(alpha: 0.3 + glowP * 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));

    // Hub body
    canvas.drawCircle(
        Offset(cx, cy),
        14,
        Paint()
          ..shader = RadialGradient(
            colors: [const Color(0xFF3A4060), const Color(0xFF181E32)],
          ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 14)));

    // Hub border
    canvas.drawCircle(
        Offset(cx, cy),
        14,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = _ledOn.withValues(alpha: 0.6 + ledP * 0.4)
          ..strokeWidth = 1.5);

    // Center dot
    canvas.drawCircle(
        Offset(cx, cy),
        4,
        Paint()
          ..color = _ledOn
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    canvas.drawCircle(Offset(cx, cy), 2, Paint()..color = Colors.white);
  }

  // ── RGB light glow (when lighting ON) ────────────────────
  void _drawLightGlow(Canvas canvas, double cx, double cy, double rx, double ry) {
    final alpha = (0.15 + glowP * 0.2).clamp(0.0, 1.0);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy), width: rx * 2.4, height: ry * 2.4),
      Paint()
        ..shader = RadialGradient(
          colors: [
            lightColor.withValues(alpha: alpha),
            lightColor.withValues(alpha: 0.0),
          ],
          radius: 0.75,
        ).createShader(Rect.fromCenter(
            center: Offset(cx, cy), width: rx * 2.4, height: ry * 2.4))
        ..blendMode = BlendMode.plus,
    );
  }

  @override
  bool shouldRepaint(_SmartUmbrellaPainter old) =>
      old.openP != openP ||
      old.rotY != rotY ||
      old.glowP != glowP ||
      old.ledP != ledP ||
      old.lightOn != lightOn ||
      old.lightColor != lightColor;
}
