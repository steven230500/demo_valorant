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
      if (_controller.text != widget.block.content) {
        _controller.text = widget.block.content;
      }
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
          id: widget.block.id,
          order: widget.block.order,
          type: ContentBlockType.image,
          content: file.path,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Icon(
                  _getIconForType(widget.block.type),
                  size: 20,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  _labelForType(widget.block.type),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: widget.onDelete,
                  tooltip: 'Eliminar bloque',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildEditorForType(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorForType() {
    if (widget.block.type == ContentBlockType.code) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: _controller,
          maxLines: null,
          minLines: 3,
          style: const TextStyle(
            fontFamily: 'Courier',
            color: Color(0xFFD4D4D4),
            fontSize: 14,
            height: 1.4,
          ),
          decoration: const InputDecoration(
            hintText: 'Pega o escribe tu código Dart aquí...',
            hintStyle: TextStyle(color: Color(0xFF555555)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
          onChanged: (value) => _updateContent(value),
        ),
      );
    }

    switch (widget.block.type) {
      case ContentBlockType.title:
      case ContentBlockType.subtitle:
      case ContentBlockType.paragraph:
      case ContentBlockType.url:
        return TextFormField(
          controller: _controller,
          maxLines: widget.block.type == ContentBlockType.paragraph ? null : 1,
          minLines: widget.block.type == ContentBlockType.paragraph ? 3 : 1,
          style: TextStyle(
            fontSize: widget.block.type == ContentBlockType.title ? 18 : 15,
            fontWeight:
                widget.block.type == ContentBlockType.title ||
                    widget.block.type == ContentBlockType.subtitle
                ? FontWeight.bold
                : FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText:
                'Ingresa el contenido del ${_labelForType(widget.block.type).toLowerCase()}',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade200, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: (value) => _updateContent(value),
        );

      case ContentBlockType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.block.content.isNotEmpty)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: kIsWeb
                        ? Image.network(
                            widget.block.content,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : Image.file(
                            File(widget.block.content),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              )
            else
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 40,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Seleccionar imagen',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _updateContent(String value) {
    widget.onChanged(
      ContentBlockModel(
        type: widget.block.type,
        content: value,
        id: widget.block.id,
        order: widget.block.order,
      ),
    );
  }

  IconData _getIconForType(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.title:
        return Icons.title;
      case ContentBlockType.subtitle:
        return Icons.text_fields;
      case ContentBlockType.paragraph:
        return Icons.notes;
      case ContentBlockType.code:
        return Icons.code;
      case ContentBlockType.url:
        return Icons.link;
      case ContentBlockType.image:
        return Icons.image;
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
        return 'Enlace';
      case ContentBlockType.image:
        return 'Imagen';
    }
  }
}
