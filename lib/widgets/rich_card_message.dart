import 'package:flutter/material.dart';
import '../theme/tizen_styles.dart';

class RichCardMessage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String avatarInitial;

  const RichCardMessage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
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
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: TizenStyles.slate900.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TizenStyles.cardTitle,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TizenStyles.cardSubtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }
}
