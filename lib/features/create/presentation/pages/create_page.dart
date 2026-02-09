import 'package:commons/router/navigation_helper.dart';
import 'package:demo_valorant/core/injectors/injector.dart';
import 'package:demo_valorant/features/topics/domain/entities/subtopic_entity.dart';
import 'package:demo_valorant/features/topics/domain/entities/topic_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/topic_model.dart';
import '../../domain/entities/content_block_entity.dart';
import '../bloc/form/form_bloc.dart';
import '../organism/content_bloc_widget.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key, required this.topic, required this.subtopic});

  final TopicEntity topic;
  final SubtopicEntity subtopic;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FormCreateBloc>()..add(GetDetailSubtopicEvent(topic.id, subtopic.id)),
      // child: ContentEditorPage(topic: topic, subtopic: subtopic,),
      child: BlocBuilder<FormCreateBloc, FormCreateState>(
        buildWhen: (_, __) => true,
        builder: (context, state) {

          if(state is FormCreateSuccess) {
            return ContentEditorPage(topic: topic, subtopic: subtopic, blocks: state.topics,);
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Crear contenido'),
              actions: [
                IconButton(
                  onPressed: () => NavigationHelper.pushReplacement(context, AppRouter.topics.path),
                  icon: Icon(Icons.chevron_left),
                )
              ],
            ),
            body: state is FormCreateError ?
                Center(
                  child: Text(state.message, style: TextStyle(color: Colors.red),),
                )
                :
                Center(
                  child: CircularProgressIndicator(),
                ),
          );
        },
      )
    );
  }
}

class ContentEditorPage extends StatefulWidget {
  const ContentEditorPage({
    super.key,
    required this.topic,
    required this.subtopic,
    required this.blocks,
  });

  final TopicEntity topic;
  final SubtopicEntity subtopic;
  final List<ContentBlockEntity> blocks;

  @override
  State<ContentEditorPage> createState() => _ContentEditorPageState();
}

class _ContentEditorPageState extends State<ContentEditorPage> {
  final List<ContentBlockModel> blocks = [];

  @override
  void initState() {
    // getIt<FormCreateBloc>().add(GetDetailSubtopicEvent(widget.topic.id, widget.subtopic.id));
    setState(() {
      blocks.addAll(widget.blocks.map((e) => ContentBlockModel(id: e.id, type: e.type, content: e.content, order: e.order)));
    });
    super.initState();
  }

  void _addBlock(ContentBlockType type) {
    setState(() {
      blocks.add(
        ContentBlockModel(id: '', type: type, content: '', order: blocks.length),
      );
    });
  }

  void _updateBlock(int index, ContentBlockModel updated) {
    setState(() {
      blocks[index] = updated;
    });
  }

  void _removeBlock(int index) {
    final block = blocks[index];
    setState(() {
      blocks.removeAt(index);
    });
    if(block.id.isNotEmpty){
      context.read<FormCreateBloc>().add(DeleteBlockDetailEvent(
        topicId: widget.topic.id,
        subtopicId: widget.subtopic.id,
        blockId: block.id,
        blocks: blocks,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear contenido'),
        actions: [
          IconButton(
            onPressed: () => NavigationHelper.pushReplacement(context, AppRouter.topics.path),
            icon: Icon(Icons.chevron_left),
          )
        ],
      ),
      floatingActionButton: PopupMenuButton<ContentBlockType>(
        icon: const Icon(Icons.add),
        onSelected: _addBlock,
        itemBuilder: (_) => ContentBlockType.values
            .map(
              (type) => PopupMenuItem(
            value: type,
            child: Text('Agregar ${type.name}'),
          ),
        )
            .toList(),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: blocks.length,
                itemBuilder: (_, index) {
                  return ContentBlockEditor(
                    block: blocks[index],
                    onChanged: (updated) => _updateBlock(index, updated),
                    onDelete: () => _removeBlock(index),
                  );
                },
              ),
            ),
            if(blocks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: TextButton(
                  onPressed: () async {
                    for(final block in blocks) {
                      if(block.content.isEmpty) {
                        showDialog(context: context, builder: (_){
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                              'No fue posible actualizar el detalle, todos los bloques deben tener contenido',
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                                child: const Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                        return;
                      }
                    }
                    context.read<FormCreateBloc>().add(UpdateDetailEvent(
                      widget.topic.id,
                      widget.subtopic.id,
                      blocks,
                    ));
                  },
                  child: Container(
                    color: Colors.blue.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text('Actualizar Contenido'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
