import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final String? position;
  final String? imageUrl;

  final VoidCallback? onTap;
  final VoidCallback? onInfoTap;
  final VoidCallback? onActionTap;

  final IconData infoIcon;
  final IconData actionIcon;

  const CustomCard({
    super.key,
    required this.name,
    required this.position,
    this.imageUrl,
    this.onTap,
    this.onInfoTap,
    this.onActionTap,
    this.infoIcon = Icons.priority_high,
    this.actionIcon = Icons.edit,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1DA1F2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        // Layer decoration
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Container(
          height: 80,
          margin: const EdgeInsets.only(left: 1, right: 1, top: 1, bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: primaryBlue, width: 1.5),
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? NetworkImage(imageUrl!)
                    : null,
                child: (imageUrl == null || imageUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 26, color: Colors.white)
                    : null,
              ),

              const SizedBox(width: 12),

              // Name + Position
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            (position != null && position!.isNotEmpty)
                                ? position!
                                : 'Unknown',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),
              if (onActionTap != null)
                InkWell(
                  onTap: onActionTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(8), // kotak rounded
                    ),
                    child: Icon(actionIcon, color: Colors.white, size: 18),
                  ),
                ),

              const SizedBox(width: 8),

              if (onInfoTap != null)
                InkWell(
                  onTap: onInfoTap,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(infoIcon, color: Colors.white, size: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
