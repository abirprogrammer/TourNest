import 'package:flutter/material.dart';
import '../controllers/app_state_controller.dart';
import '../services/l10n.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AppStateController _appState = AppStateController();
  bool _notificationsEnabled = true;
  String _currency = 'BDT (৳)';

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF168765);
    final lang = _appState.languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121A15) : const Color(0xFFF8FAF8);
    final cardColor = isDark ? const Color(0xFF1A2620) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF263A31);
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF8A9690);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          L10n.get('settings', lang),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
        ),
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            L10n.get('preferences', lang),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: mutedColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 30 : 5),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_rounded, color: primary),
                  title: Text(L10n.get('darkTheme', lang),
                      style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                  subtitle: Text(
                    isDark ? (lang == 'bn' ? 'ডার্ক মোড সক্রিয়' : 'Dark mode enabled') : (lang == 'bn' ? 'লাইট মোড সক্রিয়' : 'Light mode enabled'),
                    style: TextStyle(color: mutedColor, fontSize: 12),
                  ),
                  activeTrackColor: primary,
                  value: isDark,
                  onChanged: (val) {
                    _appState.setThemeMode(
                        val ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: isDark ? Colors.white12 : const Color(0xFFEEEEEE)),
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: primary),
                  title: Text(L10n.get('language', lang),
                      style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                  subtitle: Text(
                    lang == 'en' ? 'English' : 'বাংলা (Bengali)',
                    style: TextStyle(color: mutedColor, fontSize: 12),
                  ),
                  trailing: DropdownButton<String>(
                    value: lang,
                    dropdownColor: cardColor,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
                    ],
                    onChanged: (code) {
                      if (code != null) _appState.setLanguage(code);
                    },
                  ),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: isDark ? Colors.white12 : const Color(0xFFEEEEEE)),
                ListTile(
                  leading: const Icon(Icons.currency_exchange_rounded, color: primary),
                  title: Text(L10n.get('currency', lang),
                      style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                  subtitle: Text(_currency,
                      style: TextStyle(color: mutedColor, fontSize: 12)),
                  trailing: DropdownButton<String>(
                    value: _currency,
                    dropdownColor: cardColor,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'BDT (৳)', child: Text('BDT (৳)')),
                      DropdownMenuItem(value: 'USD (\$)', child: Text('USD (\$B)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _currency = val);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            L10n.get('supportAndInfo', lang),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: mutedColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 30 : 5),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_rounded,
                      color: primary),
                  title: Text(L10n.get('notifications', lang),
                      style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                  subtitle: Text(
                      lang == 'bn' ? 'ভ্রমণ অফার ও নোটিফিকেশন পান' : 'Receive travel deals & alerts',
                      style: TextStyle(color: mutedColor, fontSize: 12)),
                  activeTrackColor: primary,
                  value: _notificationsEnabled,
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: isDark ? Colors.white12 : const Color(0xFFEEEEEE)),
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded, color: primary),
                  title: Text(L10n.get('helpAndFaq', lang),
                      style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                  subtitle: Text(
                      lang == 'bn' ? 'সাধারণ জিজ্ঞাসা ও উত্তর' : 'Frequently asked questions',
                      style: TextStyle(color: mutedColor, fontSize: 12)),
                  trailing: Icon(Icons.chevron_right_rounded, color: textColor),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: cardColor,
                        title: Text(
                          lang == 'bn' ? 'সাহায্য ও জিজ্ঞাসা (FAQ)' : 'Help & FAQ',
                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          lang == 'bn'
                              ? 'ট্যুরনেস্ট হলো বাংলাদেশের সৌন্দর্য অন্বেষণের জন্য আপনার আল্টিমেট ট্রাভেল গাইড। '
                                  'আপনি গন্তব্য অন্বেষণ করতে পারেন, ইউটিউব ভিডিও দেখতে পারেন, ফেভারিট সেভ করতে পারেন এবং বুকিং পরিচালনা করতে পারেন।'
                              : 'TourNest is your ultimate travel guide for exploring Bangladesh. '
                                  'You can explore destinations, view YouTube guides, bookmark favorites, and plan bookings easily.',
                          style: TextStyle(color: mutedColor, height: 1.5),
                        ),
                        actions: [
                          FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: primary),
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(lang == 'bn' ? 'বুঝেছি' : 'Got it'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: isDark ? Colors.white12 : const Color(0xFFEEEEEE)),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded, color: primary),
                  title: Text(L10n.get('about', lang),
                      style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                  subtitle: Text(
                    L10n.get('version', lang),
                    style: TextStyle(color: mutedColor, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
