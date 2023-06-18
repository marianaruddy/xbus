import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/models/ticket.dart';
import 'package:flutter/material.dart';

class TicketService {
  final CollectionReference ticketCollection = FirebaseFirestore.instance.collection('Ticket');

  Ticket createTicketInstance(doc) {
    bool? checked;
    bool active;
    String currentTripId;
    String? passangerId;
    String? stopId;

    if ((doc.data() as Map<String, dynamic>).containsKey('Checked')) {
      checked = doc['Checked'];
    } else {
      checked = false; // TODO ver oq fazer aqui (throw error?)
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('Active')) {
      active = doc['Active'];
    } else {
      active = false;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('CurrentTripId')) {
      currentTripId = doc['CurrentTripId'];
    } else {
      currentTripId = ''; // TODO ver oq fazer aqui (throw error?)
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('PassangerId')) {
      passangerId = doc['PassangerId'];
    } else {
      passangerId = null;
    }

    if ((doc.data() as Map<String, dynamic>).containsKey('StopId')) {
      stopId = doc['StopId'];
    } else {
      stopId = '';
    }

    return Ticket(
      id: doc.id,
      checked: checked,
      active: active,
      currentTripId: currentTripId,
      passangerId: passangerId,
      stopId: stopId,
    );
  }

  List<Ticket> _ticketFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) => (createTicketInstance(doc))).toList();
    } catch (e) {
      debugPrint('erro: $e');
      return [];
    }
  }

  Stream<List<Ticket>> get tickets {
    return ticketCollection.snapshots().map(_ticketFromSnapshot);
  }

  DocumentReference? getTicketRefById(String? id) {
    if (id != null) {
      return ticketCollection.doc(id);
    }
    return null;
  }

  Future updateTicket(docId, data) async {
    ticketCollection.doc(docId).update(data);
  }

  Future<List<Ticket?>> getTicketsInstances() {
    return ticketCollection.get().then((snapshot) {
      return snapshot.docs.map((doc) {
        if (doc.exists) {
          return createTicketInstance(doc);
        } else {
          return null;
        }
      }).toList();
    });
  }
}
