import 'dart:io';

enum PlatformType { android, iOS }

class PlatformData {
  factory PlatformData.fromJson(Map<String, dynamic> json) {
    if (Platform.isAndroid) {
      final data = json['android'] as Map<String, dynamic>;
      return PlatformData(
        platform: PlatformType.android,
        minVersion: data['minVersion'] as String,
        status: data['status'] as bool,
        paymentStatus: data['paymentStatus'] as bool?,
      );
    } else {
      final data = json['iOS'] as Map<String, dynamic>;
      return PlatformData(
        platform: PlatformType.iOS,
        minVersion: data['minVersion'] as String,
        status: data['status'] as bool,
        paymentStatus: data['paymentStatus'] as bool?,
      );
    }
  }
  const PlatformData({
    required this.platform,
    required this.minVersion,
    required this.status,
    this.paymentStatus,
  });

  final PlatformType platform;
  final String minVersion;
  final bool status;
  final bool? paymentStatus;

  Map<String, dynamic> toJson() {
    final key = platform == PlatformType.iOS ? 'iOS' : 'android';
    return {
      key: {
        'minVersion': minVersion,
        'status': status,
        if (paymentStatus != null) 'paymentStatus': paymentStatus,
      },
    };
  }
}
