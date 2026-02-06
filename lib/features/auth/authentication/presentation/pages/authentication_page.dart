import 'package:demo_valorant/firebase_login_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:commons/router/navigation_helper.dart';
// import '../../../../../core/router/app_router.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if(snapshot.hasData){
          return Scaffold(
            appBar: AppBar(title: const Text('Selecciona una opción')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Estás autenticado :D"),
                  SizedBox(height: 16,),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue.shade100
                    ),
                    onPressed: () async {
                      await AuthService().signOut();
                    },
                    child: Text("Cerrar sesión"),
                  ),
                ],
              ),
            ),
          );
        }

        return const AuthenticationPageContainer();
      },
    );
  }
}


class AuthenticationPageContainer extends StatefulWidget {
  const AuthenticationPageContainer({super.key});

  @override
  State<AuthenticationPageContainer> createState() => _AuthenticationPageContainerState();
}

class _AuthenticationPageContainerState extends State<AuthenticationPageContainer> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido*';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Correo invalido*';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido*';
                  }
                  if (value.length < 6) {
                    return 'Minimo 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {

                    final userData = await AuthService().signInWithEmail(_emailController.text, _passwordController.text);
                    if(userData?.user != null) {
                      // Descomentar abajo para ir a la ruta de selección
                      //NavigationHelper.goToAndReplace(context, AppRouter.selection.path);
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
