import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_quest/models/run_path_model.dart';

class PathFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String pathsCollection = 'run_paths';

  Future<String> savePath(RunPath path) async {
    final docRef = await _db.collection(pathsCollection).add(path.toMap());
    return docRef.id;
  }

  Stream<List<RunPath>> streamUserPaths(String userId) {
    return _db
        .collection(pathsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => RunPath.fromMap(doc.id, doc.data())).toList());
  }
}
