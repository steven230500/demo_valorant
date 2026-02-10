import 'package:commons/router/navigation_helper.dart';
import 'package:demo_valorant/features/utils/atoms_design/organisms/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injectors/injector.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/topic_form/topic_form_bloc.dart';

class TopicFormPage extends StatelessWidget {
  final String? topicId;
  final String? subtopicId;
  final String? initialName;
  final String? initialIcon;
  final bool isSubtopic;

  const TopicFormPage({
    super.key,
    this.topicId,
    this.subtopicId,
    this.initialName,
    this.initialIcon,
    required this.isSubtopic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TopicFormBloc>(),
      child: _TopicFormView(
        topicId: topicId,
        subtopicId: subtopicId,
        initialName: initialName,
        initialIcon: initialIcon,
        isSubtopic: isSubtopic,
      ),
    );
  }
}

class _TopicFormView extends StatefulWidget {
  final String? topicId;
  final String? subtopicId;
  final String? initialName;
  final String? initialIcon;
  final bool isSubtopic;

  const _TopicFormView({
    required this.topicId,
    required this.subtopicId,
    required this.initialName,
    required this.initialIcon,
    required this.isSubtopic,
  });

  @override
  State<_TopicFormView> createState() => _TopicFormViewState();
}

class _TopicFormViewState extends State<_TopicFormView> {
  late TextEditingController _nameController;
  late TextEditingController _iconController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _iconController = TextEditingController(text: widget.initialIcon);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final icon = _iconController.text;

      if (widget.isSubtopic) {
        if (widget.subtopicId != null) {
          // Edit Subtopic
          context.read<TopicFormBloc>().add(
            EditSubtopicEvent(
              topicId: widget.topicId!,
              subtopicId: widget.subtopicId!,
              name: name,
              icon: icon,
            ),
          );
        } else {
          // Create Subtopic
          context.read<TopicFormBloc>().add(
            CreateSubtopicEvent(
              topicId: widget.topicId!,
              name: name,
              icon: icon,
            ),
          );
        }
      } else {
        if (widget.topicId != null) {
          // Edit Topic
          context.read<TopicFormBloc>().add(
            EditTopicEvent(id: widget.topicId!, name: name, icon: icon),
          );
        } else {
          // Create Topic
          context.read<TopicFormBloc>().add(
            CreateTopicEvent(name: name, icon: icon),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isSubtopic
        ? (widget.subtopicId != null ? 'Editar Subtema' : 'Crear Subtema')
        : (widget.topicId != null ? 'Editar Tema' : 'Crear Tema');

    return CustomScaffold(
      headerTitle: title,
      body: BlocConsumer<TopicFormBloc, TopicFormState>(
        listener: (context, state) {
          if (state is TopicFormSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Operación exitosa')));
            NavigationHelper.pushReplacement(context, AppRouter.topics.path);
          } else if (state is TopicFormError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _iconController,
                    decoration: const InputDecoration(
                      labelText: 'URL del Icono',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (state is TopicFormLoading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.isSubtopic
                              ? (widget.subtopicId != null
                                    ? 'Actualizar Subtema'
                                    : 'Crear Subtema')
                              : (widget.topicId != null
                                    ? 'Actualizar Tema'
                                    : 'Crear Tema'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
