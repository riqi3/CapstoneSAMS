class ContactPerson {
  final String contactId;
  final String fullName;
  final String phone;
  final String address;
  final String patient;

  ContactPerson({
    required this.contactId,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.patient,
  });

  Map<String, dynamic> toJson() {
    return {
      'contactId': contactId,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'patient': patient,
    };
  }

  factory ContactPerson.fromJson(Map<String, dynamic> json) {
    return ContactPerson(
      contactId: json['contactId'].toString(),
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      patient: json['patient'].toString(),
    );
  }
}
