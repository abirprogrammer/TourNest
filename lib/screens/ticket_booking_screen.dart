import 'package:flutter/material.dart';

import '../models/destination.dart';

class TicketBookingScreen extends StatefulWidget {
  final Destination destination;

  const TicketBookingScreen({super.key, required this.destination});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _travelDate;
  int _travellers = 1;

  static const green = Color(0xFF168765);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _travelDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && mounted) setState(() => _travelDate = picked);
  }

  void _submitBooking() {
    if (!_formKey.currentState!.validate()) return;
    if (_travelDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose your travel date.')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Request prepared'),
        content: Text(
          'Destination: ${widget.destination.name}\n'
          'Traveller(s): $_travellers\n'
          'Date: ${_travelDate!.day}/${_travelDate!.month}/${_travelDate!.year}\n\n'
          'This is a demo booking form. No ticket or payment has been created. '
          'Connect a booking provider/backend to confirm real tickets.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;

    return Scaffold(
      appBar: AppBar(title: const Text('Plan your trip')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              destination.imageUrl,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(height: 180, child: Icon(Icons.landscape)),
            ),
          ),
          const SizedBox(height: 18),
          Text(destination.name,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          Text(destination.location,
              style: const TextStyle(color: Color(0xFF75837A))),
          const SizedBox(height: 22),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Enter your full name'
                          : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.length < 7) return 'Enter a valid phone number';
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Card(
            elevation: 0,
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.calendar_month_rounded, color: green),
              title: const Text('Travel date'),
              subtitle: Text(
                _travelDate == null
                    ? 'Choose your preferred date'
                    : '${_travelDate!.day}/${_travelDate!.month}/${_travelDate!.year}',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _pickDate,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.groups_outlined, color: green),
              title: const Text('Travellers'),
              subtitle: const Text('Number of people'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _travellers > 1
                        ? () => setState(() => _travellers--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_travellers',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: _travellers < 20
                        ? () => setState(() => _travellers++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F4ED),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Estimated budget: ${destination.estimatedCost}\n'
              'Final prices depend on transport, season and providers.',
              style: const TextStyle(height: 1.5, color: Color(0xFF285B47)),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _submitBooking,
              icon: const Icon(Icons.confirmation_num_outlined),
              label: const Text('Continue booking'),
              style: FilledButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
