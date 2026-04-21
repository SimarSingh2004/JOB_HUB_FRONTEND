import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/dio_client.dart';
import '../storage/secure_storage.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  final storage = ref.read(flutterSecureStorageProvider);
  return SecureStorage(storage);
});

final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.read(secureStorageProvider);
  return DioClient(secureStorage);
});
