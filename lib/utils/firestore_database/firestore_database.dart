import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection(
  'incidentReports',
);

class FirestoreDatabase {
  static String? userUid;

  static Future<void> addItem({
    required String title,
    required String description,
    required String incidentType,
    required String priority,
    required String image,
  }) async {
    DocumentReference documentReferencer = _mainCollection
        .doc(userUid)
        .collection('reports')
        .doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "incidentType": incidentType,
      "priority": priority,
      "createdDate": DateFormat("YYYY-MM-DD HH:MM").format(DateTime.now()),
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Notes item added to the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection = _mainCollection
        .doc(userUid)
        .collection('reports');

    return notesItemCollection.snapshots();
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _mainCollection
        .doc(userUid)
        .collection('reports')
        .doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteItem({required String docId}) async {
    DocumentReference documentReferencer = _mainCollection
        .doc(userUid)
        .collection('reports')
        .doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
