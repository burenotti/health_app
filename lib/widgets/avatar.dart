import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String name;
  final double size;
  const Avatar({required this.name, this.size = 48, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(64)),
        color: getAvatarColor(name),
      ),
      child: Center(
        child: Text(
          (name.isNotEmpty) ? name[0] : "?",
          style: TextStyle(
            inherit: false,
            fontSize: size / 2,
            color: Colors.white,
            shadows: const [
              Shadow(
                color: Colors.black,
                blurRadius: 6.0,
                offset: Offset(1, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getAvatarColor(String firstName) {
    final colors = [
      Colors.amber.shade400,
      Colors.deepOrange.shade400,
      Colors.deepPurple.shade400,
      Colors.blue.shade400,
      Colors.red.shade400,
      Colors.green.shade400,
    ];
    return colors[firstName.length % colors.length];
  }
}
