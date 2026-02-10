import 'package:commons/commons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../firebase_login_functions.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Redirect or show login button
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sesión no iniciada"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      NavigationHelper.goToAndReplace(
                        context,
                        AppRouter.login.path,
                      );
                    },
                    child: const Text("Ir al Login"),
                  ),
                ],
              ),
            ),
          );
        }

        final user = snapshot.data!;
        return Scaffold(
          backgroundColor: Colors.grey[50], // Light background
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.grey),
                  onPressed: () async {
                    await AuthService().signOut();
                  },
                  tooltip: 'Cerrar sesión',
                ),
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, ${user.email ?? "Usuario"}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecciona una herramienta para comenzar',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Responsive grid count
                          int crossAxisCount = constraints.maxWidth > 600
                              ? 2
                              : 1;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: 1.5,
                            children: [
                              _SelectionCard(
                                title: 'Valorant',
                                subtitle: 'Explora agentes, armas y mapas',
                                icon: Icons.gamepad,
                                color: Colors.redAccent,
                                onTap: () => NavigationHelper.pushTo(
                                  context,
                                  AppRouter.home.path,
                                ),
                              ),
                              _SelectionCard(
                                title: 'Topics',
                                subtitle: 'Gestiona temas y contenido',
                                icon: Icons.topic,
                                color: Colors.blueAccent,
                                onTap: () => NavigationHelper.pushTo(
                                  context,
                                  AppRouter.topics.path,
                                ),
                              ),
                              // Add more cards here in the future
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<_SelectionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_isHovered ? 0.4 : 0.15),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: _isHovered
                  ? widget.color.withOpacity(0.5)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Background decoration
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    widget.icon,
                    size: 150,
                    color: widget.color.withOpacity(0.05),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(widget.icon, size: 32, color: widget.color),
                      ),
                      const Spacer(),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
