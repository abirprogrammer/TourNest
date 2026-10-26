import 'package:flutter/material.dart';

import '../controllers/app_state_controller.dart';
import '../models/booking_item.dart';
import '../services/l10n.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final AppStateController _appState = AppStateController();

  static const Color _primary = Color(0xFF168765);
  static const Color _primaryDark = Color(0xFF0D6650);

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onBookingsChanged);
  }

  void _onBookingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _appState.removeListener(_onBookingsChanged);
    super.dispose();
  }

  Future<void> _showAddBookingSheet() async {
    final lang = _appState.languageCode;

    final bool? added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (sheetContext) {
        return _AddBookingSheet(
          language: lang,
          onSave: (name, location, cost) {
            final booking = BookingItem(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              destinationName: name,
              location: location,
              imageUrl:
                  'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b'
                  '?auto=format&fit=crop&w=900&q=85',
              travellers: 1,
              date: 'Upcoming',
              estimatedCost: cost,
              status: 'Planned',
              createdAt: 'Today',
            );

            _appState.addBooking(booking);
          },
        );
      },
    );

    if (!mounted) return;

    if (added == true) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: _primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.all(16),
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Booking added successfully!',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Future<void> _confirmDelete(BookingItem booking) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF18352D);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1A2620) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          title: Row(
            children: [
              const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFE05252),
                size: 27,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Delete booking?',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to remove "${booking.destinationName}" '
            'from your bookings?',
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF7C9189),
              height: 1.5,
              fontSize: 14,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                side: BorderSide(
                    color: isDark ? Colors.white24 : const Color(0xFFE1EAE6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Delete'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE05252),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    _appState.removeBooking(booking.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: const Text('Booking removed.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = _appState.languageCode;
    final bookings = _appState.bookings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121A15) : const Color(0xFFF5F8F7);
    final textColor = isDark ? Colors.white : const Color(0xFF18352D);
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF7C9189);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.get('bookings', lang),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: textColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              lang == 'bn' ? 'আপনার পরবর্তী ভ্রমণ শুরু হোক এখান থেকে' : 'Your next adventure starts here',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: mutedColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Material(
              color: isDark ? const Color(0xFF1F2E26) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: _showAddBookingSheet,
                borderRadius: BorderRadius.circular(14),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.add_location_alt_rounded,
                    color: _primary,
                    size: 23,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: bookings.isEmpty
          ? _buildEmptyState(lang, isDark, textColor, mutedColor)
          : Column(
              children: [
                _buildSummary(bookings.length, lang),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 110),
                    itemCount: bookings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _buildBookingCard(bookings[index], isDark, textColor, mutedColor, lang);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: _buildAddButton(lang),
    );
  }

  Widget _buildSummary(int count, String lang) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primary, _primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.luggage_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang == 'bn' ? 'আপনার ট্রিপ প্ল্যান' : 'Your travel plans',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lang == 'bn' ? '$count টি বুকিং সংরক্ষিত' : '$count ${count == 1 ? 'booking' : 'bookings'} saved',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.explore_rounded,
            color: Colors.white70,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String lang, bool isDark, Color textColor, Color mutedColor) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 110),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2E26) : const Color(0xFFE5F3ED),
                borderRadius: BorderRadius.circular(45),
              ),
              child: const Icon(
                Icons.travel_explore_rounded,
                size: 75,
                color: _primary,
              ),
            ),
            const SizedBox(height: 26),
            Text(
              lang == 'bn' ? 'আপনার পরবর্তী রোমাঞ্চ অপেক্ষা করছে!' : 'Your next adventure awaits!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                height: 1.25,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              lang == 'bn'
                  ? 'আপনার স্বপ্নের গন্তব্য সংরক্ষণ করুন, বাজেট পরিকল্পনা করুন এবং সমস্ত ভ্রমণ ধারণা এক জায়গায় রাখুন।'
                  : 'Save your dream destinations, plan your budget, and keep all your travel ideas in one place.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedColor,
                height: 1.6,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 26),
            _buildInlineAddButton(lang),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingItem booking, bool isDark, Color textColor, Color mutedColor, String lang) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2620) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xFFEAF0ED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 88,
                    height: 100,
                    child: Image.network(
                      booking.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return Container(
                          color: const Color(0xFFE7F1EC),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _primary,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: const Color(0xFFE7F1EC),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.landscape_rounded,
                            size: 34,
                            color: _primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              booking.destinationName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                height: 1.25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          _statusBadge(booking.status),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: _primary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              booking.location,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: [
                          _buildInfoChip(
                            Icons.people_alt_rounded,
                            '${booking.travellers} ${booking.travellers == 1 ? (lang == 'bn' ? 'ভ্রমণকারী' : 'traveller') : (lang == 'bn' ? 'ভ্রমণকারীগণ' : 'travellers')}',
                            isDark,
                            textColor,
                          ),
                          _buildInfoChip(
                            Icons.calendar_month_rounded,
                            booking.date,
                            isDark,
                            textColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Divider(
                height: 1,
                color: isDark ? Colors.white12 : const Color(0xFFEDF2EF)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: _primary,
                  size: 19,
                ),
                const SizedBox(width: 7),
                Text(
                  L10n.get('estimatedBudget', lang),
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    booking.estimatedCost,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: _primaryDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Material(
                  color: isDark ? const Color(0xFF332020) : const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(11),
                  child: InkWell(
                    onTap: () => _confirmDelete(booking),
                    borderRadius: BorderRadius.circular(11),
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFD94A4A),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final normalized = status.toLowerCase();
    final isCompleted = normalized == 'completed';
    final isCancelled = normalized == 'cancelled';

    final Color color = isCompleted
        ? const Color(0xFF23845D)
        : isCancelled
            ? const Color(0xFFD94A4A)
            : _primary;

    return Container(
      constraints: const BoxConstraints(maxWidth: 92),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, bool isDark, Color textColor) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF24362D) : const Color(0xFFF3F7F5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _primary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String lang) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 4, bottom: 4),
        child: Material(
          color: Colors.transparent,
          elevation: 8,
          shadowColor: _primary.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: _showAddBookingSheet,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primary, _primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 21,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      L10n.get('addCustomSpot', lang),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInlineAddButton(String lang) {
    return SizedBox(
      height: 54,
      child: FilledButton.icon(
        onPressed: _showAddBookingSheet,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(
          lang == 'bn' ? 'আপনার প্রথম গন্তব্য যোগ করুন' : 'Add your first destination',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Premium Add Booking Bottom Sheet
// -----------------------------------------------------------------------------

class _AddBookingSheet extends StatefulWidget {
  const _AddBookingSheet({
    required this.language,
    required this.onSave,
  });

  final String language;
  final void Function(String name, String location, String cost) onSave;

  @override
  State<_AddBookingSheet> createState() => _AddBookingSheetState();
}

class _AddBookingSheetState extends State<_AddBookingSheet> {
  static const Color _primary = Color(0xFF168765);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController(
    text: 'Bangladesh',
  );
  final _costController = TextEditingController(
    text: 'BDT 5,000',
  );

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      widget.onSave(
        _nameController.text.trim(),
        _locationController.text.trim().isEmpty
            ? 'Bangladesh'
            : _locationController.text.trim(),
        _costController.text.trim().isEmpty
            ? 'BDT 5,000'
            : _costController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save booking. Please try again.'),
          backgroundColor: Color(0xFFD94A4A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1A2620) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF18352D);
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF7C9189);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : const Color(0xFFDCE6E1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF168765),
                            Color(0xFF0D6650),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.add_location_alt_rounded,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            L10n.get('addCustomSpot', widget.language),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.language == 'bn' ? 'নতুন ভ্রমণ পরিকল্পনা তৈরি করুন' : 'Create a new travel plan',
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.close_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF26382F) : const Color(0xFFF2F6F4),
                        foregroundColor: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Text(
                  widget.language == 'bn' ? 'গন্তব্যের নাম *' : 'DESTINATION NAME *',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                TextFormField(
                  controller: _nameController,
                  autofocus: false,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  maxLength: 60,
                  style: TextStyle(color: textColor),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return widget.language == 'bn' ? 'দয়া করে গন্তব্যের নাম লিখুন' : 'Please enter a destination name';
                    }
                    if (value.trim().length < 2) {
                      return widget.language == 'bn' ? 'কমপক্ষে ২ অক্ষর লিখুন' : 'Enter at least 2 characters';
                    }
                    return null;
                  },
                  decoration: _inputDecoration(
                    hint: widget.language == 'bn' ? 'যেমন: কক্সবাজার' : 'e.g. Cox’s Bazar',
                    icon: Icons.landscape_rounded,
                    isDark: isDark,
                  ).copyWith(counterText: ''),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.language == 'bn' ? 'অবস্থান (LOCATION)' : 'LOCATION',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                TextFormField(
                  controller: _locationController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  maxLength: 80,
                  style: TextStyle(color: textColor),
                  decoration: _inputDecoration(
                    hint: widget.language == 'bn' ? 'শহর, দেশ' : 'City, country',
                    icon: Icons.location_on_outlined,
                    isDark: isDark,
                  ).copyWith(counterText: ''),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.language == 'bn' ? 'আনুমানিক বাজেট (ESTIMATED BUDGET)' : 'ESTIMATED BUDGET',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                TextFormField(
                  controller: _costController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  maxLength: 40,
                  style: TextStyle(color: textColor),
                  decoration: _inputDecoration(
                    hint: 'e.g. BDT 5,000',
                    icon: Icons.account_balance_wallet_outlined,
                    isDark: isDark,
                  ).copyWith(counterText: ''),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF23362C) : const Color(0xFFF0F8F4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFDDEFE5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: _primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.language == 'bn'
                              ? 'আপনি আপনার ভ্রমণের পরিকল্পনা পরে আপডেট করতে পারেন। আপনার ট্রিপ গুছিয়ে রাখতে সঠিক বাজেট দিন।'
                              : 'You can update your travel plan later. Add a realistic budget to help organize your trip.',
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _isSaving ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: _primary,
                      disabledBackgroundColor:
                          _primary.withValues(alpha: 0.55),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 23,
                            height: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded),
                              const SizedBox(width: 10),
                              Text(
                                widget.language == 'bn' ? 'বুকিং সংরক্ষণ করুন' : 'Save Booking',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? Colors.white38 : const Color(0xFFA0B0A9),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: _primary,
        size: 21,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF22332A) : const Color(0xFFF7F9F8),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDark ? Colors.white24 : const Color(0xFFE5ECE8),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDark ? Colors.white24 : const Color(0xFFE5ECE8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: _primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFD94A4A),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFD94A4A),
          width: 1.5,
        ),
      ),
    );
  }
}
