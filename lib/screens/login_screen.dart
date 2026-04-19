import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController bgController;
  late AnimationController contentController;

  String displayedText = "";
  final String fullText = "CodeBoomer";

  @override
  void initState() {
    super.initState();

    bgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat(reverse: true);

    contentController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    contentController.forward();

    startTyping();
  }

  void startTyping() async {
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      setState(() {
        displayedText += fullText[i];
      });
    }
  }

  @override
  void dispose() {
    bgController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: bgController,
        builder: (context, _) {
          return Stack(
            children: [
              // 🌌 Animated Gradient Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + bgController.value, -1),
                    end: Alignment(1, 1 - bgController.value),
                    colors: const [
                      Color(0xFF020617),
                      Color(0xFF1E1B4B),
                      Color(0xFF312E81),
                    ],
                  ),
                ),
              ),

              // ✨ Floating Particles
              const ParticleBackground(),

              // 💎 Glass Login Card
              Center(
                child: FadeTransition(
                  opacity: contentController,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                        parent: contentController,
                        curve: Curves.easeOut)),
                    child: glassCard(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget glassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ⌨️ Typing Animation Title
              Text(
                displayedText,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),
              const Text("AI Code Explainer",
                  style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 30),

              glowingInput("Email", Icons.email),
              const SizedBox(height: 15),
              glowingInput("Password", Icons.lock, isPassword: true),

              const SizedBox(height: 25),

              animatedButton(),

              const SizedBox(height: 20),

              const Text("Or continue with",
                  style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  social(FontAwesomeIcons.google),
                  social(FontAwesomeIcons.github),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget glowingInput(String hint, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF020617),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  bool _pressed = false;

  Widget animatedButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.6),
                blurRadius: _pressed ? 5 : 20,
              )
            ],
          ),
          child: const Center(
            child: Text(
              "Sign In",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget social(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: FaIcon(icon, color: Colors.white, size: 18),
    );
  }
}

// 🌟 PARTICLE BACKGROUND
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final List<Offset> particles = List.generate(
    25,
    (index) => Offset(Random().nextDouble(), Random().nextDouble()),
  );

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CustomPaint(
          painter: ParticlePainter(particles, controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Offset> particles;
  final double progress;

  ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.1);

    for (var p in particles) {
      final dx = (p.dx * size.width + progress * 50) % size.width;
      final dy = (p.dy * size.height + progress * 30) % size.height;
      canvas.drawCircle(Offset(dx, dy), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}