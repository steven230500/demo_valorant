import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/topic_model.dart';
import '../../domain/entities/content_block_entity.dart';

class ContentBlockEditor extends StatefulWidget {
  final ContentBlockModel block;
  final ValueChanged<ContentBlockModel> onChanged;
  final VoidCallback onDelete;

  const ContentBlockEditor({
    super.key,
    required this.block,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<ContentBlockEditor> createState() => _ContentBlockEditorState();
}

class _ContentBlockEditorState extends State<ContentBlockEditor> {
  late TextEditingController _controller;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.block.content);
  }

  @override
  void didUpdateWidget(covariant ContentBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.block.content != widget.block.content) {
      _controller.text = widget.block.content;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      widget.onChanged(
        ContentBlockModel(
          id: '',
          order: 0,
          type: ContentBlockType.image,
          content: file.path,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Selector tipo
            DropdownButtonFormField<ContentBlockType>(
              initialValue: widget.block.type,
              decoration: const InputDecoration(
                labelText: 'Tipo de bloque',
              ),
              items: ContentBlockType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (newType) {
                if (newType != null) {
                  widget.onChanged(
                    ContentBlockModel(
                      type: newType,
                      content: '',
                      id: '',
                      order: 0,
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 12),

            /// UI según tipo
            _buildEditorForType(),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar bloque'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorForType() {
    switch (widget.block.type) {
      case ContentBlockType.title:
      case ContentBlockType.subtitle:
      case ContentBlockType.paragraph:
      case ContentBlockType.code:
      case ContentBlockType.url:
        return TextFormField(
          controller: _controller,
          maxLines: null,
          decoration: InputDecoration(
            labelText: _labelForType(widget.block.type),
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            widget.onChanged(
              ContentBlockModel(
                type: widget.block.type,
                content: value,
                id: '',
                order: 0,
              ),
            );
          },
        );

      case ContentBlockType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Seleccionar imagen'),
            ),
            const SizedBox(height: 10),
            if (widget.block.content.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb ? Image.network(
                  widget.block.content,
                  height: 180,
                  fit: BoxFit.cover,
                ) : Image.file(
                  File(widget.block.content),
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        );
    }
  }

  String _labelForType(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.title:
        return 'Título';
      case ContentBlockType.subtitle:
        return 'Subtítulo';
      case ContentBlockType.paragraph:
        return 'Párrafo';
      case ContentBlockType.code:
        return 'Código';
      case ContentBlockType.url:
        return 'URL del video';
      case ContentBlockType.image:
        return 'Imagen';
    }
  }
}
