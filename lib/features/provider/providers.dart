import 'package:firebase_basic/core/services/firestore_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fireStoreServiceProvider = Provider((ref) => FirestoreServices());

final todoStreamProvider = StreamProvider((ref) {
  final firestoreService = ref.read(fireStoreServiceProvider);
  return firestoreService.getTodos();
});
