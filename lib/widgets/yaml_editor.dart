import 'package:flutter/material.dart';

class YamlEditor extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;
  final bool hasError;
  final double fontSize;

  const YamlEditor({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.hasError = false,
    this.fontSize = 14.0,
  });

  @override
  State<YamlEditor> createState() => _YamlEditorState();
}

class _YamlEditorState extends State<YamlEditor> {
  late TextEditingController _controller;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(YamlEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isUpdating && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        readOnly: true,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: widget.fontSize,
          height: 1.5,
          color: widget.hasError 
              ? Theme.of(context).colorScheme.error 
              : Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          hoverColor: Colors.transparent,
          hintText: 'version: "3"\nservices:\n  # Your services will appear here',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        onChanged: (value) {
          _isUpdating = true;
          widget.onChanged(value);
          _isUpdating = false;
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
