import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../services/summaryApi.dart';
import '../../services/document_api_service.dart';
import '../../services/document_api_models.dart';
import '../../services/demo_data_initializer.dart';
import 'package:json_annotation/json_annotation.dart';

import '../subscriptions/subscriptions_bloc.dart';

part 'summaries_event.dart';
part 'summaries_state.dart';
part 'summaries_bloc.g.dart';

const throttleDuration = Duration(milliseconds: 100);

/// Free tier: 1 summary per day (resets at midnight, policy A: blocked stay blocked).
const int freeDailyLimit = 1;

/// How many gift document slots one redeemed code adds.
const int giftCreditsPerCode = 10;

/// Valid gift codes (one-time use per user). Can be replaced with backend validation later.
const Set<String> validGiftCodes = {'SUMMIFY10', 'PROMO2024'};

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return concurrent<E>().call(events.throttle(duration), mapper);
  };
}

// summaries_bloc.dart

class SummariesBloc extends HydratedBloc<SummariesEvent, SummariesState> {
  final SubscriptionsBloc subscriptionBloc;
  final MixpanelBloc mixpanelBloc;
  late final StreamSubscription subscriptionBlocSubscription;
  final SummaryRepository summaryRepository = SummaryRepository();
  final DocumentApiService _documentApi = DocumentApiService();

  SummariesBloc({required this.subscriptionBloc, required this.mixpanelBloc})
      : super(const SummariesState(
          summaries: {},
          ratedSummaries: {},
          defaultSummaryType: SummaryType.short,
          textCounter: 1,
          freeSummariesUsedToday: 0,
          lastFreeSummaryDate: '',
          giftBalance: 0,
          redeemedGiftCodes: {},
          copyPasteRequiredForUrl: null,
        )) {
    subscriptionBlocSubscription = subscriptionBloc.stream.listen((state) {
      if (state.subscriptionStatus == SubscriptionStatus.subscribed) {
        add(const UnlockHiddenSummaries());
      }
    });

    on<GetSummaryFromUrl>(
      (event, emit) async {
        await _startSummaryLoading(
          summaryTitle: event.summaryUrl,
          summaryKey: event.summaryUrl,
          emit: emit,
          summaryOrigin: SummaryOrigin.url,
        );
        await _loadSummaryFromUrl(
          summaryKey: event.summaryUrl,
          fromShare: event.fromShare,
          emit: emit,
        );
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromText>(
      (event, emit) async {
        final index = state.textCounter;
        final title = "My text ($index)";

        await _startSummaryLoading(
          summaryTitle: title,
          summaryKey: title,
          emit: emit,
          summaryOrigin: SummaryOrigin.text,
        );
        await _loadSummaryFromText(
          text: event.text,
          summaryTitle: title,
          emit: emit,
        );
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<GetSummaryFromFile>(
      (event, emit) async {
        if (state.summaries[event.fileName]?.shortSummaryStatus !=
            SummaryStatus.loading) {
          await _startSummaryLoading(
            summaryTitle: event.fileName,
            summaryKey: event.fileName,
            emit: emit,
            summaryOrigin: SummaryOrigin.file,
          );
          await _loadSummaryFromFile(
            fileName: event.fileName,
            filePath: event.filePath,
            fromShare: event.fromShare,
            emit: emit,
          );
        }
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<DeleteSummary>((event, emit) async {
      await _deleteSummary(event.summaryUrl, emit);
      mixpanelBloc.add(const DeleteSummaryM());
    });

    on<FetchServerDocuments>((event, emit) async {
      await _fetchServerDocuments(emit);
    });

    on<RateSummary>((event, emit) async {
      await _rateSummary(event, emit);
    });

    on<SkipRateSummary>((event, emit) {
      _skipRateSummary(event.summaryUrl, emit);
    });

    on<UnlockHiddenSummaries>((event, emit) {
      final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
      summaryMap.updateAll(
        (key, value) {
          return value.copyWith(isBlocked: false);
        },
      );
      emit(state.copyWith(summaries: summaryMap));
    });

    on<IncrementFreeSummaries>(
      (event, emit) {
        final today = _todayDateString();
        final usedToday = _usedTodayEffective(state);
        if (state.lastFreeSummaryDate != today) {
          emit(state.copyWith(
            freeSummariesUsedToday: 1,
            lastFreeSummaryDate: today,
          ));
        } else {
          emit(state.copyWith(
            freeSummariesUsedToday: usedToday + 1,
          ));
        }
      },
    );

    on<CancelRequest>((event, emit) {
      // Implement cancel request logic if needed
    });

    on<InitializeDemo>((event, emit) {
      _initializeDemoData(emit);
    });

    on<RedeemGiftCode>((event, emit) {
      final code = event.code.trim().toUpperCase();
      if (validGiftCodes.contains(code) &&
          !state.redeemedGiftCodes.contains(code)) {
        final newRedeemed = Set<String>.from(state.redeemedGiftCodes)
          ..add(code);
        emit(state.copyWith(
          giftBalance: state.giftBalance + giftCreditsPerCode,
          redeemedGiftCodes: newRedeemed,
          lastRedeemMessage: 'success',
        ));
      } else {
        emit(state.copyWith(lastRedeemMessage: 'error'));
      }
    });

    on<UseGiftSlot>((event, emit) {
      if (state.giftBalance > 0) {
        emit(state.copyWith(giftBalance: state.giftBalance - 1));
      }
    });

    on<ClearRedeemMessage>((event, emit) {
      emit(state.copyWith(clearRedeemMessage: true));
    });

    on<ClearCopyPastePrompt>((event, emit) {
      emit(state.copyWith(clearCopyPastePrompt: true));
    });

    // Initialize demo data after state is loaded from storage
    add(const InitializeDemo());
  }

  @override
  SummariesState? fromJson(Map<String, dynamic> json) {
    // Migrate old format (freeSummaries) to daily limit format
    if (json.containsKey('freeSummaries') &&
        !json.containsKey('freeSummariesUsedToday')) {
      final migrated = Map<String, dynamic>.from(json)
        ..remove('freeSummaries')
        ..['freeSummariesUsedToday'] = 0
        ..['lastFreeSummaryDate'] = '';
      return SummariesState.fromJson(migrated);
    }
    // Ensure gift fields exist for older persisted state
    if (!json.containsKey('giftBalance')) {
      final withGift = Map<String, dynamic>.from(json)
        ..['giftBalance'] = 0
        ..['redeemedGiftCodes'] = json['redeemedGiftCodes'] ?? [];
      return SummariesState.fromJson(withGift);
    }
    return SummariesState.fromJson(json);
  }

  /// Effective count of free summaries used today (0 if we're on a new day).
  static int _usedTodayEffective(SummariesState state) {
    final today = _todayDateString();
    if (state.lastFreeSummaryDate != today) return 0;
    return state.freeSummariesUsedToday;
  }

  static String _todayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// True if free user has no slot left: daily limit used and no gift balance (for UI to show paywall before creating).
  static bool isFreeDailyLimitReached(
    SummariesState state,
    SubscriptionStatus subscriptionStatus,
  ) =>
      subscriptionStatus == SubscriptionStatus.unsubscribed &&
      _usedTodayEffective(state) >= freeDailyLimit &&
      state.giftBalance <= 0;

  @override
  Map<String, dynamic>? toJson(SummariesState state) {
    return state.toJson();
  }

  /// Initializes demo data on first app launch
  void _initializeDemoData(Emitter<SummariesState> emit) {
    // Check if demo summary already exists
    if (state.summaries.containsKey(DemoDataInitializer.demoKey)) {
      // Demo already exists, no need to initialize
      return;
    }

    // Create demo summary
    final demoSummary = DemoDataInitializer.createDemoSummary();

    // Add demo summary to state
    final updatedSummaries = Map<String, SummaryData>.from(state.summaries);
    updatedSummaries[DemoDataInitializer.demoKey] = demoSummary;

    // Add to rated summaries set
    final updatedRatedSummaries = Set<String>.from(state.ratedSummaries);
    updatedRatedSummaries.add(DemoDataInitializer.demoKey);

    // Emit updated state
    emit(
      state.copyWith(
        summaries: updatedSummaries,
        ratedSummaries: updatedRatedSummaries,
      ),
    );
  }

  Future<void> _startSummaryLoading({
    required String summaryKey,
    required String summaryTitle,
    required SummaryOrigin summaryOrigin,
    required Emitter<SummariesState> emit,
  }) async {
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap[summaryKey] = SummaryData(
      shortSummaryStatus: SummaryStatus.loading,
      longSummaryStatus: SummaryStatus.loading,
      date: DateTime.now(),
      shortSummary: const Summary(),
      longSummary: const Summary(),
      summaryPreview: SummaryPreview(
        title: summaryTitle,
        imageUrl: Assets.placeholderLogo.path,
      ),
      summaryOrigin: summaryOrigin,
    );
    emit(state.copyWith(summaries: summaryMap));
  }

  Future<void> _loadSummaryFromUrl({
    required String summaryKey,
    required bool fromShare,
    required Emitter<SummariesState> emit,
  }) async {
    try {
      // Step 1: Fetch article preview via v1 for fast UX (title + image).
      final article = await summaryRepository.getArticleByUrl(summaryKey);
      if (article == null) {
        throw Exception('Could not fetch article');
      }

      final articleTitle = article.title?.isNotEmpty == true
          ? article.title!
          : summaryKey.replaceAll('https://', '');

      {
        final summaryMap = Map<String, SummaryData>.from(state.summaries);
        summaryMap.update(summaryKey, (d) => d.copyWith(
          summaryPreview: SummaryPreview(
            title: articleTitle,
            imageUrl: article.imageUrl ?? Assets.placeholderLogo.path,
          ),
          userText: article.content,
        ));
        emit(state.copyWith(summaries: summaryMap));
      }

      // Step 2: Create document on server via v2 (short summary).
      DocumentDetailResponse? serverDoc;
      try {
        serverDoc = await _documentApi.createDocument(
          sourceType: 'url',
          title: articleTitle,
          sourceUrl: summaryKey,
          originalText: article.content,
          imageUrl: article.imageUrl,
          typeSummary: 'short',
        );
      } catch (e) {
        print('v2 createDocument failed, falling back to v1: $e');
      }

      Summary shortSummaryResult;
      String? serverId;

      if (serverDoc != null && serverDoc.shortSummary != null) {
        serverId = serverDoc.id;
        shortSummaryResult = Summary(
          summaryText: serverDoc.shortSummary,
          contextLength: serverDoc.contextLength,
        );
      } else {
        // Fallback: generate short summary via v1.
        final v1Result = await summaryRepository.getSummaryFromText(
          textToSummify: article.content,
          summaryType: SummaryType.short,
        );
        shortSummaryResult = v1Result is Summary
            ? v1Result
            : throw (v1Result is Exception ? v1Result : Exception('$v1Result'));
      }

      // Update state with short summary + serverId.
      {
        final summaryMap = Map<String, SummaryData>.from(state.summaries);
        summaryMap.update(summaryKey, (d) => d.copyWith(
          serverId: serverId,
          shortSummary: shortSummaryResult,
          shortSummaryStatus: SummaryStatus.complete,
        ));
        emit(state.copyWith(summaries: summaryMap));
      }

      // Step 3: Generate long summary via v1 (v2 only does one type).
      Summary longSummaryResult;
      final longResponse = await summaryRepository.getSummaryFromText(
        textToSummify: article.content,
        summaryType: SummaryType.long,
      );
      longSummaryResult = longResponse is Summary
          ? longResponse
          : Summary(summaryError: longResponse.toString().replaceAll('Exception:', ''));

      // Finalize: apply billing logic and emit complete state.
      final usedToday = _usedTodayEffective(state);
      final subscribed = subscriptionBloc.state.subscriptionStatus ==
          SubscriptionStatus.subscribed;
      final useDaily = !subscribed && usedToday < freeDailyLimit;
      final useGift =
          !subscribed && usedToday >= freeDailyLimit && state.giftBalance > 0;
      final isBlocked = !subscribed && !useDaily && !useGift;
      if (useDaily) add(const IncrementFreeSummaries());
      if (useGift) add(const UseGiftSlot());
      mixpanelBloc.add(SummarizingSuccess(url: summaryKey, fromShare: fromShare));

      final summaryMap = Map<String, SummaryData>.from(state.summaries);
      summaryMap.update(summaryKey, (d) => d.copyWith(
        isBlocked: isBlocked,
        longSummary: longSummaryResult,
        longSummaryStatus: longSummaryResult.summaryError != null
            ? SummaryStatus.error
            : SummaryStatus.complete,
      ));
      emit(state.copyWith(summaries: summaryMap));
    } catch (e) {
      if (e is PageCouldNotLoadException) {
        final newSummaries = Map<String, SummaryData>.from(state.summaries)
          ..remove(summaryKey);
        emit(state.copyWith(
          summaries: newSummaries,
          copyPasteRequiredForUrl: summaryKey,
        ));
        return;
      }
      final errMsg = e is Exception
          ? e.toString().replaceAll('Exception:', '')
          : e.toString();
      mixpanelBloc.add(SummarizingError(
        url: summaryKey, fromShare: fromShare, error: errMsg,
      ));
      final summaryMap = Map<String, SummaryData>.from(state.summaries);
      summaryMap.update(summaryKey, (d) => d.copyWith(
        shortSummary: Summary(summaryError: errMsg),
        longSummary: Summary(summaryError: errMsg),
        shortSummaryStatus: SummaryStatus.error,
        longSummaryStatus: SummaryStatus.error,
      ));
      emit(state.copyWith(summaries: summaryMap));
    }
  }

  Future<void> _loadSummaryFromText({
    required String summaryTitle,
    required String text,
    required Emitter<SummariesState> emit,
  }) async {
    try {
      // Step 1: Create document on server via v2 (short summary).
      DocumentDetailResponse? serverDoc;
      try {
        serverDoc = await _documentApi.createDocument(
          sourceType: 'text',
          title: summaryTitle,
          originalText: text,
          typeSummary: 'short',
        );
      } catch (e) {
        print('v2 createDocument failed, falling back to v1: $e');
      }

      Summary shortSummaryResult;
      String? serverId;

      if (serverDoc != null && serverDoc.shortSummary != null) {
        serverId = serverDoc.id;
        shortSummaryResult = Summary(
          summaryText: serverDoc.shortSummary,
          contextLength: serverDoc.contextLength,
        );
      } else {
        final v1 = await summaryRepository.getSummaryFromText(
          textToSummify: text, summaryType: SummaryType.short,
        );
        shortSummaryResult = v1 is Summary
            ? v1
            : throw (v1 is Exception ? v1 : Exception('$v1'));
      }

      // Update with short summary.
      {
        final m = Map<String, SummaryData>.from(state.summaries);
        m.update(summaryTitle, (d) => d.copyWith(
          serverId: serverId,
          userText: text,
          shortSummary: shortSummaryResult,
          shortSummaryStatus: SummaryStatus.complete,
        ));
        emit(state.copyWith(summaries: m));
      }

      // Step 2: Long summary via v1.
      Summary longSummaryResult;
      final longResp = await summaryRepository.getSummaryFromText(
        textToSummify: text, summaryType: SummaryType.long,
      );
      longSummaryResult = longResp is Summary
          ? longResp
          : Summary(summaryError: longResp.toString().replaceAll('Exception:', ''));

      // Billing + emit.
      final usedToday = _usedTodayEffective(state);
      final subscribed = subscriptionBloc.state.subscriptionStatus ==
          SubscriptionStatus.subscribed;
      final useDaily = !subscribed && usedToday < freeDailyLimit;
      final useGift =
          !subscribed && usedToday >= freeDailyLimit && state.giftBalance > 0;
      final isBlocked = !subscribed && !useDaily && !useGift;
      if (useDaily) add(const IncrementFreeSummaries());
      if (useGift) add(const UseGiftSlot());
      mixpanelBloc.add(
        const SummarizingSuccess(url: 'from text', fromShare: false),
      );

      final m = Map<String, SummaryData>.from(state.summaries);
      m.update(summaryTitle, (d) => d.copyWith(
        isBlocked: isBlocked,
        summaryOrigin: SummaryOrigin.text,
        longSummary: longSummaryResult,
        longSummaryStatus: longSummaryResult.summaryError != null
            ? SummaryStatus.error
            : SummaryStatus.complete,
      ));
      emit(state.copyWith(summaries: m, textCounter: state.textCounter + 1));
    } catch (e) {
      final errMsg = e.toString().replaceAll('Exception:', '');
      mixpanelBloc.add(SummarizingError(
        url: 'from Text', fromShare: false, error: errMsg,
      ));
      final m = Map<String, SummaryData>.from(state.summaries);
      m.update(summaryTitle, (d) => d.copyWith(
        summaryOrigin: SummaryOrigin.text,
        userText: text,
        shortSummary: Summary(summaryError: errMsg),
        longSummary: Summary(summaryError: errMsg),
        shortSummaryStatus: SummaryStatus.error,
        longSummaryStatus: SummaryStatus.error,
      ));
      emit(state.copyWith(summaries: m, textCounter: state.textCounter + 1));
    }
  }

  /// Backend reports multiple status values across legacy/new code paths:
  /// - `initial` / `loading` — still processing;
  /// - `done` / `complete` — summary ready;
  /// - `error` — something failed on the server.
  static bool _isServerDocPending(DocumentDetailResponse doc) {
    final s = doc.shortSummaryStatus.toLowerCase();
    return s == 'loading' || s == 'initial';
  }

  static bool _isServerDocError(String status) =>
      status.toLowerCase() == 'error';

  /// Poll `GET /api/v2/documents/{id}` until the short summary is ready.
  ///
  /// Used for audio uploads where transcription + summarisation happen
  /// asynchronously. The cap (2 minutes) matches typical Whisper `medium`
  /// runtime on CPU for short clips; larger files may time out here and
  /// fall through to the v1 fallback in the caller.
  Future<DocumentDetailResponse?> _pollDocumentUntilReady({
    required String documentId,
    required String fileName,
    required String filePath,
    required Emitter<SummariesState> emit,
    Duration interval = const Duration(seconds: 3),
    Duration maxWait = const Duration(minutes: 4),
  }) async {
    final deadline = DateTime.now().add(maxWait);
    while (DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(interval);
      final fresh = await _documentApi.getDocument(documentId);
      final status = fresh.shortSummaryStatus.toLowerCase();
      if (status != 'loading' && status != 'initial') {
        return fresh;
      }
    }
    return null;
  }

  Future<void> _loadSummaryFromFile({
    required String fileName,
    required String filePath,
    required bool fromShare,
    required Emitter<SummariesState> emit,
  }) async {
    try {
      // Step 1: Upload file to server via v2 (short summary).
      DocumentDetailResponse? serverDoc;
      try {
        serverDoc = await _documentApi.uploadDocument(
          filePath: filePath,
          fileName: fileName,
          typeSummary: 'short',
        );
      } catch (e) {
        print('v2 uploadDocument failed, falling back to v1: $e');
      }

      // Audio uploads return immediately with status == "loading" — poll the
      // backend until transcription + summarisation finish (or fail).
      if (serverDoc != null &&
          _isServerDocPending(serverDoc) &&
          serverDoc.shortSummary == null) {
        try {
          serverDoc = await _pollDocumentUntilReady(
            documentId: serverDoc.id,
            fileName: fileName,
            filePath: filePath,
            emit: emit,
          );
        } catch (e) {
          print('v2 polling failed: $e');
          serverDoc = null;
        }
      }

      Summary shortSummaryResult;
      String? serverId;
      String? originalText;

      if (serverDoc != null && serverDoc.shortSummary != null) {
        serverId = serverDoc.id;
        originalText = serverDoc.originalText;
        shortSummaryResult = Summary(
          summaryText: serverDoc.shortSummary,
          contextLength: serverDoc.contextLength,
        );
      } else if (serverDoc != null &&
          _isServerDocError(serverDoc.shortSummaryStatus)) {
        throw Exception('Server could not process the file');
      } else {
        final v1 = await summaryRepository.getSummaryFromFile(
          fileName: fileName, filePath: filePath, summaryType: SummaryType.short,
        );
        shortSummaryResult = v1 is Summary
            ? v1
            : throw (v1 is Exception ? v1 : Exception('$v1'));
      }

      // Update with short summary.
      {
        final m = Map<String, SummaryData>.from(state.summaries);
        m.update(fileName, (d) => d.copyWith(
          serverId: serverId,
          filePath: filePath,
          userText: originalText,
          shortSummary: shortSummaryResult,
          shortSummaryStatus: SummaryStatus.complete,
        ));
        emit(state.copyWith(summaries: m));
      }

      // Step 2: Long summary via v1.
      Summary longSummaryResult;
      if (originalText != null && originalText.isNotEmpty) {
        final longResp = await summaryRepository.getSummaryFromText(
          textToSummify: originalText, summaryType: SummaryType.long,
        );
        longSummaryResult = longResp is Summary
            ? longResp
            : Summary(summaryError: longResp.toString().replaceAll('Exception:', ''));
      } else {
        final longResp = await summaryRepository.getSummaryFromFile(
          fileName: fileName, filePath: filePath, summaryType: SummaryType.long,
        );
        longSummaryResult = longResp is Summary
            ? longResp
            : Summary(summaryError: longResp.toString().replaceAll('Exception:', ''));
      }

      // Billing + emit.
      final usedToday = _usedTodayEffective(state);
      final subscribed = subscriptionBloc.state.subscriptionStatus ==
          SubscriptionStatus.subscribed;
      final useDaily = !subscribed && usedToday < freeDailyLimit;
      final useGift =
          !subscribed && usedToday >= freeDailyLimit && state.giftBalance > 0;
      final isBlocked = !subscribed && !useDaily && !useGift;
      if (useDaily) add(const IncrementFreeSummaries());
      if (useGift) add(const UseGiftSlot());
      mixpanelBloc.add(SummarizingSuccess(url: fileName, fromShare: fromShare));

      final m = Map<String, SummaryData>.from(state.summaries);
      m.update(fileName, (d) => d.copyWith(
        isBlocked: isBlocked,
        longSummary: longSummaryResult,
        longSummaryStatus: longSummaryResult.summaryError != null
            ? SummaryStatus.error
            : SummaryStatus.complete,
      ));
      emit(state.copyWith(summaries: m));
    } catch (e) {
      final errMsg = e.toString().replaceAll('Exception:', '');
      mixpanelBloc.add(SummarizingError(
        url: fileName, fromShare: fromShare, error: errMsg,
      ));
      final m = Map<String, SummaryData>.from(state.summaries);
      m.update(fileName, (d) => d.copyWith(
        filePath: filePath,
        shortSummary: Summary(summaryError: errMsg),
        longSummary: Summary(summaryError: errMsg),
        shortSummaryStatus: SummaryStatus.error,
        longSummaryStatus: SummaryStatus.error,
      ));
      emit(state.copyWith(summaries: m));
    }
  }

  Future<void> _deleteSummary(String summaryUrl, Emitter<SummariesState> emit) async {
    final doc = state.summaries[summaryUrl];
    if (doc?.serverId != null) {
      try {
        await _documentApi.deleteDocument(doc!.serverId!);
      } catch (e) {
        print('v2 deleteDocument failed: $e');
      }
    }
    final Map<String, SummaryData> summaryMap = Map.from(state.summaries);
    summaryMap.remove(summaryUrl);
    emit(state.copyWith(summaries: summaryMap));
  }

  /// Fetches the user's document list from the server and merges into local state.
  Future<void> _fetchServerDocuments(Emitter<SummariesState> emit) async {
    try {
      final response = await _documentApi.listDocuments(page: 1, pageSize: 200);
      final serverDocs = response.items;
      final localIds = state.summaries.values
          .where((d) => d.serverId != null)
          .map((d) => d.serverId)
          .toSet();

      final summaryMap = Map<String, SummaryData>.from(state.summaries);
      for (final doc in serverDocs) {
        if (localIds.contains(doc.id)) continue;

        final key = doc.sourceUrl ?? doc.title;
        if (summaryMap.containsKey(key)) continue;

        // List endpoint only returns metadata, not summary text.
        // Use `initial` so the UI knows content must be fetched on open.
        summaryMap[key] = SummaryData(
          shortSummaryStatus: SummaryStatus.initial,
          longSummaryStatus: SummaryStatus.initial,
          date: doc.createdAt,
          summaryOrigin: _parseOrigin(doc.sourceType),
          shortSummary: const Summary(),
          longSummary: const Summary(),
          summaryPreview: SummaryPreview(
            title: doc.title,
            imageUrl: doc.imageUrl,
          ),
          isBlocked: doc.isBlocked,
          serverId: doc.id,
        );
      }

      if (summaryMap.length != state.summaries.length) {
        emit(state.copyWith(summaries: summaryMap));
      }
    } catch (e) {
      print('FetchServerDocuments failed: $e');
    }
  }

  static SummaryOrigin _parseOrigin(String sourceType) {
    switch (sourceType) {
      case 'url':
        return SummaryOrigin.url;
      case 'file':
        return SummaryOrigin.file;
      default:
        return SummaryOrigin.text;
    }
  }

  Future<void> _rateSummary(
      RateSummary event, Emitter<SummariesState> emit) async {
    final Set<String> ratedSummaries = Set.from(state.ratedSummaries);
    ratedSummaries.add(event.summaryUrl);

    await summaryRepository.sendSummaryRate(
      summaryLink: event.summaryUrl,
      summary: state.summaries[event.summaryUrl]?.shortSummary.summaryText ??
          state.summaries[event.summaryUrl]?.longSummary.summaryText ??
          '',
      rate: event.rate,
      device: event.device,
      comment: event.comment,
    );

    emit(state.copyWith(ratedSummaries: ratedSummaries));
  }

  void _skipRateSummary(String summaryUrl, Emitter<SummariesState> emit) {
    final Set<String> ratedSummaries = Set.from(state.ratedSummaries);
    ratedSummaries.add(summaryUrl);
    emit(state.copyWith(ratedSummaries: ratedSummaries));
  }
}
