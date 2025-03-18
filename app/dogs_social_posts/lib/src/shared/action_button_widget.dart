import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final String tag;
  final Color? backgroundColor;

  const ActionButton({
    Key? key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    required this.tag,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      heroTag: tag,
      child: Icon(icon),
    );
  }
}