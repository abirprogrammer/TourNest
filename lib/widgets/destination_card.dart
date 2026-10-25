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
    return Material(
      color: const Color(0xFFF0F5F1),
      borderRadius: BorderRadius.circular(17),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.48,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    destination.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const ColoredBox(
                        color: Color(0xFFE5ECE7),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: green,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Color(0xFFE5ECE7),
                      child: Center(
                        child: Icon(Icons.landscape_rounded,
                            color: green, size: 38),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.black.withAlpha(90),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: onFavouriteTap,
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Icon(
                            isFavourite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF34473D),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      if (showLocation) ...[
                        const Icon(Icons.location_on_outlined,
                            color: muted, size: 14),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            destination.location.split(',').first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: muted, fontSize: 10),
                          ),
                        ),
                      ] else
                        Expanded(
                          child: Text(
                            destination.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: muted, fontSize: 10),
                          ),
                        ),
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFE7B84D), size: 15),
                      const SizedBox(width: 2),
                      Text(
                        destination.rating,
                        style: const TextStyle(
                          color: Color(0xFF65736A),
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
