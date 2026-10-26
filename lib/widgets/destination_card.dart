import 'package:flutter/material.dart';
import '../models/destination.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final bool showLocation;
  final bool isFavourite;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.showLocation,
    required this.isFavourite,
    required this.onTap,
    required this.onFavouriteTap,
  });

  static const green = Color(0xFF168765);
  static const muted = Color(0xFF8A9690);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2D26) : const Color(0xFFF0F5F1);
    final textColor = isDark ? Colors.white : const Color(0xFF34473D);
    final mutedColor = isDark ? Colors.white70 : muted;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.55,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    destination.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return ColoredBox(
                        color: isDark ? const Color(0xFF24362D) : const Color(0xFFE5ECE7),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: green,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => ColoredBox(
                      color: isDark ? const Color(0xFF24362D) : const Color(0xFFE5ECE7),
                      child: const Center(
                        child: Icon(Icons.landscape_rounded,
                            color: green, size: 34),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.black.withAlpha(110),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: onFavouriteTap,
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isFavourite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 16,
                            color: isFavourite ? Colors.redAccent : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      if (showLocation) ...[
                        Icon(Icons.location_on_outlined,
                            color: mutedColor, size: 13),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            destination.location.split(',').first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: mutedColor, fontSize: 10),
                          ),
                        ),
                      ] else
                        Expanded(
                          child: Text(
                            destination.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: mutedColor, fontSize: 10),
                          ),
                        ),
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFE7B84D), size: 14),
                      const SizedBox(width: 2),
                      Text(
                        destination.rating,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : const Color(0xFF65736A),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
