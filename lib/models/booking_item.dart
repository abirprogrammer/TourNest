class BookingItem {
  final String id;
  final String destinationName;
  final String location;
  final String imageUrl;
  final int travellers;
  final String date;
  final String estimatedCost;
  final String status;
  final String createdAt;

  BookingItem({
    required this.id,
    required this.destinationName,
    required this.location,
    required this.imageUrl,
    required this.travellers,
    required this.date,
    required this.estimatedCost,
    this.status = 'Confirmed',
    required this.createdAt,
  });
}
