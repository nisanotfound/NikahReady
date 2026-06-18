import 'package:cloud_firestore/cloud_firestore.dart';

/// Status of a vendor booking, tracked as planning progresses.
enum VendorStatus { contacted, booked, confirmed, cancelled }

extension VendorStatusLabel on VendorStatus {
  String get label {
    switch (this) {
      case VendorStatus.contacted:
        return 'Contacted';
      case VendorStatus.booked:
        return 'Booked';
      case VendorStatus.confirmed:
        return 'Confirmed';
      case VendorStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// A single wedding vendor entry. Stored as its own document in the
/// `vendors` collection (per the data model) and linked back to the
/// owning user via [uid] so Firestore security rules can scope access.
class Vendor {
  final String id;
  final String name;
  final String contact;
  final String serviceType;
  final VendorStatus status;
  final DateTime createdAt;

  Vendor({
    required this.id,
    required this.name,
    required this.contact,
    required this.serviceType,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap(String uid) => {
        'uid': uid,
        'name': name,
        'contact': contact,
        'serviceType': serviceType,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory Vendor.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Vendor(
      id: doc.id,
      name: data['name'] ?? '',
      contact: data['contact'] ?? '',
      serviceType: data['serviceType'] ?? '',
      status: VendorStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => VendorStatus.contacted,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
