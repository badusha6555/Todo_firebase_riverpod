import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_basic/data/model/model.dart';

class FirestoreServices {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('todos');

  Future<void> addTodo(Model model) async {
    return await _collection.doc(model.id).set(model.toMap());
  }

  Stream<List<Model>> getTodos() {
    return _collection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Model.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateTodo(Model model, String id, {required String todoId}) {
    return _collection.doc(model.id).update(model.toMap());
  }

  Future<void> deleteTodo(String id) {
    return _collection.doc(id).delete();
  }
}
