import 'package:demo_valorant/features/topics/domain/entities/subtopic_entity.dart';
import 'package:demo_valorant/features/topics/domain/entities/topic_entity.dart';
import 'package:flutter/material.dart';
import '../../../../auth/authentication/data/cache/session_cache.dart';
import '../atoms/topic_icon.dart';
import '../molecules/subtopic_item.dart';

class TopicAccordion extends StatefulWidget {
  final TopicEntity topic;
  final bool isLoading;
  final List<SubtopicEntity> subtopics;
  final String? errorMessage;
  final VoidCallback? onTap;
  final bool shouldExpand;
  final ValueChanged<SubtopicEntity>? onSubtopic;
  final VoidCallback? onEditTopic;
  final ValueChanged<SubtopicEntity>? onEditSubtopic;
  final VoidCallback? onAddSubtopic;

  const TopicAccordion({
    super.key,
    required this.topic,
    required this.onTap,
    this.isLoading = false,
    this.subtopics = const [],
    this.errorMessage,
    this.shouldExpand = false,
    this.onSubtopic,
    this.onEditTopic,
    this.onEditSubtopic,
    this.onAddSubtopic,
  });

  @override
  State<TopicAccordion> createState() => _TopicAccordionState();
}

class _TopicAccordionState extends State<TopicAccordion>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _isExpandedNotifier;
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _isExpandedNotifier = ValueNotifier<bool>(false);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(TopicAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-expandir cuando shouldExpand cambia a true
    if (widget.shouldExpand && !_isExpandedNotifier.value) {
      _isExpandedNotifier.value = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _isExpandedNotifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.subtopics.isNotEmpty) {
      _isExpandedNotifier.value = !_isExpandedNotifier.value;
      if (_isExpandedNotifier.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    widget.onTap?.call();
  }

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
        child: Column(
          children: [
            InkWell(
              onTap: _handleTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    TopicIcon(url: widget.topic.icon),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.topic.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (widget.onEditTopic != null && cacheUser.role == RoleUser.admin)
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: widget.onEditTopic,
                        splashRadius: 20,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    const SizedBox(width: 8),
                    _buildTrailingIcon(),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isExpandedNotifier,
              builder: (context, isExpanded, child) {
                if (!isExpanded) return const SizedBox.shrink();
                return _buildExpandedContent();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingIcon() {
    if (widget.isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (widget.subtopics.isNotEmpty) {
      return RotationTransition(
        turns: _iconTurns,
        child: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      );
    }

    return const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey);
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.subtopics.isNotEmpty)
            ...List.generate(
              widget.subtopics.length,
              (index) => GestureDetector(
                onTap: () => widget.onSubtopic?.call(
                  SubtopicEntity(
                    id: widget.subtopics[index].id,
                    name: widget.subtopics[index].name,
                    icon: widget.subtopics[index].icon,
                    topicId: widget.topic.id,
                  ),
                ),
                child: SubtopicItem(
                  subtopic: widget.subtopics[index],
                  onEdit: () =>
                      widget.onEditSubtopic?.call(widget.subtopics[index]),
                ),
              ),
            ),

          if (widget.subtopics.isEmpty && widget.errorMessage != null)
            Text(
              'Error: ${widget.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),

          if (widget.onAddSubtopic != null && cacheUser.role == RoleUser.admin)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton.icon(
                onPressed: widget.onAddSubtopic,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Agregar Subtema'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue.withAlpha(13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
