import 'package:demo_valorant/features/auth/authentication/presentation/widgets/molecules/role_option_card.dart';
import 'package:demo_valorant/features/utils/atoms_design/organisms/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:commons/commons.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../utils/helper_demo.dart';
import '../../data/cache/session_cache.dart';
import '../bloc/authentication_bloc.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      GetIt.I<AuthenticationBloc>()
        ..add(AuthenticationStarted()),
      child: const AuthenticationPageView(),
    );
  }
}

class AuthenticationPageView extends StatelessWidget {
  const AuthenticationPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthenticationAuthenticated) {
          if (context.mounted) {
            NavigationHelper.goToAndReplace(context, AppRouter.topics.path);
          }
        }
      },
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
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
  State<AuthenticationPageContainer> createState() =>
      _AuthenticationPageContainerState();
}

class _AuthenticationPageContainerState
    extends State<AuthenticationPageContainer> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool selectedType = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      webMaxWidth: 450,
      webMaxHeight: 550,
      showArrowBack: false,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: isMobile(context) ? 200 : 0),
            child: Column(
              mainAxisAlignment: isMobile(context) ? MainAxisAlignment
                  .start : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.library_books_rounded,
                  size: 80,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 24),
                Text(
                  'Bienvenido de Nuevo',
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión para continuar',
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(
                    context,
                  )
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                if(!selectedType)
                  Row(
                  children: [
                    Expanded(
                      child: RoleOptionCard(
                        label: "Administrador",
                        onPressed: (){
                          setState(() {
                            selectedType = true;
                          });
                          cacheUser.roleSelected = RoleUser.admin;
                        },
                      ),
                    ),
                    SizedBox(width: 32,),
                    Expanded(
                      child: RoleOptionCard(
                        label: "Lector",
                        onPressed: (){
                          setState(() {
                            selectedType = true;
                          });
                          cacheUser.roleSelected = RoleUser.viewer;
                        },
                      ),
                    ),
                  ],
                ),
                if(selectedType)
                  TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido*';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Correo invalido*';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                if(selectedType)
                  const SizedBox(height: 16),
                if(selectedType)
                  TextFormField(
                  controller: _passwordController,
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
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 24),
                if(selectedType)
                  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthenticationBloc>().add(
                        AuthenticationLoginRequested(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    }
                  },
                  child: const Text('INICIAR SESIÓN'),
                ),
                if(selectedType)
                  const SizedBox(height: 16),
                if(selectedType)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedType = false;
                      });
                      cacheUser.roleSelected = null;

                    },
                    child: const Text('Cambiar de rol'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
