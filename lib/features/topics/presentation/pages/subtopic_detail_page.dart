import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/subtopic_detail_entity.dart';
import '../bloc/subtopic_detail_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SubtopicDetailPage extends StatelessWidget {
  final String topicId;
  final String subtopicId;

  const SubtopicDetailPage({
    super.key,
    required this.topicId,
    required this.subtopicId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<SubtopicDetailBloc>()
        ..add(GetSubtopicDetailEvent(topicId: topicId, subtopicId: subtopicId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Detail')),
        body: BlocBuilder<SubtopicDetailBloc, SubtopicDetailState>(
          builder: (context, state) {
            if (state is SubtopicDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SubtopicDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is SubtopicDetailLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state.details.map(_buildWidget).toList(),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildWidget(SubtopicDetailEntity entity) {
    switch (entity.type) {
      case SubtopicDetailType.title:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            entity.content,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      case SubtopicDetailType.subtitle:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            entity.content,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        );
      case SubtopicDetailType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(entity.content, style: const TextStyle(fontSize: 16)),
        );
      case SubtopicDetailType.image:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              entity.content,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        );
      case SubtopicDetailType.code:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              entity.content,
              style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
            ),
          ),
        );
      case SubtopicDetailType.url:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () async {
              final uri = Uri.parse(entity.content);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            child: Text(
              entity.content,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      case SubtopicDetailType.unknown:
        return const SizedBox.shrink();
    }
  }
}
