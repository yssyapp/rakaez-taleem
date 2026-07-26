import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/visit.dart';

class VisitsService {
  final CollectionReference<Map<String, dynamic>> _collection;

  VisitsService({FirebaseFirestore? firestore})
      : _collection =
            (firestore ?? FirebaseFirestore.instance).collection('visits');

  Stream<List<Visit>> watchVisits() {
    return _collection.orderBy('dateTime').snapshots().map(
          (snap) =>
              snap.docs.map((d) => Visit.fromMap(d.id, d.data())).toList(),
        );
  }

  Future<void> addVisit(Visit visit) {
    return _collection.add(visit.toMap());
  }

  Future<void> updateStatus(String id, VisitStatus status) {
    return _collection.doc(id).update({'status': status.name});
  }

  Future<void> deleteVisit(String id) {
    return _collection.doc(id).delete();
  }
}
