import 'package:commons/commons.dart';
import 'package:demo_valorant/core/router/app_router.dart';
import 'package:demo_valorant/firebase_login_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Selecciona una opción')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SelectionCard(
                    title: 'Valorant',
                    icon: Icons.gamepad,
                    color: Colors.redAccent,
                    onTap: () =>
                        NavigationHelper.pushTo(context, AppRouter.home.path),
                  ),
                  const SizedBox(height: 20),
                  _SelectionCard(
                    title: 'Topics',
                    icon: Icons.topic,
                    color: Colors.blueAccent,
                    onTap: () =>
                        NavigationHelper.pushTo(context, AppRouter.topics.path),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue.shade100
                    ),
                    onPressed: () async {
                      await AuthService().signOut();
                    },
                    child: Text("Cerrar sesión D:"),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Selecciona una opción')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Iniciar Sesión"),
                SizedBox(height: 16,),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue.shade100
                  ),
                  onPressed: () async {
                    await AuthService().signInWithEmail("jyjdajj@gmail.com", "1234567890");
                  },
                  child: Text("Probar login :D"),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 150,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withAlpha(204), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
