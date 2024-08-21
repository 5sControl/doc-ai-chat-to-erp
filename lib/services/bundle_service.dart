import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

const postUrlDev = 'https://dev.elang.app/api/v1/users/subscriptions';
const postUrlProd = 'https://easy4learn.com/api/v1/users/subscriptions';

const getSubBundleInfoDev = 'https://dev.elang.app/api/v1/users/subscriptions?app=com.englishingames.summiShare&bundle=Premium%20Bundle%202';
const getSubBundleInfoProd = 'https://easy4learn.com/api/v1/users/subscriptions?app=com.englishingames.summiShare&bundle=Premium%20Bundle%202';

 
class BundleService {
  final _dio = Dio();
  // static const _sendEmailUrl =
  //     'https://easy4learn.com/django-api/applications/email/';
 
  // Future<String> bundleInfo() async {
  //   try {
  //     final response = await _dio.get(getSubBundleInfo);
 
  //     if (response.statusCode == 200) {
  //       final data = response.data as List<dynamic>;
 
  //       if (data.isNotEmpty) {
  //         String productStoreId = data.first['productStoreId'];
  //         return productStoreId;
  //       } else {
  //         throw Exception('No subscriptions found');
  //       }
  //     } else {
  //       throw Exception('Failed to load data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load data: $e');
  //   }
  // }

  Future<(String, String, bool)?> bundleInfo() async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final response = await _dio.get(
        getSubBundleInfoProd,
        options: Options(
          headers: {
            'Authorization': 'bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;

        if (data.isNotEmpty) {
          String productStoreId = data.first['productStoreId'] ?? 'bundle';
          String duration = data.first['duration'] ?? 'unknown';
          bool isFinished = data.first['isFinished'] as bool;
          return (productStoreId, duration, isFinished);
        } else {
          return null;
        }
      } else {
       return null;
      }
    } catch (e) {
      return null;
    }
  }
 
  Future<void> createSubscription(Map<String, String> subscriptionData) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    try {
      await _dio.post(postUrlProd,
          data: subscriptionData,
          options: Options(headers: {
            'Authorization': 'bearer $token',
          })); 
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}