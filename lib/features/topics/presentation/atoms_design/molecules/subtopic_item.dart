import 'package:demo_valorant/features/topics/domain/entities/subtopic_entity.dart';
import 'package:flutter/material.dart';

class SubtopicItem extends StatelessWidget {
  final SubtopicEntity subtopic;
  final VoidCallback? onTap;

  const SubtopicItem({super.key, required this.subtopic, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(Icons.chevron_right, color: Colors.blueAccent),
        title: Text(
          subtopic.name,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}
