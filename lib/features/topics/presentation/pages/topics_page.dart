import 'package:demo_valorant/core/injectors/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../atoms_design/organisms/topic_accordion.dart';
import '../bloc/topics_bloc.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double paddingHorizontal = (width * 0.5) / 2;

    return BlocProvider(
      create: (_) => getIt<TopicsBloc>()..add(GetTopicsEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Topics')),
        body: BlocBuilder<TopicsBloc, TopicsState>(
          builder: (context, state) {
            if (state is TopicsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopicsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is TopicsLoaded) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width < 600 ? 16 : paddingHorizontal,
                ),
                child: ListView.builder(
                  itemCount: state.topics.length,
                  itemBuilder: (context, index) {
                    final topic = state.topics[index];

                    return TopicAccordion(
                      topic: topic,
                      subtopics: [
                        'Componentes y Props',
                        'Estado y Ciclo de Vida',
                        'Hooks Básicos (useState, useEffect)',
                        'Manejo de Eventos',
                        'Renderizado Condicional',
                      ],
                      onTap: () {},
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('No topics loaded'));
          },
        ),
      ),
    );
  }
}
