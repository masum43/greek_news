import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: non_constant_identifier_names
final db_categories =
    Firestore.instance.collection('data').document('categories');
