import 'dart:convert';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsCarousel extends StatefulWidget {
  const AdsCarousel({super.key});

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  static const double _cardHeight = 120;
  static const double _iconSize = 56;
  static const String _adsJsonPath = 'assets/ads/ads.json';

  late final PageController _pageController;
  late final Future<List<AdPayload>> _adsFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _adsFuture = _loadAdPayloads();
  }

  Future<List<AdPayload>> _loadAdPayloads() async {
    try {
      final raw = await rootBundle.loadString(_adsJsonPath);
      final dynamic decoded = jsonDecode(raw);
      final List<dynamic> items;
      if (decoded is Map<String, dynamic>) {
        items = decoded['ads'] as List<dynamic>? ?? const [];
      } else if (decoded is List) {
        items = decoded;
      } else {
        items = const [];
      }

      final payloads = <AdPayload>[];
      for (final item in items) {
        if (item is Map) {
          payloads.add(AdPayload.fromJson(Map<String, dynamic>.from(item)));
        }
      }

      return payloads;
    } catch (_) {
      return const [];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return FutureBuilder<List<AdPayload>>(
      future: _adsFuture,
      builder: (context, snapshot) {
        final payloads = snapshot.data;
        final List<AdSlide> ads = payloads == null || payloads.isEmpty
            ? AdSlide.fallbackAds
                .map((s) => AdPayload.fallbackFromSlide(s).resolve(locale))
                .toList()
            : payloads.map((p) => p.resolve(locale)).toList();
        if (ads.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SizedBox(
              height: _cardHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  return _AdCard(
                    ad: ads[index],
                    iconSize: _iconSize,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SmoothPageIndicator(
              controller: _pageController,
              count: ads.length,
              effect: WormEffect(
                dotHeight: 6,
                dotWidth: 6,
                spacing: 6,
                dotColor: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                activeDotColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Loaded ad config with per-locale strings; [resolve] picks copy for [Locale].
class AdPayload {
  final String id;
  final Map<String, String> titleByLocale;
  final Map<String, String> subtitleByLocale;
  final String? legacyTitle;
  final String? legacySubtitle;
  final String iconPath;
  final String? urlAndroid;
  final String? urlIos;

  const AdPayload({
    required this.id,
    required this.titleByLocale,
    required this.subtitleByLocale,
    required this.iconPath,
    this.legacyTitle,
    this.legacySubtitle,
    this.urlAndroid,
    this.urlIos,
  });

  factory AdPayload.fromJson(Map<String, dynamic> json) {
    return AdPayload(
      id: json['id'] as String? ?? '',
      iconPath: json['iconPath'] as String? ?? '',
      urlAndroid: json['urlAndroid'] as String?,
      urlIos: json['urlIos'] as String?,
      titleByLocale: _parseStringMap(json['localized_title']),
      subtitleByLocale: _parseStringMap(json['localized_subtitle']),
      legacyTitle: json['title'] as String?,
      legacySubtitle: json['subtitle'] as String?,
    );
  }

  /// For English-only fallback rows from [AdSlide.fallbackAds].
  factory AdPayload.fallbackFromSlide(AdSlide slide) {
    return AdPayload(
      id: slide.id,
      iconPath: slide.iconPath,
      urlAndroid: slide.urlAndroid,
      urlIos: slide.urlIos,
      titleByLocale: const {},
      subtitleByLocale: const {},
      legacyTitle: slide.title,
      legacySubtitle: slide.subtitle,
    );
  }

  static Map<String, String> _parseStringMap(dynamic value) {
    if (value is! Map) return {};
    return value.map(
      (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
    );
  }

  AdSlide resolve(Locale locale) {
    return AdSlide(
      id: id,
      title: _pickLocalized(titleByLocale, legacyTitle, locale),
      subtitle: _pickLocalized(subtitleByLocale, legacySubtitle, locale),
      iconPath: iconPath,
      urlAndroid: urlAndroid,
      urlIos: urlIos,
    );
  }

  static String _pickLocalized(
    Map<String, String> map,
    String? legacy,
    Locale locale,
  ) {
    if (map.isNotEmpty) {
      final country = locale.countryCode;
      if (country != null && country.isNotEmpty) {
        final full = '${locale.languageCode}_$country';
        final v = map[full] ?? map['${locale.languageCode}_${country.toUpperCase()}'];
        if (v != null && v.isNotEmpty) return v;
      }
      final byLang = map[locale.languageCode];
      if (byLang != null && byLang.isNotEmpty) return byLang;
      final en = map['en'];
      if (en != null && en.isNotEmpty) return en;
    }
    return legacy ?? '';
  }
}

class _AdCard extends StatelessWidget {
  final AdSlide ad;
  final double iconSize;

  const _AdCard({required this.ad, required this.iconSize});

  Future<void> _openStoreUrl() async {
    final url = ad.storeUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLink = ad.storeUrl != null && ad.storeUrl!.isNotEmpty;
    final borderColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).canvasColor.withValues(alpha: 0.75)
        : Theme.of(context).canvasColor.withValues(alpha: 0.85);
    final child = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          _AdIcon(path: ad.iconPath, size: iconSize),
          const SizedBox(width: 12),
          Expanded(
            child: _AdText(
              title: ad.title,
              subtitle: ad.subtitle,
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: hasLink
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _openStoreUrl,
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
            )
          : child,
    );
  }
}

class _AdIcon extends StatelessWidget {
  final String path;
  final double size;

  const _AdIcon({required this.path, required this.size});

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return _placeholder();
    }

    final Widget image = Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: image,
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _AdText extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AdText({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodySmall?.color,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class AdSlide {
  final String id;
  final String title;
  final String subtitle;
  final String iconPath;
  final String? urlAndroid;
  final String? urlIos;

  const AdSlide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.urlAndroid,
    this.urlIos,
  });

  /// Returns the store URL for the current platform (Android or iOS).
  /// On web/other platforms returns Android link if present, otherwise iOS.
  String? get storeUrl {
    if (kIsWeb) return urlAndroid ?? urlIos;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return urlAndroid;
      case TargetPlatform.iOS:
        return urlIos;
      default:
        return urlAndroid ?? urlIos;
    }
  }

  static const List<AdSlide> fallbackAds = [
    AdSlide(
      id: 'ad_1',
      title: 'Flashcards',
      subtitle: 'Learn and remember new words with smart flashcards.',
      iconPath: 'assets/ads/cards.png',
      urlAndroid: 'https://play.google.com/store/apps/details?id=com.englishingames.englishcards',
      urlIos: 'https://apps.apple.com/us/app/english-vocab-words-duo-cards/id1658981786',
    ),
    AdSlide(
      id: 'ad_2',
      title: 'Listening by Books/Podcasts',
      subtitle: 'Listen, read along, and grow your comprehension.',
      iconPath: 'assets/ads/listening.png',
      urlAndroid: 'https://play.google.com/store/apps/details?id=com.englishingames.listening',
      urlIos: 'https://apps.apple.com/us/app/english-listening-by-podcast/id6447188725',
    ),
    AdSlide(
      id: 'ad_3',
      title: 'YouTube Double Subtitles',
      subtitle: 'Turn any YouTube video into a listening lesson.',
      iconPath: 'assets/ads/subtune.png',
      urlAndroid: 'https://apps.apple.com/us/app/subtune-listening-podcast/id6464495720',
      urlIos: 'https://elang.app/',
    ),
    AdSlide(
      id: 'ad_4',
      title: 'YouTube & Netflix trainers',
      subtitle: 'Repeat words from your subtitle translation history in quick, contextual drills',
      iconPath: 'assets/ads/tutor.png',
      urlAndroid: 'https://play.google.com/store/apps/details?id=com.englishingames.easy5',
      urlIos: 'https://apps.apple.com/us/app/english-words-new-vocabulary/id1622786750',
    ),
    AdSlide(
      id: 'verbs5',
      title: 'Irregular Verbs: Tutor',
      subtitle: '5 verbs. Every day.',
      iconPath: 'assets/ads/verbs5-225-72.png',
      urlAndroid: 'https://play.google.com/store/apps/details?id=com.englishingames.easy5verbs',
      urlIos: 'https://apps.apple.com/us/app/1638688704',
    ),
  ];
}
