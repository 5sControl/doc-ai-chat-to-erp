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
  late final Future<List<AdSlide>> _adsFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _adsFuture = _loadAds();
  }

  Future<List<AdSlide>> _loadAds() async {
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

      final ads = <AdSlide>[];
      for (final item in items) {
        if (item is Map) {
          ads.add(AdSlide.fromJson(Map<String, dynamic>.from(item)));
        }
      }

      return ads.isEmpty ? AdSlide.fallbackAds : ads;
    } catch (_) {
      return AdSlide.fallbackAds;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AdSlide>>(
      future: _adsFuture,
      builder: (context, snapshot) {
        final ads = snapshot.data ?? AdSlide.fallbackAds;
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
    const borderBlue = Color(0xFF3490FA); // rgb(52, 144, 250)
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).canvasColor.withValues(alpha: 0.75)
        : Theme.of(context).canvasColor.withValues(alpha: 0.85);
    final child = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderBlue,
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

  factory AdSlide.fromJson(Map<String, dynamic> json) {
    return AdSlide(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      iconPath: json['iconPath'] as String? ?? '',
      urlAndroid: json['urlAndroid'] as String?,
      urlIos: json['urlIos'] as String?,
    );
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
      title: 'Listen and repeat guide',
      subtitle: 'Train your ear with short audio sessions every day.',
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
