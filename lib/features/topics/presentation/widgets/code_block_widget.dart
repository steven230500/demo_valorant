import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeBlockWidget extends StatelessWidget {
  final String code;
  final String language;

  const CodeBlockWidget({
    super.key,
    required this.code,
    this.language = 'dart',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark background like VS Code
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF252526),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF858585),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Código copiado al portapapeles'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.copy, size: 14, color: Color(0xFF858585)),
                      SizedBox(width: 4),
                      Text(
                        'Copiar',
                        style: TextStyle(
                          color: Color(0xFF858585),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Code Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RichText(text: _buildSyntaxHighlighting(code)),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildSyntaxHighlighting(String source) {
    final List<TextSpan> spans = [];
    final RegExp tokenRegex = RegExp(
      r'(?<keyword>\b(void|class|final|var|const|async|await|return|if|else|import|package|int|double|String|bool|List|Map|dynamic|true|false)\b)|'
              r'(?<string>"[^"]*"|' +
          "'[^']*')|"
              r'(?<comment>//.*|/\*[\s\S]*?\*/)|'
              r'(?<number>\b\d+(\.\d+)?\b)|'
              r'(?<default>[\s\S])', // Match any other character
      multiLine: true,
    );

    for (final match in tokenRegex.allMatches(source)) {
      if (match.namedGroup('keyword') != null) {
        spans.add(
          TextSpan(
            text: match.group(0),
            style: const TextStyle(
              color: Color(0xFFC586C0),
              fontWeight: FontWeight.bold,
            ), // Keyword color (Pink/Purple)
          ),
        );
      } else if (match.namedGroup('string') != null) {
        spans.add(
          TextSpan(
            text: match.group(0),
            style: const TextStyle(
              color: Color(0xFFCE9178),
            ), // String color (Orange/Brown)
          ),
        );
      } else if (match.namedGroup('comment') != null) {
        spans.add(
          TextSpan(
            text: match.group(0),
            style: const TextStyle(
              color: Color(0xFF6A9955),
              fontStyle: FontStyle.italic,
            ), // Comment color (Green)
          ),
        );
      } else if (match.namedGroup('number') != null) {
        spans.add(
          TextSpan(
            text: match.group(0),
            style: const TextStyle(
              color: Color(0xFFB5CEA8),
            ), // Number color (Light Green)
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: match.group(0),
            style: const TextStyle(
              color: Color(0xFFD4D4D4),
            ), // Default text color (Light Grey)
          ),
        );
      }
    }

    return TextSpan(
      style: const TextStyle(
        fontFamily: 'Courier', // Monospace font
        fontSize: 14,
      ),
      children: spans,
    );
  }
}
