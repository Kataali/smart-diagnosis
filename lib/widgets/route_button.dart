import 'package:flutter/material.dart';

class RouteButton extends StatelessWidget {
  const RouteButton({
    super.key,
    required this.onPressed,
  });
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.arrow_forward_ios_outlined,
        size: 35,
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
