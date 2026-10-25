import 'package:flutter/material.dart';

import '../services/external_link_service.dart';
import '../models/destination.dart';
import 'ticket_booking_screen.dart';

class DestinationDetailsScreen extends StatelessWidget {
  final Destination destination;

  const DestinationDetailsScreen({super.key, required this.destination});

  static const green = Color(0xFF168765);
  static const muted = Color(0xFF75837A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            foregroundColor: Colors.white,
            backgroundColor: green,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                destination.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    destination.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const ColoredBox(color: Color(0xFFE5ECE7)),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Open map',
                onPressed: () => openExternalUrl(destination.mapUrl),
                icon: const Icon(Icons.map_outlined),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: green),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(destination.location,
                          style: const TextStyle(color: muted)),
                    ),
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFE7B84D)),
                    Text(destination.rating,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  destination.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF56665D),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.calendar_month_rounded,
                        title: 'Best time',
                        value: destination.bestTime,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoTile(
                        icon: Icons.payments_outlined,
                        title: 'Estimated budget',
                        value: destination.estimatedCost,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => openExternalUrl(destination.mapUrl),
                    icon: const Icon(Icons.directions_outlined),
                    label: const Text('View location on map'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: green),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Travel videos',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263A31),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Watch travel guides and explore videos on YouTube.',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                const SizedBox(height: 14),
                ...destination.videos.map(
                  (video) => Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => openExternalUrl(video.youtubeUrl),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 125,
                            height: 90,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  video.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const ColoredBox(
                                    color: Color(0xFFE5ECE7),
                                    child: Icon(Icons.landscape_rounded),
                                  ),
                                ),
                                const Center(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.play_arrow_rounded,
                                        color: green, size: 28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(video.creator,
                                      style: const TextStyle(
                                          color: muted, fontSize: 11)),
                                  const SizedBox(height: 5),
                                  const Row(
                                    children: [
                                      Icon(Icons.play_circle_outline,
                                          size: 15, color: green),
                                      SizedBox(width: 4),
                                      Text('Open on YouTube',
                                          style: TextStyle(
                                              color: green, fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.open_in_new_rounded,
                                color: muted, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            TicketBookingScreen(destination: destination),
                      ),
                    ),
                    icon: const Icon(Icons.confirmation_num_outlined),
                    label: const Text('Plan trip & book ticket'),
                    style: FilledButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: DestinationDetailsScreen.green, size: 21),
          const SizedBox(height: 9),
          Text(title,
              style: const TextStyle(color: DestinationDetailsScreen.muted,
                  fontSize: 11)),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF263A31),
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      ),
    );
  }
}
