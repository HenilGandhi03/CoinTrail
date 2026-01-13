import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.onTap,
  });

  final String imageUrl;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.primary, width: 6),
              image: DecorationImage(
                image: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/avatar_placeholder.png')
                          as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(name, style: theme.textTheme.titleLarge),
      ],
    );
  }
}
