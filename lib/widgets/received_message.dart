import 'package:flutter/material.dart';
import '../theme/tizen_styles.dart';

class ReceivedMessage extends StatelessWidget {
  final String text;
  final String avatarInitial;

  const ReceivedMessage({
    super.key,
    required this.text,
    required this.avatarInitial,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: TizenStyles.slate800,
          child: Text(
            avatarInitial,
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              text,
              style: TizenStyles.bodyText,
            ),
          ),
        ),
        const SizedBox(width: 100), // Right margin increased to 100
      ],
    );
  }
}
