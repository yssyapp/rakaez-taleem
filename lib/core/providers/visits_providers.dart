import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/visit.dart';
import '../services/visits_service.dart';

final visitsServiceProvider = Provider<VisitsService>((ref) => VisitsService());

final visitsStreamProvider = StreamProvider<List<Visit>>((ref) {
  return ref.watch(visitsServiceProvider).watchVisits();
});
