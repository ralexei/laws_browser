import 'package:flutter/material.dart';

class ActivityIndicator extends StatefulWidget {
  const ActivityIndicator({super.key, required this.child});

  final Widget child;

  static ActivityIndicatorState of(BuildContext context)
    => context.findAncestorStateOfType<ActivityIndicatorState>()!;

  @override
  State<StatefulWidget> createState() => ActivityIndicatorState();
}

class ActivityIndicatorState extends State<ActivityIndicator> {

  bool _isLoading = false;

  void show() {
    setState(() {
      _isLoading = true;
    });
  }

  void hide() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}