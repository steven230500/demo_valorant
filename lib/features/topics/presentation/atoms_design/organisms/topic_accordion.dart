import 'package:flutter/material.dart';

import '../../../domain/entities/topic_entity.dart';
import '../atoms/topic_icon.dart';
import '../molecules/subtopic_item.dart';

class TopicAccordion extends StatelessWidget {
  final TopicEntity topic;
  final List<String> subtopics;
  final VoidCallback? onTap;

  const TopicAccordion({
    super.key,
    required this.topic,
    this.subtopics = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: TopicIcon(url: topic.icon),
            title: Text(
              topic.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            childrenPadding: const EdgeInsets.all(16),
            expandedAlignment: Alignment.topLeft,
            children: [
              const SizedBox(height: 10),
              ...subtopics.map(
                (title) => SubtopicItem(title: title, onTap: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
