class ContactPerson {
  String? contactID;
  String? fullName;
  String? phone;
  String? address;
  String? patient;

  ContactPerson({
    this.contactID,
    this.fullName,
    this.phone,
    this.address,
    this.patient,
  });

  Map<String, dynamic> toJson() {
    return {
      'contactID': contactID,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'patient': patient,
    };
  }

  factory ContactPerson.fromJson(Map<String, dynamic> json) {
    return ContactPerson(
      contactID: json['contactID'].toString(),
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      patient: json['patient'].toString(),
    );
  }
}
