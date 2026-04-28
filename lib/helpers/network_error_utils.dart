import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:summify/l10n/app_localizations.dart';

const String kNetworkUnavailableErrorCode = 'network_unavailable';

bool isNetworkError(Object error) {
  if (error is SocketException) return true;
  if (error is DioException) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        (error.type == DioExceptionType.unknown &&
            error.error is SocketException);
  }
  return false;
}

String normalizeUiError(Object error) {
  if (isNetworkError(error)) return kNetworkUnavailableErrorCode;
  return error.toString().replaceAll('Exception:', '').trim();
}

String localizeUiError(BuildContext context, String? rawMessage) {
  final l10n = AppLocalizations.of(context);
  if (rawMessage == null || rawMessage.isEmpty) return l10n.common_error;
  if (rawMessage.trim() == kNetworkUnavailableErrorCode) {
    return l10n.common_networkUnavailable;
  }
  return rawMessage;
}
