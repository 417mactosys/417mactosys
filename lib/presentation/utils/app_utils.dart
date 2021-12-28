import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../infrastructure/api/api_service.dart';
import '../../infrastructure/core/pref_manager.dart';
import '../../infrastructure/services/push_notification_service.dart';
import '../../injection.dart';
import '../routes/routes.dart';

class AppUtils {
  static String getAvatar() {
    String avatar = Prefs.getString(Prefs.AVATAR, def: '');
    if (avatar.contains('http')) return avatar;
    return avatar.isNotEmpty
        ? 'https://wilotv.live:3443/' +
            'public/images/users/' +
            Prefs.getInt(Prefs.ID).toString() +
            '/128x128_' +
            avatar
        : '';
  }

  static String getUserAvatar(int id, String avatar) {
    if (avatar == null) {
      return '';
    }
    if (avatar.contains('firebase')) return avatar;
    if (avatar.contains('fb')) return avatar;
    return avatar.isNotEmpty
        ? 'https://wilotv.live:3443/' +
            'public/images/users/' +
            id.toString() +
            '/128x128_' +
            avatar
        : '';
  }

  static String getPostImage(int id, String image) {
    //return '${Routes.baseUrl}public/images/posts/$id/$image';
    return '$image';
  }

  static bool isRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(
        Localizations.localeOf(context).languageCode);
  }

  static String getFullName() {
    return Prefs.getString(Prefs.FIRST_NAME, def: '') +
        ' ' +
        Prefs.getString(Prefs.LAST_NAME, def: '');
  }

  static int getUserID() {
    return Prefs.getInt(Prefs.ID, def: -1);
  }

  //TODO add locale
  static String dateToFormattedDate(String date, bool showYear) {
    if (date == null) return '';

    DateTime dateTime = DateTime.parse(date);
    String formattedDate;
    showYear
        ? formattedDate = DateFormat.yMMMd().format(dateTime)
        : formattedDate = DateFormat.MMMd().format(dateTime);
    return formattedDate;
  }

  static String dateToDayOfMonth(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat.d().format(dateTime);
  }

  static String dateToMonth(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat.MMM().format(dateTime);
  }

  static String dateToHourMinute(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      DateTime now = DateTime.now();
      print(dateTime);
      print(now);
      //return DateFormat.Hm().format(dateTime);
      return intl.DateFormat('hh:mm aa', 'en-IN').format(dateTime);
    } catch (e) {
      return '';
    }

    //return 'here';
  }

  static String timeAgo(String date, {bool numericDates = false}) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      Duration diff = DateTime.now().difference(dateTime);
      if (diff.inMinutes < 60) {
        if (diff.inMinutes <= 0) return "Just now";
        return numericDates
            ? '${diff.inMinutes} ${diff.inMinutes > 1 ? 'Mins' : 'Min'} ago'
            : DateFormat.Hm().format(dateTime);
      }
      if (diff.inHours < 24)
        return numericDates
            ? '${diff.inHours} ${diff.inHours > 1 ? 'Hours' : 'Hour'} ago'
            : DateFormat.Hm().format(dateTime);
      if (diff.inDays < 2)
        return numericDates ? 'yesterday'.tr() : 'yesterday'.tr();
      if (diff.inDays < 3)
        return numericDates ? 'two_days_ago'.tr() : 'two_days_ago'.tr();
      if (diff.inDays < 4)
        return numericDates ? 'three_days_ago'.tr() : 'three_days_ago'.tr();
      if (diff.inDays < 365) return DateFormat('d MMM').format(dateTime);
      return DateFormat.yMMMd().format(dateTime);
    } catch (e) {
      return '';
    }
  }

  static void updateGcmToken() async {
    String token = await getIt<PushNotificationService>().initialise();
    if (token != Prefs.getString(Prefs.GCM_TOKEN, def: '') &&
        Prefs.getBool(Prefs.LOGIN_STATUS, def: false)) {
      final result = await getIt<HeyPApiService>().updateGcmToken(token);
      if (result.body.success) Prefs.setString(Prefs.GCM_TOKEN, token);
    }
  }
}
