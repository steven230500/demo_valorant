import 'package:dart_code_viewer2/dart_code_viewer2.dart';
import 'package:demo_valorant/features/topics/domain/entities/subtopic_entity.dart';
import 'package:demo_valorant/features/utils/atoms_design/organisms/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../utils/helper_demo.dart';
import '../../domain/entities/subtopic_detail_entity.dart';
import '../bloc/subtopic_detail_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SubtopicDetailPage extends StatelessWidget {
  final SubtopicEntity subtopic;

  const SubtopicDetailPage({super.key, required this.subtopic});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<SubtopicDetailBloc>()
        ..add(
          GetSubtopicDetailEvent(
            topicId: subtopic.topicId,
            subtopicId: subtopic.id,
          ),
        ),
      child: CustomScaffold(
        headerTitle: subtopic.name,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: state.details
                            .map(
                              (e) =>
                                  _buildWidget(e, isMobile: isMobile(context)),
                            )
                            .toList(),
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

  Widget _buildWidget(SubtopicDetailEntity entity, {required bool isMobile}) {
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
      case SubtopicDetailType.code: {
        final int lineCount = entity.content.split('\n').length;
        final double calculatedHeight = (lineCount * 24.0) + 40.0;

        return IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.grey),
              color: Colors.green,
            ),
            child: DartCodeViewer(
              entity.content,
              height: calculatedHeight,
            ),
          ),
        );
      }
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
